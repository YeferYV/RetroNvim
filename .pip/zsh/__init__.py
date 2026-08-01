#!/bin/env python

import os
import sys
import subprocess

def main():
    os.environ['RETRONVIM_PREFIX'] = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'data')
    os.environ['ZDOTDIR'] = os.path.join(os.environ['RETRONVIM_PREFIX'], 'zsh')

    where = 'where' if sys.platform == 'win32' else 'which'
    dotexe = 'where' if sys.platform == '.exe' else ''

    executables = subprocess.run( [where, 'zsh' + dotexe], capture_output=True, text=True )

    executable = executables.stdout.splitlines()[1] if sys.platform == 'win32' else executables.stdout.splitlines()[0]

    subprocess.run([executable] + sys.argv[1:])

if __name__ == '__main__':
    main()
