import os
import sys
import shutil
import re
import time
import argparse
import base64
import json
from datetime import datetime
from dotenv import load_dotenv
from openai import OpenAI
import PIL.Image

# Configuration
GENERATED_ROOT = "generated"

def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

def generate_completion(client, messages, response_format=None):
    try:
        kwargs = {
            "model": "gpt-4o",
            "messages": messages,
            "max_tokens": 4096,
        }
        if response_format:
            kwargs["response_format"] = response_format
            
        response = client.chat.completions.create(**kwargs)
        return response.choices[0].message.content
    except Exception as e:
        print(f"Error generating content: {e}")
        return None

def determine_project_path():
    os.makedirs(GENERATED_ROOT, exist_ok=True)
    existing_dirs = [d for d in os.listdir(GENERATED_ROOT) if os.path.isdir(os.path.join(GENERATED_ROOT, d))]
    output_dirs = [d for d in existing_dirs if d.startswith("output") and d[6:].isdigit()]
    
    next_num = 1
    if output_dirs:
        nums = [int(d[6:]) for d in output_dirs]
        next_num = max(nums) + 1
    
    project_name = f"output{next_num}"
    return os.path.join(GENERATED_ROOT, project_name)

def plan_site_structure(client, user_input, images_to_process):
    print("\n--- Phase 1: Planning Site Structure & Copy ---")
    
    system_instruction = (
        "You are a Creative Director and UX Designer. "
        "Your goal is to plan a multi-page static website based on the user's request and visual assets. "
        "1. ANALYZE COMPLEXITY: Determine the appropriate scale based on user input. "
        "   - If the request is simple or vauge, default to a compact 1-3 page structure (e.g., Home + Contact) to ensure fast generation. "
        "   - Only create a complex 4-5 page structure if explicitly requested or clearly necessary. "
        "2. IMAGE USAGE (CRITICAL): You have a set of assets. You MUST plan enough content to display ALL of them. "
        "   - If you have 12 images of food, create a Menu page with 12 items, or a Gallery page. "
        "   - Do NOT pick just 3 images and ignore the rest. The user wants to see ALL assets used. "
        "3. Define a Sitemap. STRICTLY FOLLOW the user's request for page count and titles if specified. "
        "4. Write content that is effective but concise (avoid unnecessary fluff to save generation time). "
        "5. Output strictly valid JSON."
    )
    
    messages = [{"role": "system", "content": system_instruction}]
    
    user_content_parts = []
    
    # Create a list of available filenames to force usage
    available_files = [f"assets/{os.path.basename(p)}" for p in images_to_process]
    available_files_str = "\n".join([f"- {f}" for f in available_files])
    
    user_content_parts.append({"type": "text", "text": (
        f"User Request: {user_input}\n\n"
        "AVAILABLE ASSETS (TOTAL: {len(images_to_process)} files):\n"
        f"{available_files_str}\n\n"
        "INSTRUCTION: Assign specific 'assets/filename.ext' from the list above to the 'content_brief' of relevant pages. "
        "You MUST ensure EVERY file in the list above is assigned to at least one page. "
        "If there are too many images for the requested pages, add a Gallery section or extend the Menu page significantly. "
        "Do NOT ignore any images."
    )})
    
    if images_to_process:
        user_content_parts.append({"type": "text", "text": "Visual Context (Base the style and tone on these):"})
        for img_p in images_to_process:
            try:
                base64_image = encode_image(img_p)
                # Interleave filename to help AI map 'assets/foo.png' to the visual
                fname = os.path.basename(img_p)
                user_content_parts.append({
                    "type": "text", 
                    "text": f"Image Filename: assets/{fname}"
                })
                user_content_parts.append({
                    "type": "image_url",
                    "image_url": {"url": f"data:image/jpeg;base64,{base64_image}"}
                })
            except:
                pass
    
    user_content_parts.append({
        "type": "text", 
        "text": (
            "Output JSON format:\n"
            "{\n"
            "  \"global_style_guide\": \"Brief description of colors, fonts, and vibe.\",\n"
            "  \"site_name\": \"The Name of the Website (consistent across all pages)\",\n"
            "  \"pages\": [\n"
            "    {\n"
            "      \"filename\": \"index.html\",\n"
            "      \"title\": \"Page Title\",\n"
            "      \"navigation_label\": \"Home\",\n"
            "      \"content_brief\": \"Detailed content outline including headlines, paragraphs using marketing copy, and instructions on image placement.\"\n"
            "    }\n"
            "  ]\n"
            "}"
        )
    })
    
    messages.append({"role": "user", "content": user_content_parts})
    
    json_response = generate_completion(client, messages, response_format={"type": "json_object"})
    
    if json_response:
        try:
            plan = json.loads(json_response)
            print(f"Plan created: {len(plan.get('pages', []))} pages.")
            return plan
        except json.JSONDecodeError:
            print("Error decoding JSON plan.")
            return None
    return None

def generate_page_html(client, page, sitemap_links, global_style, images_to_process, site_name):
    filename = page['filename']
    print(f"\n--- Phase 2: Generating {filename} ---")
    
    system_instruction = (
        "You are a skilled web developer using TailwindCSS. "
        "Create a single HTML file independent of others (but linking to them). "
        "Do NOT use external CSS/JS files. Embed everything. "
        f"Global Style Guide: {global_style}"
    )
    
    messages = [{"role": "system", "content": system_instruction}]
    
    user_content_parts = []
    
    # Navigation Context
    nav_html_hint = "Make sure to include a responsive navigation bar with these links: " + ", ".join([f"<a href='{p['filename']}'>{p['label']}</a>" for p in sitemap_links])
    
    # Content Context
    content_instruction = (
        f"Generate code for: {filename}\n"
        f"Page Title: {page['title']}\n"
        f"Content Requirements: {page['content_brief']}\n"
        f"Navigation Requirements: {nav_html_hint}\n"
        "UI_UX CRITICAL RULES:\n"
        "1. NO DEAD BUTTONS. All buttons/CTAs must be <a> tags linking to one of the sitemap pages or an anchor ID (e.g., #contact). Do not create buttons that do nothing.\n"
        "2. CONSISTENT LAYOUT. Use a standard <header>, <main class='container mx-auto px-4'>, and <footer> structure to prevent layout shifts between pages.\n"
        "3. RESPONSIVE DESIGN. Use Tailwind's mobile-first approach (e.g. 'grid-cols-1 md:grid-cols-3'). Ensure the navbar is responsive (hamburger menu or stackable).\n"
        f"4. HEADER CONSISTENCY: You MUST use the exact Site Name: '{site_name}' in the header/logo area. Do NOT vary it.\n"
        "5. BREADCRUMBS: If this is NOT the home page, you MUST display a breadcrumb trail (e.g., 'Home > Page Title') in a container directly below the navbar/header. "
        "   Use a consistent style/location for breadcrumbs across all subpages.\n"
        "6. NO IMAGE LINKS. Do NOT wrap <img> tags in <a> tags. Images should be static displays only. Do NOT link images to detailed pages unless those pages exist in the sitemap.\n"
        "7. DO NOT invent paths like 'assets/hero.jpg' or 'images/logo.png' if they are not in the list above. They will be broken.\n"
        "Ensure the copy is exactly as requested (or better). Make it look premium."
    )
    user_content_parts.append({"type": "text", "text": content_instruction})
    
    # Image Context (pass refs)
    if images_to_process:
        available_images = [f"assets/{os.path.basename(p)}" for p in images_to_process]
        img_list_str = ", ".join(available_images)
        user_content_parts.append({
            "type": "text",
            "text": (
                f"IMPORTANT - VISUAL ASSETS POLICY:\n"
                f"1. You have access ONLY to these local files: {img_list_str}.\n"
                "2. You MUST use these exact paths (e.g. 'assets/foo.jpg') for your main images.\n"
                "3. If you need MORE images than provided (e.g. for a gallery or background) and you cannot reuse the provided ones, "
                "you MUST use external placeholders (e.g. 'https://placehold.co/600x400').\n"
                "4. DO NOT invent paths like 'assets/hero.jpg' or 'images/logo.png' if they are not in the list above. They will be broken."
            )
        })
        
        # Also pass vision context again so it knows what the assets look like to place them well
        user_content_parts.append({"type": "text", "text": "Reference Visuals (Use these to match the coded design):"})
        for img_p in images_to_process:
            try:
                base64_image = encode_image(img_p)
                # Interleave filename!
                fname = os.path.basename(img_p)
                user_content_parts.append({
                    "type": "text", 
                    "text": f"Image Filename: assets/{fname}"
                })
                user_content_parts.append({
                    "type": "image_url",
                    "image_url": {"url": f"data:image/jpeg;base64,{base64_image}"}
                })
            except:
                pass
        
        # Add instruction to try and use available images
        user_content_parts.append({
            "type": "text",
            "text": (
                "Try to use the provided 'assets/...' images as much as possible to make the site rich. "
                "If the content brief mentions a specific asset file, YOU MUST USE IT in the HTML."
            )
        })
    else:
        # No images provided case
        user_content_parts.append({
            "type": "text", 
            "text": (
                "IMPORTANT - NO LOCAL IMAGES AVAILABLE:\n"
                "1. You do not have access to any local image files.\n"
                "2. You MUST use external placeholders for ALL visuals (e.g. 'https://placehold.co/600x400' or Unsplash Source if stable).\n"
                "3. Do NOT use 'assets/...' paths as they do not exist.\n"
                "4. Focus on typography, layout, and colors to make the site attractive without custom photography."
            )
        })

    user_content_parts.append({"type": "text", "text": "Output ONLY the HTML code block."})
    
    messages.append({"role": "user", "content": user_content_parts})
    
    content_response = generate_completion(client, messages)
    
    if content_response:
        match = re.search(r'```html\s*(.*?)\s*```', content_response, re.DOTALL)
        if match:
            return match.group(1)
        elif "<html" in content_response:
             return content_response
    return None

def main():
    parser = argparse.ArgumentParser(description="AI Static Site Generator (Multi-Page)")
    parser.add_argument("--image", help="Path to a local image file OR directory", default=None)
    args = parser.parse_args()

    load_dotenv()
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        print("Error: OPENAI_API_KEY not found.")
        return

    client = OpenAI(api_key=api_key)
    
    # Input Loop
    print("AI Static Site Generator (Multi-Page Edition)")
    print("どんなサイトを作りますか？ (入力終了は空行でEnter)")
    print("> ", end="", flush=True)
    
    lines = []
    while True:
        try:
            line = input()
            if not line:
                break
            lines.append(line)
        except EOFError:
            break
            
    user_input = "\n".join(lines)
    if not user_input.strip():
        print("入力がありませんでした。")
        return

    # Image Processing
    image_path = args.image
    if not image_path:
        print("画像のパス (任意):")
        inp = input("> ").strip()
        if inp: image_path = inp.replace("'", "").replace('"', "").strip()

    images_to_process = []
    if image_path and os.path.exists(image_path):
        if os.path.isdir(image_path):
            valid_exts = ('.png', '.jpg', '.jpeg', '.webp')
            for f in sorted(os.listdir(image_path)):
                if f.lower().endswith(valid_exts):
                    images_to_process.append(os.path.join(image_path, f))
        else:
            images_to_process.append(image_path)
    
    print(f"Found {len(images_to_process)} images.")

    start_time = time.time()
    
    # 1. Plan
    site_plan = plan_site_structure(client, user_input, images_to_process)
    if not site_plan:
        print("Planning failed.")
        return

    project_dir = determine_project_path()
    os.makedirs(project_dir, exist_ok=True)
    print(f"Target: {project_dir}")
    
    # Copy Assets
    if images_to_process:
        assets_dir = os.path.join(project_dir, "assets")
        os.makedirs(assets_dir, exist_ok=True)
        for img in images_to_process:
            try:
                shutil.copy(img, os.path.join(assets_dir, os.path.basename(img)))
            except: pass

    # Prepare Link Info
    sitemap_links = []
    for p in site_plan.get('pages', []):
        sitemap_links.append({'filename': p['filename'], 'label': p.get('navigation_label', p.get('title'))})

    # 2. Generate Pages
    for page in site_plan.get('pages', []):
        html = generate_page_html(client, page, sitemap_links, site_plan.get('global_style_guide', ''), images_to_process, site_plan.get('site_name', 'My Website'))
        if html:
            out_path = os.path.join(project_dir, page['filename'])
            with open(out_path, "w", encoding="utf-8") as f:
                f.write(html)
            print(f"Saved: {out_path}")
        else:
            print(f"Failed to generate {page['filename']}")

    elapsed = time.time() - start_time
    print(f"Done in {elapsed:.1f}s")

if __name__ == "__main__":
    main()
