import sys
from win32com.client import Dispatch
from pathlib import Path

script_path = Path(__file__).resolve().parent  # full path to the script
icon_path = str(script_path / "Bauderr" / "images" / "icon.ico")
icon_path = icon_path.strip("'\"")
icon_path = icon_path + ',0'

del script_path

if len(sys.argv) < 2:
    print("Usage: python create_shortcut.py <path_to_exe> [arguments...]")
    sys.exit(1)

all_args = sys.argv[1:]

# Detect first argument ending with .exe as the target
target = None
target_index = 0
candidate_parts = []

for i, arg in enumerate(all_args):
    candidate_parts.append(arg.strip('"\''))
    candidate_clean = " ".join(candidate_parts)
    if candidate_clean.lower().endswith(".exe"):
        target = Path(candidate_clean)
        target_index = i
        break


if not target or not target.is_file():
    print(f"Error: Could not find valid .exe file: {target}")
    sys.exit(1)

# Everything after the exe
args_after = all_args[target_index + 1:]

# Handle db flags to create shortcut on Desktop and/or in mIRC.ini parent directory

desktop = ""
if len(args_after) > 1 and 'd' in args_after[0]:
	desktop = Path.home() / "Desktop"

# Handle -i flag with ini path
arguments_str = ""
if len(args_after) > 1 and args_after[1] == "-i":
    ini_path = " ".join(args_after[2:]).strip('"\'')  # rebuild path
    Path(ini_path).unlink(missing_ok=True)
    ini_path = str(Path(ini_path).resolve(strict=True))
    arguments_str = f"-i\"{ini_path}\""

bauderr = ""
if len(args_after) > 0 and 'b' in args_after[0]:
    bauderr = Path(ini_path).parent
    bauderr = str(bauderr).strip("\'\"")    

shortcut_name = "Bauderr.lnk"

shell = Dispatch("WScript.Shell")

def create():
    shortcut.Targetpath = str(target)
    shortcut.WorkingDirectory = str(target.parent)
    shortcut.Arguments = arguments_str
    shortcut.IconLocation = str(icon_path)
    shortcut.save()
    shortcut.IconLocation = str(icon_path)
    shortcut.save()

# Create shortcut on Desktop

if desktop:
    shortcut_path = Path.home() / "OneDrive" / "Desktop"
    if Path(shortcut_path).is_dir():
        shortcut_path = Path.home() / "OneDrive" / "Desktop" / shortcut_name
    else:
        shortcut_path = Path.home() / "Desktop" / shortcut_name
    shortcut = shell.CreateShortCut(str(shortcut_path))
    create()

# Create shortcut on mircini parent

if bauderr:
    shortcut_path = bauderr + "\\" + shortcut_name
    shortcut = shell.CreateShortCut(str(shortcut_path))
    create()
