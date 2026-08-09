#!/bin/env python

import os
import sys
import subprocess

def main():
    os.environ['RETRONVIM_PREFIX'] = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'data')
    os.environ['ZDOTDIR'] = os.path.join(os.environ['RETRONVIM_PREFIX'], 'zsh')


    where_zsh = ['where', 'zsh.exe'] if sys.platform == 'win32' else ['which', '-a', 'zsh']
    dotexe = '.exe' if sys.platform == 'win32' else ''

    executables = subprocess.run( where_zsh, capture_output=True, text=True ).stdout.splitlines()
    executable = [item for item in executables if item != sys.argv[0] + dotexe][0]

    subprocess.run([executable] + sys.argv[1:])

if __name__ == '__main__':
    main()
