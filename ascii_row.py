import sys
from PIL import Image
import numpy as np

def print_ascii_row(image_path, y):
    img = Image.open(image_path).convert('RGB')
    arr = np.array(img)
    
    row = arr[y, :, :]
    
    line = ""
    # Look for navy color. Left card color was [9, 26, 52]
    # We will compute distance to [9, 26, 52]
    ref = np.array([9, 26, 52])
    for x in range(600, 1350, 2): # step by 2
        color = row[x]
        dist = np.linalg.norm(color - ref)
        if dist < 60:
            line += "#"
        else:
            line += "."
            
    # Also print scale
    scale = ""
    for x in range(600, 1350, 2):
        if x % 50 == 0:
            scale += "|"
        elif x % 10 == 0:
            scale += "+"
        else:
            scale += " "
            
    print(f"Row {y}:")
    print(scale)
    print(line)
    print(f"600{' '*23}650{' '*23}700{' '*23}750{' '*23}800{' '*23}850{' '*23}900{' '*23}950{' '*23}1000{' '*22}1050{' '*22}1100{' '*22}1150{' '*22}1200{' '*22}1250{' '*22}1300{' '*22}1350")
    
if __name__ == '__main__':
    print_ascii_row(r"c:\forfront lab\salman website\services-website\public\assets\aster-main-banner.jpg", 200)
    print_ascii_row(r"c:\forfront lab\salman website\services-website\public\assets\aster-main-banner.jpg", 500)
