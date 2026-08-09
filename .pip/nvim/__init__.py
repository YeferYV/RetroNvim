#!/bin/env python

import os
import sys
import subprocess

def main():
    os.environ['RETRONVIM_PREFIX'] = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'data')
    os.environ['SHELL'] = 'zsh'
    os.environ['VIMINIT'] = f"lua vim.cmd.source(vim.env.RETRONVIM_PREFIX .. [[/nvim/init.lua]])"
    os.environ['ZDOTDIR'] = os.environ['RETRONVIM_PREFIX'] + '/zsh'

    os.environ['BAT_THEME'] = 'base16'
    os.environ['FZF_DEFAULT_OPTS'] = '--color "hl:-1:reverse,hl+:-1:reverse" --preview "bat --color=always {}" --preview-window=hidden --bind "?:toggle-preview" --multi'
    os.environ['LESS'] = '--ignore-case'
    os.environ['LESSKEYIN'] = os.path.join(os.environ['RETRONVIM_PREFIX'], 'yazi', 'lesskey')
    os.environ['LESSHISTFILE'] = '-'
    os.environ['YAZI_CONFIG_HOME'] = os.path.join(os.environ['RETRONVIM_PREFIX'], 'yazi')

    where_nvim = ['where', 'nvim.exe'] if sys.platform == 'win32' else ['which', '-a', 'nvim']
    dotexe = '.exe' if sys.platform == 'win32' else ''

    executables = subprocess.run( where_nvim, capture_output=True, text=True ).stdout.splitlines()
    executable = [item for item in executables if item != sys.argv[0] + dotexe][0]

    subprocess.run([executable] + sys.argv[1:])

if __name__ == '__main__':
    main()
