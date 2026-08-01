#!/usr/bin/env node

const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

const self = fs.realpathSync(process.argv[1]);

process.env.RETRONVIM_PREFIX = path.dirname(path.dirname(self))
process.env.SHELL = 'zsh'
process.env.VIMINIT = `lua vim.cmd.source(vim.env.RETRONVIM_PREFIX .. [[/nvim/init.lua]])`;
process.env.ZDOTDIR = path.join(process.env.RETRONVIM_PREFIX, 'zsh');

process.env.BAT_THEME = 'base16';
process.env.FZF_DEFAULT_OPTS = '--color "hl:-1:reverse,hl+:-1:reverse" --preview "bat --color=always {}" --preview-window=hidden --bind "?:toggle-preview" --multi';
process.env.LESS = '--ignore-case';
process.env.LESSKEYIN = path.join(process.env.RETRONVIM_PREFIX, 'yazi', 'lesskey');
process.env.LESSHISTFILE = '-';
process.env.YAZI_CONFIG_HOME = path.join(process.env.RETRONVIM_PREFIX, 'yazi');

const where = os.platform() === 'win32' ? 'where' : 'which';
const dotexe = os.platform() === 'win32' ? '.exe' : '';

const executable = execFileSync(where, ['nvim' + dotexe], { encoding: 'utf8' }).trim().split(/\r?\n/)[0];

execFileSync(executable, process.argv.slice(2), { stdio: 'inherit' });
