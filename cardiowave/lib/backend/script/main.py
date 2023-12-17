import sys

import cv2
import os
import numpy as np
import pandas as pd
from PIL import Image
from sklearn.cluster import KMeans

PIXELS_TO_CM = 2.5 / 89

def image_to_pandas(image):
    df = pd.DataFrame([image[:, :, 0].flatten(),
                       image[:, :, 1].flatten(),
                       image[:, :, 2].flatten()]).T
    df.columns = ['Red_Channel', 'Green_Channel', 'Blue_Channel']
    return df


def load_images(path):
    myList = [img for img in os.listdir(path) if img.lower().endswith(('.jpg', '.png'))]
    images_list = []

    for img_name in myList:
        img_path = os.path.join(path, img_name)
        img = cv2.imread(img_path)
        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        images_list.append((img_rgb, img_name))

    return images_list


def process_image(img_rgb):
    height, width, _ = img_rgb.shape
    crop_width = width // 4

    cropped_img = img_rgb[:, crop_width:3 * crop_width, :]
    cropped_img = cropped_img[:height // 2, :, :]

    final_cropped_img = cropped_img[height // 4:, :, :]

    rotation_matrix = cv2.getRotationMatrix2D((img_rgb.shape[1] / 2, img_rgb.shape[0] / 2), +5, 1)
    final_cropped_img = cv2.warpAffine(final_cropped_img, rotation_matrix,
                                       (final_cropped_img.shape[1], final_cropped_img.shape[0]))

    df_img = image_to_pandas(final_cropped_img)
    kmeans = KMeans(n_clusters=3, random_state=42, init='k-means++', n_init=15).fit(df_img)
    clustered_result = kmeans.labels_.reshape(final_cropped_img.shape[0], final_cropped_img.shape[1])

    img_clustered = np.zeros_like(final_cropped_img)
    img_clustered[:, :, 0] = kmeans.cluster_centers_[clustered_result, 0]
    img_clustered[:, :, 1] = kmeans.cluster_centers_[clustered_result, 1]
    img_clustered[:, :, 2] = kmeans.cluster_centers_[clustered_result, 2]

    gray = cv2.cvtColor(img_clustered, cv2.COLOR_RGB2GRAY)
    gray_blurred = cv2.GaussianBlur(gray, (5, 5), 0)
    edges = cv2.Canny(gray_blurred, 50, 150)

    lines = cv2.HoughLinesP(edges, 1, np.pi / 180, threshold=20, minLineLength=55, maxLineGap=25)

    if lines is not None:
        middle_point = (final_cropped_img.shape[1] // 2, final_cropped_img.shape[0] // 2)

        upper_lines = []
        lower_lines = []

        for line in lines:
            x1, y1, x2, y2 = line[0]
            if x2 - x1 != 0:
                if (y1 + y2) // 2 < middle_point[1]:
                    upper_lines.append(line)
                else:
                    lower_lines.append(line)

        closest_lines = None
        min_distance_between_lines = float('inf')

        for upper_line in upper_lines:
            for lower_line in lower_lines:
                if not (upper_line[0][0] == lower_line[0][0] and upper_line[0][2] == lower_line[0][2]):

                    distance_between_lines = ((upper_line[0][0] + upper_line[0][2]) // 2 -
                                              (lower_line[0][0] + lower_line[0][2]) // 2) ** 2 + \
                                             ((upper_line[0][1] + upper_line[0][3]) // 2 -
                                              (lower_line[0][1] + lower_line[0][3]) // 2) ** 2

                    if 0.05 < abs(
                            (lower_line[0][1] - lower_line[0][3]) / (lower_line[0][0] - lower_line[0][2])) < 0.2 and \
                            0.05 < abs(
                        (upper_line[0][1] - upper_line[0][3]) / (upper_line[0][0] - upper_line[0][2])) < 0.2 and \
                            distance_between_lines < min_distance_between_lines:
                        min_distance_between_lines = distance_between_lines
                        closest_lines = (upper_line, lower_line)

        if closest_lines is not None:
            x1, y1, x2, y2 = closest_lines[0][0]
            cv2.line(img_clustered, (x1, y1), (x2, y2), (0, 255, 0), 2)

            x1, y1, x2, y2 = closest_lines[1][0]
            cv2.line(img_clustered, (x1, y1), (x2, y2), (0, 255, 0), 2)

            distance = np.sqrt(((closest_lines[0][0][0] + closest_lines[0][0][2]) // 2 -
                                (closest_lines[1][0][0] + closest_lines[1][0][2]) // 2) ** 2 +
                               ((closest_lines[0][0][1] + closest_lines[0][0][3]) // 2 -
                                (closest_lines[1][0][1] + closest_lines[1][0][3]) // 2) ** 2)

            distance_cm = distance * PIXELS_TO_CM

            print(f"{distance_cm:.2f}")

            upper_middle_point = ((closest_lines[0][0][0] + closest_lines[0][0][2]) // 2,
                                  (closest_lines[0][0][1] + closest_lines[0][0][3]) // 2)

            lower_middle_point = ((closest_lines[1][0][0] + closest_lines[1][0][2]) // 2,
                                  (closest_lines[1][0][1] + closest_lines[1][0][3]) // 2)

            perpendicular_line = [upper_middle_point[0], upper_middle_point[1],
                                  lower_middle_point[0], lower_middle_point[1]]

            cv2.line(img_clustered, (perpendicular_line[0], perpendicular_line[1]),
                     (perpendicular_line[2], perpendicular_line[3]), (255, 0, 0), 2)

    return final_cropped_img, img_clustered, distance_cm


def save_image_to_output(img, image_out_path):
    image = Image.fromarray(img)
    image = image.resize((400, 400))
    image.save(os.path.join(image_out_path, 'cardiowave_output.jpg'))


if __name__ == "__main__":
    image_input_path = sys.argv[1]
    image_output_path = sys.argv[2]

    images_list = load_images(image_input_path)

    img_rgb, img_clustered, distance = process_image(images_list[0][0])

    save_image_to_output(img_clustered, image_output_path)

