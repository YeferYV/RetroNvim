#!/usr/bin/env node

const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

process.env.RETRONVIM_PREFIX = path.dirname(path.dirname(fs.realpathSync(process.argv[1])))
process.env.ZDOTDIR = path.join(process.env.RETRONVIM_PREFIX, 'zsh');

const where = os.platform() === 'win32' ? 'where' : 'which';
const where_flags = os.platform() === 'win32' ? ['zsh.exe'] : ['-a', 'zsh'];

const executables = execFileSync(where, where_flags, { encoding: 'utf8' })
const executable = executables.split(/\r?\n/).filter(item => item !== process.argv[1])[0] // process.argv[1] expands to full path

execFileSync(executable, process.argv.slice(2), { stdio: 'inherit' });
