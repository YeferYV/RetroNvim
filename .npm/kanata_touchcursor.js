#!/usr/bin/env node

const { spawn, execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

const self = fs.realpathSync(process.argv[1]);
process.env.RETRONVIM_PREFIX = path.dirname(path.dirname(self))

const where = os.platform() === 'win32' ? 'where' : 'which';
const dotexe = os.platform() === 'win32' ? '.exe' : '';

const executable = execFileSync(where, ['kanata' + dotexe], { encoding: 'utf8' }).trim().split(/\r?\n/)[0];

if (os.platform() === 'win32'){
  const child = spawn(
    'conhost',
    [
      '--headless',
      executable,
      '--cfg',
      path.join(process.env.RETRONVIM_PREFIX, 'kanata', 'touchcursor.kbd')
    ],
    {stdio: 'inherit', detached: true,}
  );
  child.unref();
} else{
  execFileSync('sudo', ['--validate'], { stdio: 'inherit' });

  const child = spawn(
    'sudo',
    [
      '--preserve-env',
      executable,
      '--cfg',
      path.join(process.env.RETRONVIM_PREFIX, 'kanata', 'touchcursor.kbd')
    ],
    {stdio: 'inherit', detached: true,}
  );
  child.unref();
}

