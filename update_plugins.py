import os
import shutil
import tempfile
import urllib.error
import urllib.request
import zipfile
from io import BytesIO
from os import path

# --- Globals ----------------------------------------------
PLUGINS = """
auto-pairs https://github.com/jiangmiao/auto-pairs
ale https://github.com/dense-analysis/ale
vim-yankstack https://github.com/maxbrunsfeld/vim-yankstack
ack.vim https://github.com/mileszs/ack.vim
bufexplorer https://github.com/jlanzarotta/bufexplorer
ctrlp.vim https://github.com/ctrlpvim/ctrlp.vim
mayansmoke https://github.com/vim-scripts/mayansmoke
nerdtree https://github.com/preservim/nerdtree
nginx.vim https://github.com/chr4/nginx.vim
open_file_under_cursor.vim https://github.com/amix/open_file_under_cursor.vim
tlib https://github.com/tomtom/tlib_vim
vim-addon-mw-utils https://github.com/MarcWeber/vim-addon-mw-utils
vim-bundle-mako https://github.com/sophacles/vim-bundle-mako
vim-coffee-script https://github.com/kchmck/vim-coffee-script
vim-colors-solarized https://github.com/altercation/vim-colors-solarized
vim-indent-object https://github.com/michaeljsmith/vim-indent-object
vim-less https://github.com/groenewege/vim-less
vim-pyte https://github.com/therubymug/vim-pyte
vim-snipmate https://github.com/garbas/vim-snipmate
vim-snippets https://github.com/honza/vim-snippets
vim-surround https://github.com/tpope/vim-surround
vim-expand-region https://github.com/terryma/vim-expand-region
vim-multiple-cursors https://github.com/terryma/vim-multiple-cursors
vim-fugitive https://github.com/tpope/vim-fugitive
vim-rhubarb https://github.com/tpope/vim-rhubarb
goyo.vim https://github.com/junegunn/goyo.vim
vim-zenroom2 https://github.com/amix/vim-zenroom2
vim-repeat https://github.com/tpope/vim-repeat
vim-commentary https://github.com/tpope/vim-commentary
vim-gitgutter https://github.com/airblade/vim-gitgutter
gruvbox https://github.com/morhetz/gruvbox
vim-flake8 https://github.com/nvie/vim-flake8
vim-pug https://github.com/digitaltoad/vim-pug
lightline.vim https://github.com/itchyny/lightline.vim
lightline-ale https://github.com/maximbaz/lightline-ale
vim-abolish https://github.com/tpope/vim-abolish
rust.vim https://github.com/rust-lang/rust.vim
vim-markdown https://github.com/plasticboy/vim-markdown
vim-gist https://github.com/mattn/vim-gist
vim-ruby https://github.com/vim-ruby/vim-ruby
typescript-vim https://github.com/leafgarland/typescript-vim
vim-javascript https://github.com/pangloss/vim-javascript
vim-python-pep8-indent https://github.com/Vimjas/vim-python-pep8-indent
vim-indent-guides https://github.com/nathanaelkane/vim-indent-guides
mru.vim https://github.com/vim-scripts/mru.vim
editorconfig-vim https://github.com/editorconfig/editorconfig-vim
dracula https://github.com/dracula/vim
copilot.vim https://github.com/github/copilot.vim
tabular https://github.com/godlygeek/tabular
vim-lastplace https://github.com/farmergreg/vim-lastplace
""".strip()

SOURCE_DIR = path.join(path.dirname(__file__), "pack", "vendor", "start")

# Plugins locked at specific versions for backward compatibility
LOCKED_PLUGINS = {
    "copilot.vim": "locked at 1.40.0 for Vim 8.0.1763 compatibility (upstream >= 1.50 requires Vim 9.0+)"
}


def download_zip(github_url):
    """Download repository zip archive, trying HEAD then main then master branch."""
    headers = {"User-Agent": "Mozilla/5.0 (Vimrc-Plugin-Updater)"}
    for target in ["HEAD", "main", "master"]:
        url = f"{github_url}/archive/{target}.zip"
        try:
            req = urllib.request.Request(url, headers=headers)
            with urllib.request.urlopen(req, timeout=45) as resp:
                return resp.read()
        except urllib.error.HTTPError as e:
            if e.code == 404:
                continue
            raise
    raise RuntimeError(f"Unable to download archive for {github_url}")


def download_extract_replace(plugin_name, github_url, temp_dir, source_dir):
    data = download_zip(github_url)
    zip_f = zipfile.ZipFile(BytesIO(data))
    zip_f.extractall(temp_dir)

    # The top-level folder inside the GitHub zip
    top_entries = [name for name in os.listdir(temp_dir) if path.isdir(path.join(temp_dir, name))]
    if not top_entries:
        raise RuntimeError("No folder found in extracted zip")
    plugin_temp_path = path.join(temp_dir, top_entries[0])

    plugin_dest_path = path.join(source_dir, plugin_name)
    try:
        shutil.rmtree(plugin_dest_path)
    except OSError:
        pass

    shutil.move(plugin_temp_path, plugin_dest_path)
    print(f"Updated {plugin_name}")


def update(plugin):
    parts = plugin.strip().split()
    if len(parts) != 2:
        return
    name, github_url = parts
    if name in LOCKED_PLUGINS:
        print(f"Skipping locked plugin '{name}': {LOCKED_PLUGINS[name]}")
        return
    temp_directory = tempfile.mkdtemp()
    try:
        download_extract_replace(name, github_url, temp_directory, SOURCE_DIR)
    except Exception as exp:
        print(f"Could not update {name}. Error was: {exp}")
    finally:
        shutil.rmtree(temp_directory, ignore_errors=True)


if __name__ == "__main__":
    os.makedirs(SOURCE_DIR, exist_ok=True)
    for line in PLUGINS.splitlines():
        update(line)
