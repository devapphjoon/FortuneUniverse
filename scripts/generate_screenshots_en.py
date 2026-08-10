from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os

# Settings
output_dir = 'publishing_assets/store_screenshots_en'
os.makedirs(output_dir, exist_ok=True)
bg_color = (40, 44, 52)  # Dark zen color
text_color = (255, 255, 255)
font_path = 'C:/Windows/Fonts/arialbd.ttf'  # Arial Bold for English

images = {
    '1(ingame1).png': 'Beautiful Tile Matching Puzzle',
    '2(ingame2).png': 'Relaxing Themes & Backgrounds',
    '3(shop).png': 'Collect Premium Skins',
    '4(dailyQuest).png': 'New Daily Quests Every Day'
}

def add_corners(im, rad):
    circle = Image.new('L', (rad * 2, rad * 2), 0)
    draw = ImageDraw.Draw(circle)
    draw.ellipse((0, 0, rad * 2 - 1, rad * 2 - 1), fill=255)
    alpha = Image.new('L', im.size, 255)
    w, h = im.size
    alpha.paste(circle.crop((0, 0, rad, rad)), (0, 0))
    alpha.paste(circle.crop((rad, 0, rad * 2, rad)), (w - rad, 0))
    alpha.paste(circle.crop((0, rad, rad, rad * 2)), (0, h - rad))
    alpha.paste(circle.crop((rad, rad, rad * 2, rad * 2)), (w - rad, h - rad))
    im.putalpha(alpha)
    return im

def get_fit_font(text, max_width, initial_size=80):
    size = initial_size
    while True:
        try:
            font = ImageFont.truetype(font_path, size)
        except:
            return ImageFont.load_default()
        
        # Create a dummy image to measure text
        dummy_img = Image.new('RGB', (1, 1))
        dummy_draw = ImageDraw.Draw(dummy_img)
        bbox = dummy_draw.textbbox((0, 0), text, font=font)
        text_w = bbox[2] - bbox[0]
        
        if text_w <= max_width or size <= 20:
            return font, text_w
        size -= 2

for i, (filename, text) in enumerate(images.items()):
    idx = i + 1
    input_path = os.path.join('publishing_assets', filename)
    if not os.path.exists(input_path):
        print(f'Skipping {input_path}')
        continue
    
    # Base canvas
    canvas = Image.new('RGB', (1080, 1920), bg_color)
    draw = ImageDraw.Draw(canvas)
    
    # Draw text (centered), dynamic font size to prevent cutoff
    font, text_w = get_fit_font(text, max_width=980, initial_size=80)
    draw.text(((1080 - text_w) // 2, 150), text, fill=text_color, font=font)
    
    # Load and resize screenshot
    scr = Image.open(input_path).convert('RGBA')
    
    # Target size for screenshot inside the frame (900x1600 maintains 9:16)
    scr_w, scr_h = 900, 1600
    scr = scr.resize((scr_w, scr_h), Image.Resampling.LANCZOS)
    
    # Add rounded corners
    scr = add_corners(scr, 60)
    
    # Add fake shadow
    shadow = Image.new('RGBA', (scr_w + 40, scr_h + 40), (0,0,0,0))
    s_draw = ImageDraw.Draw(shadow)
    s_draw.rounded_rectangle((0, 0, scr_w + 30, scr_h + 30), radius=70, fill=(0,0,0,100))
    shadow = shadow.filter(ImageFilter.GaussianBlur(15))
    
    # Paste shadow and screenshot
    y_offset = 270
    x_offset = (1080 - scr_w) // 2
    canvas.paste(shadow, (x_offset - 15, y_offset - 15), shadow)
    canvas.paste(scr, (x_offset, y_offset), scr)
    
    # Save
    out_path = os.path.join(output_dir, f'phone_scr_{idx}.png')
    canvas.save(out_path)
    print(f'Saved {out_path}')
