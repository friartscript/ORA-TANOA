import os
from PIL import Image

workspace_dir = r"c:\Users\kevin\Documents\Arma 3\missions\ORA.Tanoa"
src_path = os.path.join(workspace_dir, "Images", "003.png")
if not os.path.exists(src_path):
    src_path = os.path.join(workspace_dir, "Images", "003.jpg")

img = Image.open(src_path)
width, height = img.size
print(f"Source image loaded: {src_path} ({width}x{height})")

# 1. 2:1 ratio for loadScreen.jpg and overviewPicture.jpg
target_ratio_2_1 = 2.0 / 1.0
current_ratio = width / height

if current_ratio > target_ratio_2_1:
    new_w = int(height * target_ratio_2_1)
    new_h = height
    # crop horizontally (focus on right side where the soldiers are, or center-right)
    # The soldiers in 003 are on the right/center
    offset_x = int((width - new_w) * 0.65) # slightly towards the right where soldiers are
    crop_2_1 = img.crop((offset_x, 0, offset_x + new_w, new_h))
else:
    new_w = width
    new_h = int(width / target_ratio_2_1)
    offset_y = int((height - new_h) * 0.5)
    crop_2_1 = img.crop((0, offset_y, new_w, offset_y + new_h))

loadscreen_img = crop_2_1.resize((1024, 512), Image.Resampling.LANCZOS)
loadscreen_path = os.path.join(workspace_dir, "loadScreen.jpg")
loadscreen_img.save(loadscreen_path, "JPEG", quality=95)
print(f"Saved {loadscreen_path} (1024x512)")

overview_path = os.path.join(workspace_dir, "overviewPicture.jpg")
loadscreen_img.save(overview_path, "JPEG", quality=95)
print(f"Saved {overview_path} (1024x512)")

# 2. 1:1 ratio for preview.jpg (Steam Workshop)
# Focus squarely on the soldiers inside the helicopter door with weapon and RACS patch
# width is wider than height (1920x1080)
square_size = height # 1080
# The soldiers are located between x = 400 and x = 1600
# Center around x = 1000
offset_square_x = min(width - square_size, max(0, int((width - square_size) * 0.70)))
crop_square = img.crop((offset_square_x, 0, offset_square_x + square_size, square_size))

preview_img = crop_square.resize((512, 512), Image.Resampling.LANCZOS)
preview_path = os.path.join(workspace_dir, "preview.jpg")
preview_img.save(preview_path, "JPEG", quality=95)
print(f"Saved {preview_path} (512x512)")

# Also ensure 001.jpg, 002.jpg, 003.jpg, 004.jpg exist
images_dir = os.path.join(workspace_dir, "Images")
for n in ["001", "002", "003", "004"]:
    p_png = os.path.join(images_dir, f"{n}.png")
    p_jpg = os.path.join(images_dir, f"{n}.jpg")
    if os.path.exists(p_png) and not os.path.exists(p_jpg):
        Image.open(p_png).convert("RGB").save(p_jpg, "JPEG", quality=95)
        print(f"Converted {n}.png to {n}.jpg")

print("All operations completed successfully!")
