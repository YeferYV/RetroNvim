const vscode = require('vscode');
const path = require('path');
const os = require('os');
const fs = require('fs');

function setNeovimPath(homeExtension) {
  // Construct the dynamic path
  const homeDirectory = os.homedir();
  const yaziBookmarkPath = path.join(homeDirectory, 'appdata/roaming/yazi/state');
  const retronvimPath = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim');
  const nvimPathPixi = path.join(homeDirectory, '.pixi/bin/nvim');
  const nvimPathLinux = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim/bin/linux-x64/nvim');
  const nvimPathMacOS = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim/bin/darwin-x64/nvim-macos-x86_64/bin/nvim');
  const nvimPathWindows = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim/bin/win32-x64/nvim-win64/bin/nvim.exe');

  if (os.platform() == "win32") {
    var pixiPath = ".\\.pixi\\envs\\default\\python.exe"
    fs.mkdir(yaziBookmarkPath, { recursive: true }, (err) => { vscode.window.showErrorMessage(`${err.message}`) } );
  } else {
    var pixiPath = "./.pixi/envs/default/bin/python"
  }

  // create symlink for environment variables path
  if (fs.existsSync(retronvimPath)) {
    fs.unlinkSync(retronvimPath)
    fs.symlinkSync(homeExtension, retronvimPath)
  } else {
    fs.symlinkSync(homeExtension, retronvimPath)
  }

  // Access the configuration for 'vscode-neovim'
  const config = vscode.workspace.getConfiguration();

  // config.update("telemetry.telemetryLevel", "off", vscode.ConfigurationTarget.Global)
  // config.update('window.titleBarStyle', "custom", vscode.ConfigurationTarget.Global)
  config.update("security.workspace.trust.untrustedFiles", "open", vscode.ConfigurationTarget.Global)
  config.update('window.customMenuBarAltFocus', false, vscode.ConfigurationTarget.Global) // Windows's alt sometimes conflicts with whichkey
  config.update("python.defaultInterpreterPath", pixiPath, vscode.ConfigurationTarget.Global)

  if (fs.existsSync(nvimPathPixi)) {
    config.update('vscode-neovim.neovimExecutablePaths.linux', nvimPathPixi, vscode.ConfigurationTarget.Global)
    config.update('vscode-neovim.neovimExecutablePaths.darwin', nvimPathPixi, vscode.ConfigurationTarget.Global)
  }
  if (fs.existsSync(nvimPathLinux)) {
    config.update('vscode-neovim.neovimExecutablePaths.linux', nvimPathLinux, vscode.ConfigurationTarget.Global)
  }
  if (fs.existsSync(nvimPathMacOS)) {
    config.update('vscode-neovim.neovimExecutablePaths.darwin', nvimPathMacOS, vscode.ConfigurationTarget.Global)
  }
  if (fs.existsSync(nvimPathWindows)) {
    config.update('vscode-neovim.neovimExecutablePaths.win32', nvimPathWindows, vscode.ConfigurationTarget.Global)
  }
}

// You can call this function in your extension's activate function or based on certain events
function activate(context) {
  // https://stackoverflow.com/questions/44113025/how-to-dynamically-query-my-vscode-extension-version-from-the-extension-code
  // vscode.window.showInformationMessage(context.extension.packageJSON.version);

  // https://stackoverflow.com/questions/39569993/vs-code-extension-get-full-path
  setNeovimPath(context.extensionPath);
  // vscode.window.showInformationMessage(context.extensionUri);
  // vscode.window.showInformationMessage(context.extensionPath);
  // vscode.window.showInformationMessage(context.extension);
}

exports.activate = activate;
