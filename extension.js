const vscode = require('vscode');
const path = require('path');
const os = require('os');
const fs = require('fs');

function setNeovimPath() {
  // Construct the dynamic path
  const homeDirectory = os.homedir();
  const nvimPathLinux = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim-0.1.20241228/bin/linux-x64/nvim');
  const nvimPathMacOS = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim-0.1.20241228/bin/darwin-x64/nvim-macos-x86_64/bin/nvim');
  const nvimPathWindows = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim-0.1.20241228/bin/win32-x64/nvim-win64/bin/nvim.exe');
  const nvimPathWindowsRoot = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim-0.1.20241228');
  const nvimPathWindowsRootX64 = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim-0.1.20241228-win32-x64');

  // create symlink if installing from marketplace on Windows 10/11
  if (os.platform() == "win32" && fs.existsSync(nvimPathWindowsRootX64)) {
    fs.symlinkSync(nvimPathWindowsRootX64, nvimPathWindowsRoot)
  }

  // Access the configuration for 'vscode-neovim'
  const config = vscode.workspace.getConfiguration();

  // Update the 'neovimExecutablePaths.linux' setting
  config.update('vscode-neovim.neovimExecutablePaths.linux', nvimPathLinux, vscode.ConfigurationTarget.Global)
    .then(() => {
      vscode.window.showInformationMessage(`Neovim path set to: ${nvimPathLinux}`);
    }, (err) => {
      vscode.window.showErrorMessage(`Failed to set Neovim path: ${err}`);
    });

  config.update('vscode-neovim.neovimExecutablePaths.darwin', nvimPathMacOS, vscode.ConfigurationTarget.Global)
    .then(() => {
      vscode.window.showInformationMessage(`Neovim path set to: ${nvimPathMacOS}`);
    }, (err) => {
      vscode.window.showErrorMessage(`Failed to set Neovim path: ${err}`);
    });

  config.update('vscode-neovim.neovimExecutablePaths.win32', nvimPathWindows, vscode.ConfigurationTarget.Global)
    .then(() => {
      vscode.window.showInformationMessage(`Neovim path set to: ${nvimPathWindows}`);
    }, (err) => {
      vscode.window.showErrorMessage(`Failed to set Neovim path: ${err}`);
    });

  // config.update("telemetry.telemetryLevel", "off", vscode.ConfigurationTarget.Global)
  // config.update('window.titleBarStyle', "custom", vscode.ConfigurationTarget.Global)
  config.update("security.workspace.trust.untrustedFiles", "open", vscode.ConfigurationTarget.Global)
  config.update('window.customMenuBarAltFocus', false, vscode.ConfigurationTarget.Global) // Windows's alt sometimes conflicts with whichkey

}

// You can call this function in your extension's activate function or based on certain events
function activate(context) {
  setNeovimPath();
}

exports.activate = activate;
