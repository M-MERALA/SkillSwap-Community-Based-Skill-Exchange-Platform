import os
import re

def strip_responsive_units(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".dart"):
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()

                # Remove .m(context), .w(context), .h(context)
                new_content = re.sub(r'\.m\(context\)', '', content)
                new_content = re.sub(r'\.w\(context\)', '', new_content)
                new_content = re.sub(r'\.h\(context\)', '', new_content)
                
                # Remove import '../utils/responsive.dart'; or similar
                new_content = re.sub(r"import '.*responsive\.dart';\n", "", new_content)

                if new_content != content:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    print(f"Processed {filepath}")

if __name__ == "__main__":
    import sys
    target_dir = sys.argv[1] if len(sys.argv) > 1 else "c:\\skill_swap\\lib"
    strip_responsive_units(target_dir)
