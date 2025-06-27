const vscode = require('vscode');
const path = require('path');
const os = require('os');
const fs = require('fs');
const child_process = require('child_process');

function setNeovimPath(homeExtension) {
  // Construct the dynamic path
  const homeDirectory = os.homedir();
  const yaziBookmarkPath = path.join(homeDirectory, 'appdata/roaming/yazi/state');
  const nerdfontPath = path.join(homeExtension, '/bin/nerd-fonts/patched-fonts/FiraCode');
  const nerdfontPathLinux = path.join(homeDirectory, '.local/share/fonts/FiraCode');
  const nerdfontPathMacos = path.join(homeDirectory, 'Library/Fonts/FiraCode');
  const nerdfontPathWindows = path.join(homeDirectory, 'AppData/Local/Microsoft/Windows/Fonts/FiraCodeNerdFont-Bold.ttf');
  const nvimPath = path.join(homeDirectory, '/.vscode/extensions/yefery.retronvim');
  const nvimPathLinux = path.join(homeExtension, '/bin/env/bin/nvim');
  const nvimPathMacos = path.join(homeExtension, '/bin/env/bin/nvim');
  const nvimPathWindows = path.join(homeExtension, '/bin/windows/envs/windows/Library/bin/nvim.exe');
  const initDotLuaPath = path.join(homeExtension, '/nvim/init.lua');

  if (os.platform() == "win32") {
    var pixiPath = ".\\.pixi\\envs\\default\\python.exe"
    fs.mkdir(yaziBookmarkPath, { recursive: true }, (err) => { if (err) { vscode.window.showErrorMessage(`${err.message}`) }} );
  } else {
    var pixiPath = "./.pixi/envs/default/bin/python"
  }

  // install locally nerd-fonts
  if (os.platform() == "win32" && fs.existsSync(nerdfontPathWindows) === false) {
    child_process.exec('powershell.exe -ExecutionPolicy Bypass -File ' + homeExtension + '/bin/nerd-fonts/install.ps1')
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

  // remove ~/.vscode/extensions/yefery.retronvim created by retronvim/nvim/init.lua when retronvim extensions was not installed previously
  if (fs.existsSync(nvimPath)) {
    fs.rmSync(nvimPath, { recursive: true })
  }

  // decompress terminal dependencies
  if (os.platform() == "win32" && fs.existsSync(nvimPathWindows) === false) {
    child_process.exec('try { cd '+ homeExtension +'/bin; ./7zr.exe x windows.7z; } catch {};')
  }
  if (os.platform() == "linux" && fs.existsSync(nvimPathLinux) === false) {
    child_process.exec('(cd ' + homeExtension + '/bin && ./environment.sh 2>/dev/null)')
  }
  if (os.platform() == "darwin" && fs.existsSync(nvimPathMacos) === false) {
    child_process.exec('(cd ' + homeExtension + '/bin && ./environment.sh 2>/dev/null)')
  }

  // Access the configuration for 'vscode-neovim'
  const config = vscode.workspace.getConfiguration();

  // config.update("telemetry.telemetryLevel", "off", vscode.ConfigurationTarget.Global)
  // config.update('window.titleBarStyle', "custom", vscode.ConfigurationTarget.Global)
  // config.update("terminal.integrated.windowsUseConptyDll", vscode.ConfigurationTarget.Global) // for yazi image preview on windows but sometimes yazi refuses to open
  config.update("security.workspace.trust.untrustedFiles", "open", vscode.ConfigurationTarget.Global)
  config.update('window.customMenuBarAltFocus', false, vscode.ConfigurationTarget.Global) // Windows's alt sometimes conflicts with whichkey
  config.update("python.defaultInterpreterPath", pixiPath, vscode.ConfigurationTarget.Global)
  config.update('vscode-neovim.neovimExecutablePaths.linux', nvimPathLinux, vscode.ConfigurationTarget.Global)
  config.update('vscode-neovim.neovimExecutablePaths.darwin', nvimPathMacos, vscode.ConfigurationTarget.Global)
  config.update('vscode-neovim.neovimExecutablePaths.win32', nvimPathWindows, vscode.ConfigurationTarget.Global)
	config.update('vscode-neovim.neovimInitVimPaths.linux', initDotLuaPath, vscode.ConfigurationTarget.Global)
	config.update('vscode-neovim.neovimInitVimPaths.darwin', initDotLuaPath, vscode.ConfigurationTarget.Global)
	config.update('vscode-neovim.neovimInitVimPaths.win32', initDotLuaPath, vscode.ConfigurationTarget.Global)
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
