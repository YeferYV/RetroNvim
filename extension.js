const vscode = require('vscode');
const path = require('path');
const os = require('os');

function setNeovimPath() {
  // Construct the dynamic path
  const homeDirectory = os.homedir();
  const nvimPath = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim-0.0.4/bin/nvim');

  // Access the configuration for 'vscode-neovim'
  const config = vscode.workspace.getConfiguration('vscode-neovim');

  // Update the 'neovimExecutablePaths.linux' setting
  config.update('neovimExecutablePaths.linux', nvimPath, vscode.ConfigurationTarget.Global)
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
