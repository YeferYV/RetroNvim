const vscode = require('vscode');
const path = require('path');
const os = require('os');
const fs = require('fs');
const child_process = require('child_process');

function setNeovimPath(homeExtension) {
  // Construct the dynamic path
  const homeDirectory = os.homedir();
  const yaziBookmarkPath = path.join(homeDirectory, 'appdata/roaming/yazi/state');
  const retronvimPath = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim');
  const nerdfontPath = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim/bin/nerd-fonts/patched-fonts/FiraCode');
  const nerdfontPathLinux = path.join(homeDirectory, '.local/share/fonts/FiraCode');
  const nerdfontPathMacos = path.join(homeDirectory, 'Library/Fonts/FiraCode');
  const nerdfontPathWindows = path.join(homeDirectory, 'AppData/Local/Microsoft/Windows/Fonts/FiraCodeNerdFont-Bold.ttf');
  const nvimPathLinux = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim/bin/linux/envs/linux/bin/nvim');
  const nvimPathMacos = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim/bin/macos/envs/macos/bin/nvim');
  const nvimPathWindows = path.join(homeDirectory, '.vscode/extensions/yeferyv.retronvim/bin/windows/envs/windows/Library/bin/nvim.exe');

  if (os.platform() == "win32") {
    var pixiPath = ".\\.pixi\\envs\\default\\python.exe"
    fs.mkdir(yaziBookmarkPath, { recursive: true }, (err) => { if (err) { vscode.window.showErrorMessage(`${err.message}`) }} );
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

  // install locally nerd-fonts
  if (os.platform() == "win32" && fs.existsSync(nerdfontPathWindows) === false) {
    child_process.exec('powershell.exe -ExecutionPolicy Bypass -File %USERPROFILE%/.vscode/extensions/yeferyv.retronvim/bin/nerd-fonts/install.ps1')
    vscode.window.showInformationMessage('relaunch vscode to load nerd-font')
  }
  if (os.platform() == "linux" && fs.existsSync(nerdfontPathLinux) === false) {
    fs.mkdirSync(path.dirname(nerdfontPathLinux), { recursive: true });
    fs.cpSync(nerdfontPath, nerdfontPathLinux, { recursive: true })
    child_process.exec('fc-cache -f')
    vscode.window.showInformationMessage('relaunch vscode to load nerd-font')
  }
  if (os.platform() == "darwin" && fs.existsSync(nerdfontPathMacos) === false) {
    fs.mkdirSync(path.dirname(nerdfontPathMacos), { recursive: true });
    fs.cpSync(nerdfontPath, nerdfontPathMacos, { recursive: true })
    vscode.window.showInformationMessage('relaunch vscode to load nerd-font')
  }

  // Access the configuration for 'vscode-neovim'
  const config = vscode.workspace.getConfiguration();

  // config.update("telemetry.telemetryLevel", "off", vscode.ConfigurationTarget.Global)
  // config.update('window.titleBarStyle', "custom", vscode.ConfigurationTarget.Global)
  config.update("security.workspace.trust.untrustedFiles", "open", vscode.ConfigurationTarget.Global)
  config.update('window.customMenuBarAltFocus', false, vscode.ConfigurationTarget.Global) // Windows's alt sometimes conflicts with whichkey
  config.update("python.defaultInterpreterPath", pixiPath, vscode.ConfigurationTarget.Global)
  config.update('vscode-neovim.neovimExecutablePaths.linux', nvimPathLinux, vscode.ConfigurationTarget.Global)
  config.update('vscode-neovim.neovimExecutablePaths.darwin', nvimPathMacos, vscode.ConfigurationTarget.Global)
  config.update('vscode-neovim.neovimExecutablePaths.win32', nvimPathWindows, vscode.ConfigurationTarget.Global)
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
