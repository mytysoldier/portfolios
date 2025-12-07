import os
import sys
import subprocess
import shutil
import re
import time
import argparse
from datetime import datetime
from dotenv import load_dotenv
import google.generativeai as genai

# Configuration
GENERATED_ROOT = "generated"
OUTPUT_DIR_NAME = "nanobanana-output"

def setup_gemini():
    load_dotenv()
    api_key = os.getenv("GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")
    if not api_key:
        print("Error: GEMINI_API_KEY (or GOOGLE_API_KEY) not found in .env file.")
        print("Please set your API key in .env.")
        return None
    
    genai.configure(api_key=api_key)
    return genai.GenerativeModel('gemini-2.5-flash') # Fixed model name

def generate_text(model, prompt):
    try:
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        print(f"Error generating text: {e}")
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

def generate_images(prompt, project_dir, count=3):
    """
    Generate images using the gemini CLI (nanobanana).
    """
    print(f"\n[Image Generation] Prompt: {prompt}")
    print(f"Generating {count} variations... (Estimated time: 15-30 seconds)")
    
    try:
        # Construct command
        # Using pipe to feed instruction to gemini CLI
        # The CLI asks for confirmation with a multiple choice menu:
        # 1. Yes, allow once
        # 2. Yes, always allow tool...
        # 3. Yes, always allow all tools from server...
        # 4. No...
        input_text = f'/generate "{prompt}" --count={count}\n'
        
        process = subprocess.Popen(
            ['gemini'], 
            stdin=subprocess.PIPE, 
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE,
            text=True
        )
        
        # Adding a timeout mechanism
        try:
            # We trust EOF (closing stdin) will finish the session or command
            print("DEBUG: Sending command and waiting (timeout=120s)...")
            stdout, stderr = process.communicate(input=input_text, timeout=120)
        except subprocess.TimeoutExpired:
            process.kill()
            print("Error: Image generation timed out.")
            return []

        # Check for output
        if not os.path.exists(OUTPUT_DIR_NAME):
            # Fallback check current directory just in case
            pass
            
        # Find new images
        # We need a way to identify *newly* created images or just move all from output
        src_dir = OUTPUT_DIR_NAME if os.path.exists(OUTPUT_DIR_NAME) else "."
        
        # Nanobanana usually saves with timestamp or name
        # We'll just look for recent png/jpg files in the output dir
        
        if not os.path.exists(src_dir):
             print(f"Error: Output directory '{src_dir}' not found.")
             print("StdOut:", stdout)
             print("StdErr:", stderr)
             return []

        project_images_dir = os.path.join(project_dir, "images")
        os.makedirs(project_images_dir, exist_ok=True)
        
        moved_images = []
        # Filter files created in the last 60 seconds
        now = time.time()
        for f in os.listdir(src_dir):
            if f.endswith(('.png', '.jpg', '.jpeg')):
                full_path = os.path.join(src_dir, f)
                if os.path.getmtime(full_path) > now - 60:
                    dest_path = os.path.join(project_images_dir, f)
                    shutil.move(full_path, dest_path)
                    moved_images.append(f"images/{f}")
        
        if not moved_images:
            print("Warning: No new images found in output directory.")
            # Be helpful debugging
            print(f"Checked directory: {os.path.abspath(src_dir)}")
            print("--- CLI DEBUG INFO ---")
            print("StdOut:", stdout)
            print("StdErr:", stderr)
            print("----------------------")
        else:
            print(f"Successfully generated {len(moved_images)} images.")
            
        return moved_images

    except Exception as e:
        print(f"Error in image generation: {e}")
        return []

def main():
    parser = argparse.ArgumentParser(description="AI Static Site Generator")
    parser.add_argument("--step", choices=['all', 'plan', 'image', 'html'], default='all', help="Execute specific step")
    args = parser.parse_args()

    model = setup_gemini()
    if not model:
        return

    print("--- AI Static Site Generator (Gemini Powered) ---")
    
    user_input = ""
    # Only ask for input if we're starting fresh or doing a plan
    print("AIに依頼したい内容を入力してください (終了するには 'exit' or 'quit'):")
    while True:
        try:
            user_input = input("\n> ")
            if user_input.lower() in ['exit', 'quit']:
                return
            if user_input.strip():
                break
        except KeyboardInterrupt:
            return

    start_time = time.time()
    print("\n--- Process Started ---")
    print("Estimated total time: 45-60 seconds")
    
    # 1. Plan & Setup
    if args.step in ['all', 'plan']:
        print("\n[Step 1/3] Planning & Setup...")
        project_dir = determine_project_path()
        os.makedirs(project_dir, exist_ok=True)
        print(f"Target Directory: {project_dir}")
        
        planning_prompt = (
                f"Analyze this request: '{user_input}'. "
                "Describe the main image that should be on the page (if fitting). "
                "Output format:\n"
                "ImagePrompt: <prompt or NONE>"
            )
        plan_text = generate_text(model, planning_prompt)
        image_prompt = None
        if plan_text:
            for line in plan_text.split('\n'):
                if line.startswith("ImagePrompt:"):
                    prompt_val = line.split(":", 1)[1].strip()
                    if prompt_val and prompt_val != "NONE":
                        image_prompt = prompt_val
        
        # Save state for other steps if needed (simple file based state for now, or just re-run)
        # For this simple script, we pass variables in memory if running 'all', 
        # but if running individual steps validation is harder without persistence. 
        # Assuming 'all' flow for variable passing.
    
    # Validation for partial steps without context is tricky, so assume 'all' flow logic for variables
    # If user runs --step image, we need prompt. 
    # For now, let's keep it simple: --step is mostly for skipping/debugging by modifying code constants if needed,
    # or we just re-derive prompt every time.
    
    # Re-derive project dir for consistence
    # NOTE: This creates a new dir every run if we just call determine_project_path(). 
    # For debugging, we might want to use the LATEST dir.
    # Let's stick to the 'all' flow primarily being the supported user path.
    
    # Logic to ensure variables are set if jumping into middle steps
    # Note: In a real app we'd load state. Here we just re-run minimal planning if needed.
    if args.step == 'image':
        print("(Re-running minimal planning for context...)")
        project_dir = determine_project_path() # Warning: this might create new output dir increment
        # Actually for debugging we probably want the last one or just create new. 
        # Let's simplify: always creating new output N is safer than overwriting unknown.
        os.makedirs(project_dir, exist_ok=True)
        
        # Get prompt
        planning_prompt = (
            f"Analyze this request: '{user_input}'. "
            "Output format:\n"
            "ImagePrompt: <prompt or NONE>"
        )
        plan_text = generate_text(model, planning_prompt)
        image_prompt = None
        if plan_text:
            for line in plan_text.split('\n'):
                if line.startswith("ImagePrompt:"):
                    prompt_val = line.split(":", 1)[1].strip()
                    if prompt_val and prompt_val != "NONE":
                        image_prompt = prompt_val
    
    # 2. Images
    image_paths = []
    # If step is 'all' or 'image', AND we have a prompt
    if (args.step == 'all' or args.step == 'image') and image_prompt:
        print(f"\n[Step 2/3] Generating Content (Images)...")
        image_paths = generate_images(image_prompt, project_dir, count=3)
    
    # 3. HTML
    if args.step in ['all', 'html']:
        print(f"\n[Step 3/3] Generating Code (HTML)...")
        system_prompt = (
                "You are a skilled web developer using TailwindCSS."
                "Create a single file HTML/CSS/JS solution."
                "Do NOT use external CSS files, put styles in <style>."
                "Do NOT use external JS files, put scripts in <script>."
                f"The user wants: {user_input}. "
            )
        
        if image_paths:
            img_list_str = ", ".join(image_paths)
            system_prompt += (
                f" INSTRUCTION: The following images are available: {img_list_str}. "
                "Use them effectively in the design (e.g. carousel, grid, or hero background). "
                "Use the first image as the main hero background."
            )

        system_prompt += " Output ONLY the HTML code block."
        
        html_response = generate_text(model, system_prompt)
        
        match = re.search(r'```html\s*(.*?)\s*```', html_response, re.DOTALL)
        if match:
            html_content = match.group(1)
            output_file = os.path.join(project_dir, "index.html")
            with open(output_file, "w", encoding="utf-8") as f:
                f.write(html_content)
            print(f"\nSuccessfully generated site at: {output_file}")
        else:
            print("Failed to extract HTML.")

    elapsed = time.time() - start_time
    print(f"\n--- Completed in {elapsed:.1f} seconds ---")

if __name__ == "__main__":
    main()
