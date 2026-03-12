const vscode        = require('vscode');
const path          = require('path');
const os            = require('os');
const fs            = require('fs');
const child_process = require('child_process');

function setNeovimPath(homeExtension) {
  const homeDirectory       = os.homedir();
  const dotexe              = os.platform() == "win32" ? '.exe' : ''
  const dotcmd              = os.platform() == "win32" ? '.cmd' : ''
  const initDotLuaPath      = path.join(homeDirectory, '/.pixi/envs/retronvim/opt/retronvim/nvim/init.lua');
  const gitPath             = path.join(homeDirectory, '/.pixi/bin/git', dotexe);
  const nvimPath            = path.join(homeDirectory, '/.pixi/bin/nvim', dotexe);
  const pixiPath            = path.join(homeExtension, '/bin/pixi', dotexe);
  const pythonPath          = path.join('./.pixi/envs/default/bin/python', dotexe);
  const javaPathUnix        = path.join(homeDirectory, '/.pixi/envs/openjdk/lib/jvm');
  const javaPathWindows     = path.join(homeDirectory, '/.pixi/envs/openjdk/Library/lib/jvm');
  const javaPath            = os.platform() == "win32" ? javaPathWindows : javaPathUnix;

  // install retronvim.conda and firacode.conda
  if (fs.existsSync(initDotLuaPath) === false) {
    child_process.exec(pixiPath + 'global install retronvim -c retronvim -c conda-forge')
    child_process.exec(pixiPath + 'exec -c retronvim --with firacode-nerdfont-installer firacode-nerdfont-installer' + dotcmd)
  }

  // Access the configuration for 'vscode-neovim'
  const config = vscode.workspace.getConfiguration();

  // config.update("telemetry.telemetryLevel", "off", vscode.ConfigurationTarget.Global)
  // config.update('window.titleBarStyle', "custom", vscode.ConfigurationTarget.Global)
  config.update("antigravity.marketplaceGalleryItemURL", "https://marketplace.visualstudio.com/items", vscode.ConfigurationTarget.Global) // vscode marketplace for cursor
  config.update("antigravity.marketplaceExtensionGalleryServiceURL", "https://marketplace.visualstudio.com/_apis/public/gallery", vscode.ConfigurationTarget.Global) // vscode marketplace fo rcursor
  config.update("extensions.experimental.affinity", { "asvetliakov.vscode-neovim": 1, "vscodevim.vim": 2 }, vscode.ConfigurationTarget.Global);
  config.update("extensions.gallery.itemUrl", "https://marketplace.visualstudio.com/items", vscode.ConfigurationTarget.Global) // vscode marketplace for cursor
  config.update("extensions.gallery.serviceUrl", "https://marketplace.visualstudio.com/_apis/public/gallery", vscode.ConfigurationTarget.Global) // vscode marketplace fo rcursor
  config.update("git.path", gitPath, vscode.ConfigurationTarget.Global)
  config.update("java.configuration.runtimes", [{ "name": "JavaSE-25", "path": javaPath, "default": true }], vscode.ConfigurationTarget.Global);
  config.update("java.jdt.ls.java.home", javaPath, vscode.ConfigurationTarget.Global)
  config.update("python.defaultInterpreterPath", pythonPath, vscode.ConfigurationTarget.Global)
  config.update("security.workspace.trust.untrustedFiles", "open", vscode.ConfigurationTarget.Global)
  config.update("terminal.integrated.windowsUseConptyDll", true, vscode.ConfigurationTarget.Global) // for yazi image preview on windows but sometimes yazi refuses to open
  config.update("vscode-neovim.neovimExecutablePaths.darwin", nvimPath, vscode.ConfigurationTarget.Global)
  config.update("vscode-neovim.neovimExecutablePaths.linux", nvimPath, vscode.ConfigurationTarget.Global)
  config.update("vscode-neovim.neovimExecutablePaths.win32", nvimPath, vscode.ConfigurationTarget.Global)
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

  const home              = os.homedir();
  const colon             = os.platform() == "win32" ? ';' : ':'
  const yazi_choosen_file = path.join(home, '/.yazi')
  var binPath             = path.join(context.extensionPath, '/bin')
  binPath                += colon + home + '/.pixi/bin'
  binPath                += colon + home + '/.pixi/envs/retronvim/bin'
  binPath                += colon + process.env.PATH

  let open_yazi = vscode.commands.registerCommand("retronvim.yazi", async () => {

    let curr_file = vscode.window.activeTextEditor?.document.uri.fsPath || ""
    let yazi_args = curr_file ? ["--chooser-file", yazi_choosen_file, curr_file] : ["--chooser-file", yazi_choosen_file]

    fs.existsSync(yazi_choosen_file) && fs.rmSync(yazi_choosen_file)

    let yaziTerminal = vscode.window.createTerminal({
      name: "Yazi",
      shellPath: 'yazi',
      shellArgs: yazi_args,
      location: vscode.TerminalLocation.Editor,
      env: {
        PATH: binPath,
      },
    })

    await vscode.commands.executeCommand('workbench.action.terminal.focus');

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

  let open_lazygit = vscode.commands.registerCommand("retronvim.lazygit", async () => {

    vscode.window.createTerminal({
      name: "Lazygit",
      shellPath: 'lazygit',
      location: vscode.TerminalLocation.Editor,
      env: {
        PATH: binPath,
      },
    })

    await vscode.commands.executeCommand('workbench.action.terminal.focus');
  })

  let terminal_copymode = vscode.commands.registerCommand("retronvim.terminal_copymode", async () => {

    await vscode.commands.executeCommand("workbench.action.terminal.selectAll");
    await vscode.commands.executeCommand("editor.action.clipboardCopyAction");
    await vscode.commands.executeCommand('workbench.action.terminal.clearSelection');

    // read the clipboard from nvim
    let copymode_args = ["-c", "put +", "-c", "set ft=sh", "-c", "map q :qa!<cr>"];

    let terminal = vscode.window.createTerminal({
      shellPath: "nvim",
      shellArgs: copymode_args,
      // location: vscode.TerminalLocation.Editor,
      env: {
        PATH: binPath,
      },
    });

    terminal.show();

    // workaround to show maximized panel terminal requires `vscode.TerminalLocation.Editor` but more commands makes it slow,
    // alternative: the panel maximized is remembered
    // await vscode.commands.executeCommand("workbench.action.terminal.moveToTerminalPanel")
    // await vscode.commands.executeCommand("workbench.action.toggleMaximizedPanel");
  });

  let nvim_tab_terminal = vscode.commands.registerCommand("retronvim.nvim_tab_terminal", async () => {

    vscode.window.createTerminal({
      shellPath: "nvim",
      shellArgs: ["-cterm"],
      location: vscode.TerminalLocation.Editor,
      env: {
        PATH: binPath,
      },
    });

    await vscode.commands.executeCommand('workbench.action.terminal.focus');
  });

  let nvim_panel_terminal = vscode.commands.registerCommand("retronvim.nvim_panel_terminal", async () => {

    let terminal = vscode.window.createTerminal({
      shellPath: "nvim",
      shellArgs: ["-cterm"],
      env: {
        PATH: binPath,
      },
    });

    terminal.show();
  });

  const show_message = vscode.commands.registerCommand( "retronvim.show_message", (args) => {
      vscode.window.showInformationMessage(args.text);
    },
  );

  context.subscriptions.push(open_yazi, open_lazygit, terminal_copymode, nvim_tab_terminal, nvim_panel_terminal, show_message);
}

exports.activate = activate;
