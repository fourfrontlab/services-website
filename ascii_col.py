import sys
from PIL import Image
import numpy as np

def print_ascii_col(image_path, x, y_start, y_end):
    img = Image.open(image_path).convert('RGB')
    arr = np.array(img)
    
    col = arr[y_start:y_end, x, :]
    
    ref = np.array([9, 26, 52])
    for i, y in enumerate(range(y_start, y_end)):
        color = col[i]
        dist = np.linalg.norm(color - ref)
        if dist < 60:
            print(f"{y:03d} #")
        else:
            print(f"{y:03d} .")

if __name__ == '__main__':
    print("Col x=720:")
    print_ascii_col(r"c:\forfront lab\salman website\services-website\public\assets\aster-main-banner.jpg", 720, 330, 420)
    print("Col x=950:")
    print_ascii_col(r"c:\forfront lab\salman website\services-website\public\assets\aster-main-banner.jpg", 950, 330, 420)
