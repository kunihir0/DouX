#!/usr/bin/env python3

import argparse
import subprocess
import os
import shutil
import urllib.request
from pathlib import Path
import platform
import glob

# --- Configuration ---
# Directory to store downloaded tools and temporary files.
WORK_DIR = Path.home() / ".ipa_packager_tools"
# Directory where the final IPAs will be saved.
OUTPUT_DIR = Path.cwd() / "output"
# Patch file to compile JGProgressHUD
PATCH_FILE = Path.cwd() / "scripts/compile_jgprogresshud.patch"

# --- Architecture-Specific Tool Configuration ---
CPU_ARCH = platform.machine()
if CPU_ARCH == 'arm64':
    IPAPATCH_ARCH_SUFFIX = "macos-arm64"
    IVINJECT_ARCH_SUFFIX = "arm64"
elif CPU_ARCH == 'x86_64':
    IPAPATCH_ARCH_SUFFIX = "macos-amd64"  # Corrected from macos-x86_64
    IVINJECT_ARCH_SUFFIX = "x64"
else:
    raise OSError(f"Unsupported CPU architecture: {CPU_ARCH}. This script supports 'arm64' and 'x86_64'.")

# Tool configurations
INSERT_DYLIB_REPO = "https://github.com/Tyilo/insert_dylib.git"
IVINJECT_REPO = "https://github.com/whoeevee/ivinject.git"
IVINJECT_BIN_URL = f"https://github.com/whoeevee/ivinject/releases/download/first/ivinject-{IVINJECT_ARCH_SUFFIX}"
IPAPATCH_BIN_URL = f"https://github.com/asdfzxcvbn/ipapatch/releases/download/v2.1.3/ipapatch.{IPAPATCH_ARCH_SUFFIX}"


def run_command(command, cwd=None, env=None):
    """Executes a shell command and raises an exception on error."""
    print(f"▶️  Running command: {' '.join(command)}")
    try:
        process = subprocess.run(
            command,
            check=True,
            cwd=cwd,
            env=env,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        return process.stdout
    except subprocess.CalledProcessError as e:
        print(f"❌ Error executing command: {' '.join(command)}")
        print(f"   Output:\n{e.stdout}")
        print(f"   Error:\n{e.stderr}")
        raise


def download_file(url, dest):
    """Downloads a file from a URL to a destination."""
    print(f"⬇️  Downloading {url} to {dest}...")
    try:
        with urllib.request.urlopen(url) as response, open(dest, 'wb') as out_file:
            shutil.copyfileobj(response, out_file)
        print(f"✅ Download complete.")
    except Exception as e:
        print(f"❌ Failed to download {url}: {e}")
        raise


def validate_file_type(file_path, expected_types, error_message):
    """Validates the MIME type of a file."""
    print(f"🔎 Validating {file_path}...")
    try:
        result = subprocess.run(
            ["file", "--mime-type", "-b", str(file_path)],
            check=True,
            capture_output=True,
            text=True
        )
        mime_type = result.stdout.strip()
        if mime_type not in expected_types:
            print(f"❌ {error_message} Detected type: {mime_type}.")
            raise ValueError(error_message)
        print(f"✅ Validation successful. Type: {mime_type}")
    except subprocess.CalledProcessError as e:
        print(f"❌ Could not determine file type for {file_path}: {e.stderr}")
        raise


def check_binary_architecture(file_path, expected_arch):
    """Checks if a binary file matches the expected CPU architecture."""
    if not file_path.exists():
        return False
    try:
        result = subprocess.run(["file", str(file_path)], check=True, capture_output=True, text=True)
        # Handle amd64 vs x86_64 reporting from the 'file' command
        if expected_arch == 'x86_64' and 'x86_64' in result.stdout:
            return True
        return expected_arch in result.stdout
    except (subprocess.CalledProcessError, FileNotFoundError):
        # If 'file' command fails, assume the binary is invalid and needs replacement.
        return False


def setup_tools():
    """Clones, compiles, and downloads all required command-line tools."""
    print("\n--- ⚙️  Setting up required tools ---")
    WORK_DIR.mkdir(exist_ok=True)
    bin_dir = WORK_DIR / "bin"
    bin_dir.mkdir(exist_ok=True)
    os.environ["PATH"] = f"{bin_dir}:{os.environ['PATH']}"

    # 1. insert-dylib
    insert_dylib_path = bin_dir / "insert-dylib"
    if not check_binary_architecture(insert_dylib_path, CPU_ARCH):
        print(f"\n🔧 Setting up insert-dylib for {CPU_ARCH}...")
        if insert_dylib_path.exists():
            print("   (Removing incorrect architecture version)")
            os.remove(insert_dylib_path)
        repo_path = WORK_DIR / "insert_dylib_repo"
        if repo_path.exists(): shutil.rmtree(repo_path)
        run_command(["git", "clone", INSERT_DYLIB_REPO, str(repo_path)])
        
        source_file = repo_path / "insert_dylib" / "main.c"
        run_command([
            "xcrun", "clang", "-x", "c", "-arch", CPU_ARCH, 
            str(source_file), "-I/usr/include/", "-o", str(insert_dylib_path)
        ])
        run_command(["chmod", "+x", str(insert_dylib_path)])
        print("✅ insert-dylib is set up.")
    else:
        print(f"\n✅ insert-dylib already set up for {CPU_ARCH}.")

    # 2. ivinject
    ivinject_path = bin_dir / "ivinject"
    if not check_binary_architecture(ivinject_path, CPU_ARCH):
        print(f"\n🔧 Setting up ivinject for {CPU_ARCH}...")
        if ivinject_path.exists():
            print("   (Removing incorrect architecture version)")
            os.remove(ivinject_path)
        download_file(IVINJECT_BIN_URL, ivinject_path)
        run_command(["chmod", "+x", str(ivinject_path)])
        
        ivinject_data_dir = WORK_DIR / "ivinject_data"
        if not ivinject_data_dir.exists():
            repo_path = WORK_DIR / "ivinject_repo"
            if repo_path.exists(): shutil.rmtree(repo_path)
            run_command(["git", "clone", IVINJECT_REPO, str(repo_path)])
            shutil.copytree(repo_path / "KnownFrameworks", ivinject_data_dir)
            shutil.rmtree(repo_path)
        print("✅ ivinject is set up.")
    else:
        print(f"\n✅ ivinject already set up for {CPU_ARCH}.")
        
    # 3. ipapatch
    ipapatch_path = bin_dir / "ipapatch"
    if not check_binary_architecture(ipapatch_path, CPU_ARCH):
        print(f"\n🔧 Setting up ipapatch for {CPU_ARCH}...")
        if ipapatch_path.exists():
            print("   (Removing incorrect architecture version)")
            os.remove(ipapatch_path)
        download_file(IPAPATCH_BIN_URL, ipapatch_path)
        run_command(["chmod", "+x", str(ipapatch_path)])
        print("✅ ipapatch is set up.")
    else:
        print(f"\n✅ ipapatch already set up for {CPU_ARCH}.")


def main(ipa_input, tweak_url):
    """Main function to orchestrate the IPA patching process."""
    try:
        # --- 1. Setup ---
        setup_tools()
        OUTPUT_DIR.mkdir(exist_ok=True)

        # --- 2. Build or Download Tweak ---
        tweak_deb = OUTPUT_DIR / "tweak.deb"
        if not tweak_url:
            print("\n--- 🛠️  Building Tweak ---")
            run_command(["git", "apply", str(PATCH_FILE)])
            try:
                run_command(["make", "package"])
                package_dir = Path.cwd() / "packages"
                list_of_files = glob.glob(f"{package_dir}/*.deb")
                latest_file = max(list_of_files, key=os.path.getctime)
                shutil.copy(latest_file, tweak_deb)
            finally:
                run_command(["git", "apply", "-R", str(PATCH_FILE)])
        else:
            print("\n--- 📥 Downloading Tweak ---")
            download_file(tweak_url, tweak_deb)
        
        validate_file_type(
            tweak_deb,
            ["application/vnd.debian.binary-package"],
            "Validation failed: The file is not a valid DEB file."
        )

        # --- 3. Handle IPA ---
        print("\n--- 📥 Handling and validating input files ---")
        original_ipa = OUTPUT_DIR / "original.ipa"

        # Handle IPA input (URL or local file)
        if ipa_input.startswith(('http://', 'https://')):
            download_file(ipa_input, original_ipa)
        elif os.path.isfile(os.path.expanduser(ipa_input)):
            print(f"📂 Using local IPA file: {ipa_input}")
            shutil.copy(os.path.expanduser(ipa_input), original_ipa)
        else:
            raise FileNotFoundError(f"IPA input '{ipa_input}' is not a valid URL or an existing file path.")

        validate_file_type(
            original_ipa,
            ["application/x-ios-app", "application/zip"],
            "Validation failed: The provided file is not a valid IPA."
        )

        # --- 4. Patching Process ---
        print("\n--- 🧩 Starting the patching process ---")
        injected_ipa = OUTPUT_DIR / "injected.ipa"
        patched_ipa = OUTPUT_DIR / "patched-final.ipa"
        
        # Step 4a: Inject tweak with ivinject
        # Temporarily create a symlink for ivinject's data directory
        ivinject_home_link = Path.home() / ".ivinject"
        ivinject_data_src = WORK_DIR / "ivinject_data"
        
        if ivinject_home_link.exists() or ivinject_home_link.is_symlink():
            print(f"⚠️  Warning: '{ivinject_home_link}' already exists. It will be temporarily moved.")
            os.rename(ivinject_home_link, f"{ivinject_home_link}.bak")
        
        try:
            print(f"🔗 Creating temporary symlink for ivinject: {ivinject_home_link}")
            os.symlink(ivinject_data_src, ivinject_home_link, target_is_directory=True)

            print("\n💉 Injecting tweak with ivinject...")
            run_command([
                str(WORK_DIR / "bin" / "ivinject"),
                str(original_ipa),
                str(injected_ipa),
                "-i", str(tweak_deb),
                "-s", "-", "-d", "--level", "Optimal", "--overwrite"
            ])
            print("✅ Tweak injected successfully.")
        finally:
            # Clean up the symlink and restore any backup
            if ivinject_home_link.is_symlink():
                print(f"🧹 Removing temporary symlink: {ivinject_home_link}")
                os.remove(ivinject_home_link)
            
            backup_path = Path(f"{ivinject_home_link}.bak")
            if backup_path.exists():
                print(f" restorring backup: {backup_path}")
                os.rename(backup_path, ivinject_home_link)

        # Step 4b: Patch with ipapatch
        print("\n🩹 Applying patches with ipapatch...")
        run_command([
             str(WORK_DIR / "bin" / "ipapatch"),
            "-input", str(injected_ipa),
            "-output", str(patched_ipa)
        ])
        print("✅ IPA patched successfully.")
        
        # --- 5. Finalizing ---
        print("\n--- 🎉 Process Complete! ---")
        print(f"Final patched IPA saved to: {patched_ipa}")
        print(f"You can find all output files in: {OUTPUT_DIR.resolve()}")

    except Exception as e:
        print(f"\n--- 💥 An error occurred ---")
        print(f"Error: {e}")
        exit(1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="A script to download, patch, and package an IPA with a tweak on macOS.",
        epilog="Example (Build Tweak): python3 ipa_packager.py --ipa <URL_OR_PATH_TO_IPA>\n"
               "Example (URL): python3 ipa_packager.py --ipa <URL_OR_PATH_TO_IPA> --tweak_url <URL_TO_DEB>"
    )
    parser.add_argument(
        "--ipa",
        required=True,
        help="URL or local file path to the decrypted IPA file."
    )
    parser.add_argument(
        "--tweak_url",
        required=False,
        help="URL to the tweak file (.deb). If not provided, the script will build the tweak locally."
    )

    args = parser.parse_args()
    main(args.ipa, args.tweak_url)

