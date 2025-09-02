#!/usr/bin/env python3
import os
from PIL import Image, ImageChops

BORDER = 3

def trim_with_border(im, border=BORDER):
    # Ensure image has alpha channel
    if im.mode != "RGBA":
        im = im.convert("RGBA")

    # Get bounding box of non-transparent pixels
    bg = Image.new("RGBA", im.size, (0, 0, 0, 0))
    diff = ImageChops.difference(im, bg)
    bbox = diff.getbbox()

    if bbox:
        # Crop to bounding box
        cropped = im.crop(bbox)

        # Add border
        new_w = cropped.width + border * 2
        new_h = cropped.height + border * 2
        new_im = Image.new("RGBA", (new_w, new_h), (0, 0, 0, 0))
        new_im.paste(cropped, (border, border))
        return new_im
    else:
        # Fully transparent image, return as-is
        return im

def process_directory(path="."):
    for fname in os.listdir(path):
        if fname.lower().endswith(".png"):
            in_path = os.path.join(path, fname)
            out_path = os.path.join(path, fname)  # overwrite original
            try:
                im = Image.open(in_path)
                trimmed = trim_with_border(im)
                trimmed.save(out_path)
                print(f"Processed {fname}")
            except Exception as e:
                print(f"Error processing {fname}: {e}")

if __name__ == "__main__":
    process_directory(".")

