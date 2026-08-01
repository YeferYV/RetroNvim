#!/usr/bin/env node

const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

const self = fs.realpathSync(process.argv[1]);

process.env.RETRONVIM_PREFIX = path.dirname(path.dirname(self))
process.env.ZDOTDIR = path.join(process.env.RETRONVIM_PREFIX, 'zsh');

const where = os.platform() === 'win32' ? 'where' : 'which';
const dotexe = os.platform() === 'win32' ? '.exe' : '';

const executable = execFileSync(where, ['zsh' + dotexe], { encoding: 'utf8' }).trim().split(/\r?\n/)[0];

execFileSync(executable, process.argv.slice(2), { stdio: 'inherit' });
