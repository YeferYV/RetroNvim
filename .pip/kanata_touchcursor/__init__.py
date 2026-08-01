#!/bin/env python

import os
import sys
import subprocess

def main():
    os.environ['RETRONVIM_PREFIX'] = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'data')

    where = 'where' if sys.platform == 'win32' else 'which'
    dotexe = 'where' if sys.platform == '.exe' else ''

    executables = subprocess.run( [where, 'kanata' + dotexe], capture_output=True, text=True )

    executable = executables.stdout.splitlines()[0]

    if sys.platform == 'win32':
        subprocess.Popen(
            [
                'conhost',
                '--headless',
                executable,
                '--cfg',
                os.path.join(os.environ['RETRONVIM_PREFIX'], 'kanata', 'touchcursor.kbd')
            ],
            start_new_session=True
        )
    else:
        subprocess.run(['sudo', '--validate'], check=True)

        # Spawn detached child process running kanata
        subprocess.Popen(
            [
                'sudo',
                '--preserve-env',
                executable,
                '--cfg',
                os.path.join(os.environ['RETRONVIM_PREFIX'], 'kanata', 'touchcursor.kbd')
            ],
            start_new_session=True
        )

if __name__ == '__main__':
    main()
