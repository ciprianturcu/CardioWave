import sys

from PyQt6.QtWidgets import QApplication, QLabel, QWidget

# Create an instance of QApplication
app = QApplication([])

# Create application GUI
window = QWidget()
window.setWindowTitle("PyQt App")
window.setGeometry(100, 100, 280, 80)
helloMsg = QLabel("<h1>Hello, World!</h1>", parent=window)
helloMsg.move(60, 15)

# Show application GUI
window.show()

# Run application event loop
sys.exit(app.exec())