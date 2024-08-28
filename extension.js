const vscode = require('vscode');
const path = require('path');
const os = require('os');

function setNeovimPath() {
  // Construct the dynamic path
  const homeDirectory = os.homedir();
  const nvimPathLinux = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim-0.0.4/bin/nvim');
  const nvimPathMacOS = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim-0.0.4/bin/nvim-macos-x86_64/bin/nvim');
  const nvimPathWindows = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim-0.0.4/bin/nvim-win64/bin/nvim.exe');

  // Access the configuration for 'vscode-neovim'
  const config = vscode.workspace.getConfiguration('vscode-neovim');

  // Update the 'neovimExecutablePaths.linux' setting
  config.update('neovimExecutablePaths.linux', nvimPathLinux, vscode.ConfigurationTarget.Global)
    .then(() => {
      vscode.window.showInformationMessage(`Neovim path set to: ${nvimPath}`);
    }, (err) => {
      vscode.window.showErrorMessage(`Failed to set Neovim path: ${err}`);
    });

  config.update('neovimExecutablePaths.darwin', nvimPathMacOS, vscode.ConfigurationTarget.Global)
    .then(() => {
      vscode.window.showInformationMessage(`Neovim path set to: ${nvimPath}`);
    }, (err) => {
      vscode.window.showErrorMessage(`Failed to set Neovim path: ${err}`);
    });

  config.update('neovimExecutablePaths.win32', nvimPathWindows, vscode.ConfigurationTarget.Global)
    .then(() => {
      vscode.window.showInformationMessage(`Neovim path set to: ${nvimPath}`);
    }, (err) => {
      vscode.window.showErrorMessage(`Failed to set Neovim path: ${err}`);
    });
}

// You can call this function in your extension's activate function or based on certain events
function activate(context) {
  setNeovimPath();
}

exports.activate = activate;
