import sys
from PIL import Image
import numpy as np

def find_cards(image_path):
    img = Image.open(image_path)
    img = img.convert('RGB')
    arr = np.array(img)
    
    # Navy blue is roughly (dark blue). Let's find pixels that are "dark blue"
    # Actually, we can just look for edges or do some basic thresholding
    # Navy blue: R < 50, G < 50, B > 30? Let's check some values.
    # It might be easier to just print color of a specific pixel to see what the card color is.
    
    # Existing guess:
    # Top-Left: x=697, y=113, w=287, h=228
    # Let's print the color at (697+100, 113+100)
    print(f"Color at left card: {arr[113+100, 697+100]}")
    # Print color at gap (between cards)
    print(f"Color at gap: {arr[113+100, 984+10]}")
    # Print color at right card guess
    print(f"Color at right card guess: {arr[113+100, 1019+100]}")
    
    # Let's just find the left and right boundaries for the two rows
    # Row 1: y = 200
    row1 = arr[200, :, :]
    # Row 2: y = 500
    row2 = arr[500, :, :]
    
    # We want to find contiguous segments of "card color".
    card_color_ref = arr[113+100, 697+100]
    
    def is_card(color):
        # Allow some variation
        return np.linalg.norm(color - card_color_ref) < 30
        
    def find_segments(row_y):
        row = arr[row_y, :, :]
        in_card = False
        start_x = 0
        segments = []
        for x in range(row.shape[0]):
            if is_card(row[x]):
                if not in_card:
                    in_card = True
                    start_x = x
            else:
                if in_card:
                    in_card = False
                    segments.append((start_x, x-1))
        if in_card:
            segments.append((start_x, row.shape[0]-1))
        return segments
        
    print("Row 200 segments (Top cards X bounds):", find_segments(200))
    print("Row 500 segments (Bottom cards X bounds):", find_segments(500))
    
    # Now to find Y bounds, let's take a column in the middle of each card
    def find_y_segments(col_x):
        col = arr[:, col_x, :]
        in_card = False
        start_y = 0
        segments = []
        for y in range(col.shape[0]):
            if is_card(col[y]):
                if not in_card:
                    in_card = True
                    start_y = y
            else:
                if in_card:
                    in_card = False
                    segments.append((start_y, y-1))
        if in_card:
            segments.append((start_y, col.shape[0]-1))
        return segments
        
    # We will pick x inside the cards based on row segments
    top_segs = find_segments(200)
    if len(top_segs) >= 2:
        left_mid_x = (top_segs[0][0] + top_segs[0][1]) // 2
        right_mid_x = (top_segs[1][0] + top_segs[1][1]) // 2
        
        print(f"Col {left_mid_x} segments (Left cards Y bounds):", find_y_segments(left_mid_x))
        print(f"Col {right_mid_x} segments (Right cards Y bounds):", find_y_segments(right_mid_x))
        
if __name__ == '__main__':
    find_cards(r"c:\forfront lab\salman website\services-website\public\assets\aster-main-banner.jpg")
