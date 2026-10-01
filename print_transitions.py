import sys
from PIL import Image
import numpy as np

def print_transitions(image_path, row_y, col_x_1, col_x_2):
    img = Image.open(image_path).convert('RGB')
    arr = np.array(img)
    
    ref = np.array([9, 26, 52])
    
    # Check X transitions for row_y
    row = arr[row_y, :, :]
    in_card = False
    start_x = -1
    segments_x = []
    for x in range(600, 1350):
        color = row[x]
        dist = np.linalg.norm(color - ref)
        is_navy = dist < 60
        if is_navy and not in_card:
            in_card = True
            start_x = x
        elif not is_navy and in_card:
            in_card = False
            segments_x.append((start_x, x-1, x-start_x))
            
    if in_card:
        segments_x.append((start_x, 1350, 1350-start_x))
        
    print(f"X segments for y={row_y}: {segments_x}")
    
    # Check Y transitions for col_x_1
    col1 = arr[:, col_x_1, :]
    in_card = False
    start_y = -1
    segments_y1 = []
    for y in range(0, 700):
        color = col1[y]
        dist = np.linalg.norm(color - ref)
        is_navy = dist < 60
        if is_navy and not in_card:
            in_card = True
            start_y = y
        elif not is_navy and in_card:
            in_card = False
            segments_y1.append((start_y, y-1, y-start_y))
    print(f"Y segments for x={col_x_1}: {segments_y1}")
    
    # Check Y transitions for col_x_2
    col2 = arr[:, col_x_2, :]
    in_card = False
    start_y = -1
    segments_y2 = []
    for y in range(0, 700):
        color = col2[y]
        dist = np.linalg.norm(color - ref)
        is_navy = dist < 60
        if is_navy and not in_card:
            in_card = True
            start_y = y
        elif not is_navy and in_card:
            in_card = False
            segments_y2.append((start_y, y-1, y-start_y))
    print(f"Y segments for x={col_x_2}: {segments_y2}")

if __name__ == '__main__':
    print_transitions(r"c:\forfront lab\salman website\services-website\public\assets\aster-main-banner.jpg", 200, 800, 1150)
    print_transitions(r"c:\forfront lab\salman website\services-website\public\assets\aster-main-banner.jpg", 500, 800, 1150)
