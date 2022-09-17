#!/usr/bin/env python3

import sys
import subprocess
from glob import glob
from os.path import basename, splitext, join


sys.path.insert(0, join(sys.path[0], "tools/"))


from tools import tilda_converter
from tools import xrdb2konsole
from tools import xrdb2terminator
from tools import xrdb2Xresources
from tools import xrdb2putty
from tools import xrdb2xfce_terminal
from tools import xrdb2Remmina
from tools import xrdb2Termite
from tools import xrdb2freebsd_vt
from tools import xrdb2kitty
from tools import xrdb2moba
from tools import xrdb2lxterm
from tools import xrdb2pantheon_terminal
from tools import xrdb2wezterm
from tools import xrdb2windowsterminal
from tools import xrdb2dynamic_color
from tools import xrdb2alacritty
from tools import xrdb2electerm
from tools import xrdb2vscode

if __name__ == "__main__":

    for f in glob("schemes/*.itermcolors"):
        base_name = splitext(basename(f))[0]
        xrdb_filepath = join("xrdb", base_name + ".xrdb")
        with open(xrdb_filepath, "w") as fout:
            ret_code = subprocess.Popen(["./tools/iterm2xrdb", f], stdout=fout).wait()
            print(ret_code and "ERROR" or "OK" + " --> " + xrdb_filepath)

    xrdb2konsole.main("xrdb/", "konsole/")
    print("OK --> " + "konsole/")
    # xrdb2terminator.main('xrdb/', 'terminator/')
    # print('OK --> ' + 'terminator/')
    xrdb2Xresources.main("xrdb/", "Xresources/")
    # print('OK --> ' + 'Xresources/')
    # xrdb2putty.main('xrdb/', 'putty/')
    # print('OK --> ' + 'putty/')
    # xrdb2xfce_terminal.main('xrdb/', 'xfce4terminal/colorschemes/')
    # print('OK --> ' + 'xfce4terminal/colorschemes/')
    # xrdb2Remmina.main('xrdb/', 'remmina/')
    # print('OK --> ' + 'Remmina/')
    # xrdb2Termite.main('xrdb/', 'termite/')
    # print('OK --> ' + 'termite/')
    # xrdb2freebsd_vt.main('xrdb/', 'freebsd_vt/')
    # print('OK --> ' + 'freebsd_vt/')
    xrdb2kitty.main("xrdb/", "kitty/")
    print("OK --> " + "kitty/")
    # xrdb2moba.main("xrdb", "mobaxterm")
    # print("OK --> " + "mobaxterm/")
    # xrdb2lxterm.main("xrdb", "lxterminal")
    # print("OK --> " + "lxterminal/")
    # xrdb2pantheon_terminal.main("xrdb/", "pantheonterminal/")
    # print("OK --> " + "pantheonterminal/")
    xrdb2wezterm.main("xrdb/", "wezterm/")
    # print("OK --> " + "wezterm/")
    # xrdb2windowsterminal.main("xrdb/", "windowsterminal/")
    # print("OK --> " + "windowsterminal/")
    # xrdb2dynamic_color.main("xrdb/", "dynamic-colors/")
    # print("OK --> " + "dynamic-colors/")
    xrdb2alacritty.main("xrdb/", "alacritty/")
    print("OK --> " + "alacritty/")
    # xrdb2electerm.main("xrdb/", "electerm/")
    # print("OK --> " + "electerm/")
    # xrdb2vscode.main("xrdb/", "vscode/")
    # print("OK --> " + "vscode/")
    # tilda_converter.main("schemes/", "tilda/")
    # print("OK --> " + "tilda/")
