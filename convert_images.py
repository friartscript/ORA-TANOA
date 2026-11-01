import os
from PIL import Image

images_dir = os.path.join(os.path.dirname(__file__), "Images")

# 001.png -> 001.jpg, 002.png -> 002.jpg, etc.
for name in ["001", "002", "003", "004"]:
    png_path = os.path.join(images_dir, f"{name}.png")
    jpg_path = os.path.join(images_dir, f"{name}.jpg")
    if os.path.exists(png_path):
        img = Image.open(png_path).convert("RGB")
        img.save(jpg_path, "JPEG", quality=95)
        print(f"Converted {name}.png -> {name}.jpg")

# racs_badge
badge_name = "racs_badge_backup_user-raliser-le-meme-drapeau-a-lidentique-mais-version.jpg"
badge_path = os.path.join(images_dir, badge_name)
if os.path.exists(badge_path):
    img = Image.open(badge_path).convert("RGB")
    img.save(badge_path, "JPEG", quality=95)
    img.save(os.path.join(images_dir, "racs_badge.jpg"), "JPEG", quality=95)
    print(f"Verified/saved {badge_name} and racs_badge.jpg")
