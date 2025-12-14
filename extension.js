const vscode        = require('vscode');
const path          = require('path');
const os            = require('os');
const process       = require('process');
const fs            = require('fs');
const child_process = require('child_process');

function setNeovimPath(homeExtension) {
  // Construct the dynamic path
  const homeDirectory       = os.homedir();
  const yaziBookmarkPath    = path.join(homeDirectory, 'appdata/roaming/yazi/state');
  const nerdfontPath        = path.join(homeExtension, '/bin/nerd-fonts/patched-fonts/FiraCode');
  const nerdfontPathLinux   = path.join(homeDirectory, '.local/share/fonts/FiraCode');
  const nerdfontPathMacos   = path.join(homeDirectory, 'Library/Fonts/FiraCode');
  const nerdfontPathWindows = path.join(homeDirectory, 'AppData/Local/Microsoft/Windows/Fonts/FiraCodeNerdFont-Bold.ttf');
  const nvimPath            = path.join(homeDirectory, '/.vscode/extensions/yefery.retronvim');
  const nvimPathUnix        = path.join(homeExtension, '/bin/env/bin/nvim');
  const nvimPathWindows     = path.join(homeExtension, '/bin/windows/envs/windows/Library/bin/nvim.exe');
  const gitPathUnix         = path.join(homeExtension, '/bin/env/bin/git');
  const gitPathWindows      = path.join(homeExtension, '/bin/windows/envs/windows/Library/mingw64/bin/git.exe');
  const javaPathUnix        = path.join(homeDirectory, '/.pixi/envs/openjdk/lib/jvm');
  const javaPathWindows     = path.join(homeDirectory, '/.pixi/envs/openjdk/Library/lib/jvm');
  const initDotLuaPath      = path.join(homeExtension, '/nvim/init.lua');

  if (os.platform() == "win32") {
    fs.mkdir(yaziBookmarkPath, { recursive: true }, (err) => { if (err) { vscode.window.showErrorMessage(`${err.message}`) }} );
    var gitPath = gitPathWindows
    var pixiPath = ".\\.pixi\\envs\\default\\python.exe"
    var javaPath = javaPathWindows
  } else {
    var gitPath = gitPathUnix
    var pixiPath = "./.pixi/envs/default/bin/python"
    var javaPath = javaPathUnix
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
  fs.existsSync(nvimPath) && fs.rmSync(nvimPath, { recursive: true })

  // decompress terminal dependencies
  if (os.platform() == "win32" && fs.existsSync(gitPathWindows) === false) {
    child_process.exec('powershell -c "try { cd '+ homeExtension +'/bin; ./7zr.exe x windows.7z; }" catch {}')
  }
  if (os.platform() == "linux" && fs.existsSync(gitPathUnix) === false) {
    child_process.exec('(cd ' + homeExtension + '/bin && ./environment.sh 2>/dev/null)')
  }
  if (os.platform() == "darwin" && fs.existsSync(gitPathUnix) === false) {
    child_process.exec('(cd ' + homeExtension + '/bin && ./environment.sh 2>/dev/null)')
  }

  // Access the configuration for 'vscode-neovim'
  const config = vscode.workspace.getConfiguration();

  // config.update("telemetry.telemetryLevel", "off", vscode.ConfigurationTarget.Global)
  // config.update('window.titleBarStyle', "custom", vscode.ConfigurationTarget.Global)
  config.update("extensions.experimental.affinity", { "asvetliakov.vscode-neovim": 1, "vscodevim.vim": 2 }, vscode.ConfigurationTarget.Global);
  config.update("extensions.gallery.itemUrl", "https://marketplace.visualstudio.com/items", vscode.ConfigurationTarget.Global) // vscode marketplace for cursor
  config.update("extensions.gallery.serviceUrl", "https://marketplace.visualstudio.com/_apis/public/gallery", vscode.ConfigurationTarget.Global) // vscode marketplace fo rcursor
  config.update("git.path", gitPath, vscode.ConfigurationTarget.Global)
  config.update("java.configuration.runtimes", [{ "name": "JavaSE-25", "path": javaPath, "default": true }], vscode.ConfigurationTarget.Global);
  config.update("java.jdt.ls.java.home", javaPath, vscode.ConfigurationTarget.Global)
  config.update("python.defaultInterpreterPath", pixiPath, vscode.ConfigurationTarget.Global)
  config.update("security.workspace.trust.untrustedFiles", "open", vscode.ConfigurationTarget.Global)
  config.update("terminal.integrated.windowsUseConptyDll", true, vscode.ConfigurationTarget.Global) // for yazi image preview on windows but sometimes yazi refuses to open
  config.update("vscode-neovim.neovimExecutablePaths.darwin", nvimPathUnix, vscode.ConfigurationTarget.Global)
  config.update("vscode-neovim.neovimExecutablePaths.linux", nvimPathUnix, vscode.ConfigurationTarget.Global)
  config.update("vscode-neovim.neovimExecutablePaths.win32", nvimPathWindows, vscode.ConfigurationTarget.Global)
  config.update("vscode-neovim.neovimInitVimPaths.darwin", initDotLuaPath, vscode.ConfigurationTarget.Global)
  config.update("vscode-neovim.neovimInitVimPaths.linux", initDotLuaPath, vscode.ConfigurationTarget.Global)
  config.update("vscode-neovim.neovimInitVimPaths.win32", initDotLuaPath, vscode.ConfigurationTarget.Global)
  config.update("window.customMenuBarAltFocus", false, vscode.ConfigurationTarget.Global) // Windows's alt sometimes conflicts with whichkey
  config.update("windsurf.marketplaceExtensionGalleryServiceURL", "https://marketplace.visualstudio.com/_apis/public/gallery", vscode.ConfigurationTarget.Global)
  config.update("windsurf.marketplaceGalleryItemURL", "https://marketplace.visualstudio.com/items", vscode.ConfigurationTarget.Global)
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

  const fzf_preview       = "--color 'hl:-1:reverse,hl+:-1:reverse' --preview 'bat --color=always {}' --preview-window 'hidden' --bind '?:toggle-preview' --multi"
  const home              = os.homedir();
  const dotexe            = os.platform() == "win32" ? '.exe' : ''
  const bin_path          = os.platform() == "win32" ? '/bin/windows/envs/windows/Library/bin/' : '/bin/env/bin/'
  const retronvim_bin     = path.join(context.extensionPath, bin_path)
  const init_lua          = path.join(context.extensionPath, '/nvim/init.lua')
  const yazi_config_home  = path.join(context.extensionPath, '/yazi')
  const yazi_file_one     = path.join(context.extensionPath, '/bin/windows/envs/windows/Library/usr/bin/file.exe')
  const yazi_choosen_file = path.join(home, '/.yazi')
  const mingw_path        = path.join(context.extensionPath, '/bin/windows/envs/windows/Library/mingw64/bin;')
  const win_path          = retronvim_bin + `;${home}\\.pixi\\bin;${home}\\.local\\bin;${home}appdata\\local\\pnpm;` + mingw_path + process.env.PATH
  const unix_path         = retronvim_bin + `:${home}/pixi/bin:${home}/.local/bin:${home}/Library/pnpm:${home}/Library/pnpm:` + process.env.PATH
  const get_path          = os.platform() == "win32" ? win_path : unix_path
  const get_yazi_file_one = os.platform() == "win32" ? yazi_file_one : null

  let open_yazi = vscode.commands.registerCommand("retronvim.yazi", () => {
    let curr_file = vscode.window.activeTextEditor?.document.uri.fsPath || ""
    let yazi_args = curr_file ? ["--chooser-file", yazi_choosen_file, curr_file] : ["--chooser-file", yazi_choosen_file]

    fs.existsSync(yazi_choosen_file) && fs.rmSync(yazi_choosen_file)

    let yaziTerminal = vscode.window.createTerminal({
      name: "Yazi",
      shellPath: "yazi",
      shellArgs: yazi_args,
      location: vscode.TerminalLocation.Editor,
      env: {
        // EDITOR: "code",
        // YAZI_CMD: 'ya emit quit',
        BAT_THEME: "base16",
        FZF_DEFAULT_OPTS: fzf_preview,
        PATH: get_path,
        VIMINIT: `lua vim.cmd.source([[${init_lua}]])`,
        YAZI_CONFIG_HOME: yazi_config_home,
        YAZI_FILE_ONE: get_yazi_file_one,
      },
    })

    // yaziTerminal.show(); // not required if vscode.TerminalLocation.Editor

    // https://github.com/dautroc/yazi-vscode/blob/main/src/extension.ts
    const closeSubscription = vscode.window.onDidCloseTerminal(async (terminal) => {
      if (terminal === yaziTerminal && fs.existsSync(yazi_choosen_file)) {

          const filePaths = fs.readFileSync(yazi_choosen_file, "utf8").trim().split('\n')

          for (const filePath of filePaths) {
            const doc = await vscode.workspace.openTextDocument(filePath);
            await vscode.window.showTextDocument(doc, { preview: false });
          }
      }
      closeSubscription.dispose();
    })
  })

  let open_lazygit = vscode.commands.registerCommand("retronvim.lazygit", () => {

    vscode.window.createTerminal({
      name: "Lazygit",
      shellPath: retronvim_bin + 'lazygit' + dotexe,
      location: vscode.TerminalLocation.Editor,
      env: {
        PATH: get_path,
        VIMINIT: `lua vim.cmd.source([[${init_lua}]])`,
      },
    })
  })

  context.subscriptions.push(open_yazi, open_lazygit);
}

exports.activate = activate;
