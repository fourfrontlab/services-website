import sys
from PIL import Image
import numpy as np

def find_y_bounds(image_path, x, label):
    img = Image.open(image_path).convert('RGB')
    arr = np.array(img)
    ref = np.array([9, 26, 52])
    
    col = arr[:, x, :]
    
    is_navy = np.linalg.norm(col - ref, axis=1) < 60
    
    # top card: between y=100 and y=380
    top_y = np.where(is_navy[100:380])[0] + 100
    # bottom card: between y=380 and y=680
    bottom_y = np.where(is_navy[380:680])[0] + 380
    
    if len(top_y) > 0:
        print(f"{label} Top Card Y: start={top_y[0]}, end={top_y[-1]}, height={top_y[-1] - top_y[0] + 1}")
    else:
        print(f"{label} Top Card Y: none found")
        
    if len(bottom_y) > 0:
        print(f"{label} Bottom Card Y: start={bottom_y[0]}, end={bottom_y[-1]}, height={bottom_y[-1] - bottom_y[0] + 1}")
    else:
        print(f"{label} Bottom Card Y: none found")

if __name__ == '__main__':
    # test left cards
    find_y_bounds(r"c:\forfront lab\salman website\services-website\public\assets\aster-main-banner.jpg", 720, "Left (x=720)")
    find_y_bounds(r"c:\forfront lab\salman website\services-website\public\assets\aster-main-banner.jpg", 950, "Left (x=950)")
    
    # test right cards
    find_y_bounds(r"c:\forfront lab\salman website\services-website\public\assets\aster-main-banner.jpg", 1030, "Right (x=1030)")
    find_y_bounds(r"c:\forfront lab\salman website\services-website\public\assets\aster-main-banner.jpg", 1250, "Right (x=1250)")
