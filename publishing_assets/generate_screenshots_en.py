import os
import requests
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def create_gradient(width, height, color1, color2):
    base = Image.new('RGB', (width, height), color1)
    top = Image.new('RGB', (width, height), color2)
    mask = Image.new('L', (width, height))
    mask_data = []
    for y in range(height):
        for x in range(width):
            mask_data.append(int(255 * (y / height)))
    mask.putdata(mask_data)
    base.paste(top, (0, 0), mask)
    return base

def draw_text_with_shadow(draw, text, font, y, text_color, shadow_color, canvas_width):
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    x = (canvas_width - text_width) / 2
    
    # Draw drop shadow for text
    shadow_offset = 5
    draw.text((x + shadow_offset, y + shadow_offset), text, font=font, fill=shadow_color)
    draw.text((x, y), text, font=font, fill=text_color)

def add_drop_shadow(image, offset=(0, 20), shadow_color=(0, 0, 0, 150), blur_radius=30):
    shadow = Image.new('RGBA', image.size, shadow_color)
    padded_size = (image.size[0] + blur_radius*4, image.size[1] + blur_radius*4)
    shadow_canvas = Image.new('RGBA', padded_size, (0,0,0,0))
    shadow_canvas.paste(shadow, (blur_radius*2, blur_radius*2))
    shadow_canvas = shadow_canvas.filter(ImageFilter.GaussianBlur(blur_radius))
    
    result = Image.new('RGBA', padded_size, (0,0,0,0))
    result.paste(shadow_canvas, (offset[0], offset[1]))
    result.paste(image, (blur_radius*2, blur_radius*2))
    return result

def round_corners(im, rad):
    circle = Image.new('L', (rad * 2, rad * 2), 0)
    draw = ImageDraw.Draw(circle)
    draw.ellipse((0, 0, rad * 2 - 1, rad * 2 - 1), fill=255)
    alpha = Image.new('L', im.size, 255)
    w, h = im.size
    alpha.paste(circle.crop((0, 0, rad, rad)), (0, 0))
    alpha.paste(circle.crop((0, rad, rad, rad * 2)), (0, h - rad))
    alpha.paste(circle.crop((rad, 0, rad * 2, rad)), (w - rad, 0))
    alpha.paste(circle.crop((rad, rad, rad * 2, rad * 2)), (w - rad, h - rad))
    im.putalpha(alpha)
    return im

def main():
    base_dir = r"D:\AppDev\FortuneUniverse\publishing_assets\screen"
    out_dir = r"D:\AppDev\FortuneUniverse\publishing_assets\store_mockups"
    os.makedirs(out_dir, exist_ok=True)
    
    font_bold_path = r"C:\Windows\Fonts\malgunbd.ttf"
    
    font_title = ImageFont.truetype(font_bold_path, 72)
    font_sub = ImageFont.truetype(font_bold_path, 48)
    
    screens = [
        {
            "file": "Main.png",
            "title": "Mystical Stories Every Day",
            "sub": "Fortunes, Tarot, and Spirit Tests",
            "color1": (25, 10, 45),
            "color2": (10, 5, 20)
        },
        {
            "file": "TodayFortune.png",
            "title": "Today's Fortune Cookie",
            "sub": "Crack open your daily luck",
            "color1": (45, 20, 60),
            "color2": (15, 10, 30)
        },
        {
            "file": "Tarot.png",
            "title": "Mystical Tarot Readings",
            "sub": "Guidance for your future",
            "color1": (15, 25, 55),
            "color2": (5, 10, 25)
        },
        {
            "file": "AnimalSpiritTest.png",
            "title": "Animal Spirit Test",
            "sub": "Find your inner guardian",
            "color1": (35, 15, 45),
            "color2": (15, 5, 20)
        }
    ]
    
    canvas_w, canvas_h = 1080, 1920
    
    for i, item in enumerate(screens):
        print(f"Processing {item['file']} (English)...")
        bg = create_gradient(canvas_w, canvas_h, item['color1'], item['color2']).convert('RGBA')
        
        screenshot_path = os.path.join(base_dir, item['file'])
        if not os.path.exists(screenshot_path):
            print(f"File not found: {screenshot_path}")
            continue
            
        ss = Image.open(screenshot_path).convert("RGBA")
        
        target_w = 820
        ratio = target_w / ss.width
        target_h = int(ss.height * ratio)
        ss = ss.resize((target_w, target_h), Image.Resampling.LANCZOS)
        
        ss = round_corners(ss, 60)
        
        ss_shadowed = add_drop_shadow(ss, offset=(0, 40), blur_radius=50, shadow_color=(0, 0, 0, 200))
        
        paste_x = (canvas_w - ss_shadowed.width) // 2
        paste_y = 500  
        
        bg.paste(ss_shadowed, (paste_x, paste_y), ss_shadowed)
        
        draw = ImageDraw.Draw(bg, 'RGBA')
        draw_text_with_shadow(draw, item['title'], font_title, 160, (255, 255, 255), (0, 0, 0, 180), canvas_w)
        draw_text_with_shadow(draw, item['sub'], font_sub, 300, (220, 220, 240), (0, 0, 0, 180), canvas_w)
        
        out_path = os.path.join(out_dir, f"{i+1}_store_{item['file'].replace('.png', '_en.png')}")
        bg.save(out_path, quality=100)
        print(f"Saved {out_path}")
        
if __name__ == '__main__':
    main()
