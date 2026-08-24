const vscode = require('vscode');
const path = require('path');
const os = require('os');
const fs = require('fs');

function setPaths(context) {
  const home = os.homedir();
  const dotexe = os.platform() == "win32" ? '.exe' : ''
  const initDotLuaPath = path.join(home, '/.pixi/envs/retrovim/opt/retrovim/nvim/init.lua');
  const gitPath = path.join(home, '/.pixi/bin/git' + dotexe);
  const nvimPath = path.join(home, '/.pixi/bin/nvim' + dotexe);
  const pythonPath = path.join('./.pixi/envs/default/bin/python' + dotexe);
  const javaPathUnix = path.join(home, '/.pixi/envs/openjdk/lib/jvm');
  const javaPathWindows = path.join(home, '/.pixi/envs/openjdk/Library/lib/jvm');
  const javaPath = os.platform() == "win32" ? javaPathWindows : javaPathUnix;

  // Access the configuration for 'vscode-neovim'
  const config = vscode.workspace.getConfiguration();

  // config.update("telemetry.telemetryLevel", "off", vscode.ConfigurationTarget.Global)
  // config.update('window.titleBarStyle', "custom", vscode.ConfigurationTarget.Global)
  // config.update("security.workspace.trust.untrustedFiles", "open", vscode.ConfigurationTarget.Global) // open-ovsx.org gets stuck with `under review`

  config.update("antigravity.marketplaceGalleryItemURL", "https://marketplace.visualstudio.com/items", vscode.ConfigurationTarget.Global) // vscode marketplace for cursor
  config.update("antigravity.marketplaceExtensionGalleryServiceURL", "https://marketplace.visualstudio.com/_apis/public/gallery", vscode.ConfigurationTarget.Global) // vscode marketplace for cursor
  config.update("extensions.gallery.itemUrl", "https://marketplace.visualstudio.com/items", vscode.ConfigurationTarget.Global) // vscode marketplace for cursor
  config.update("extensions.gallery.serviceUrl", "https://marketplace.visualstudio.com/_apis/public/gallery", vscode.ConfigurationTarget.Global) // vscode marketplace for cursor
  config.update("windsurf.marketplaceExtensionGalleryServiceURL", "https://marketplace.visualstudio.com/_apis/public/gallery", vscode.ConfigurationTarget.Global)
  config.update("windsurf.marketplaceGalleryItemURL", "https://marketplace.visualstudio.com/items", vscode.ConfigurationTarget.Global)

  config.update("extensions.experimental.affinity", { "asvetliakov.vscode-neovim": 1, "vscodevim.vim": 2 }, vscode.ConfigurationTarget.Global);
  config.update("git.path", gitPath, vscode.ConfigurationTarget.Global)
  config.update("java.configuration.runtimes", [{ "name": "JavaSE-25", "path": javaPath, "default": true }], vscode.ConfigurationTarget.Global);
  config.update("java.jdt.ls.java.home", javaPath, vscode.ConfigurationTarget.Global)
  config.update("python.defaultInterpreterPath", pythonPath, vscode.ConfigurationTarget.Global)
  config.update("terminal.integrated.windowsUseConptyDll", true, vscode.ConfigurationTarget.Global) // for yazi image preview on windows but sometimes yazi refuses to open
  config.update("vscode-neovim.neovimExecutablePaths.darwin", nvimPath, vscode.ConfigurationTarget.Global)
  config.update("vscode-neovim.neovimExecutablePaths.linux", nvimPath, vscode.ConfigurationTarget.Global)
  config.update("vscode-neovim.neovimExecutablePaths.win32", nvimPath, vscode.ConfigurationTarget.Global)
  config.update("vscode-neovim.neovimInitVimPaths.darwin", initDotLuaPath, vscode.ConfigurationTarget.Global)
  config.update("vscode-neovim.neovimInitVimPaths.linux", initDotLuaPath, vscode.ConfigurationTarget.Global)
  config.update("vscode-neovim.neovimInitVimPaths.win32", initDotLuaPath, vscode.ConfigurationTarget.Global)
  config.update("window.customMenuBarAltFocus", false, vscode.ConfigurationTarget.Global) // Windows's alt sometimes conflicts with whichkey
}

// You can call this function in your extension's activate function or based on certain events
function activate(context) {
  // https://stackoverflow.com/questions/44113025/how-to-dynamically-query-my-vscode-extension-version-from-the-extension-code
  // vscode.window.showInformationMessage(context.extension.packageJSON.version);
  setPaths(context);

  // https://stackoverflow.com/questions/39569993/vs-code-extension-get-full-path
  // vscode.window.showInformationMessage(context.extensionUri);
  // vscode.window.showInformationMessage(context.extensionPath);
  // vscode.window.showInformationMessage(context.extension);

  const colon = os.platform() == "win32" ? ';' : ':'
  const home = os.homedir();
  const yazi_choosen_file = path.join(home, '/.yazi')
  var binPath = home + '/.pixi/bin'
  binPath += colon + home + '/.pixi/envs/retrovim/bin'
  binPath += colon + process.env.PATH

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

  const show_message = vscode.commands.registerCommand("retronvim.show_message", (args) => {
    vscode.window.showInformationMessage(args.text);
  });

  const cat = vscode.commands.registerCommand('retronvim.cat', () => {
    // Create and show a new webview
    const panel = vscode.window.createWebviewPanel(
      'catCoding', // Identifies the type of the webview. Used internally
      'Cat Coding', // Title of the panel displayed to the user
      vscode.ViewColumn.One, // Editor column to show the new webview panel in.
      { enableScripts: true }
    );

    // And set its HTML content
    panel.webview.html = getWebviewContent();

    panel.webview.onDidReceiveMessage(
      message => {
        switch (message.command) {
          case 'alert':
            vscode.window.showErrorMessage(message.text);
            return;
          case 'listDirectory':
            let workspaceFolder = vscode.workspace.workspaceFolders?.[0].uri.fsPath || os.homedir();
            let ls = fs.readdirSync(workspaceFolder)
            panel.webview.postMessage({ command: 'listDirectory', text: ls.join('\n') });
            return;
        }
      },
      undefined,
      context.subscriptions
    )
  })

  context.subscriptions.push(
    open_yazi,
    open_lazygit,
    terminal_copymode,
    nvim_tab_terminal,
    nvim_panel_terminal,
    show_message,
    cat
  );

}

function getWebviewContent() {
  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cat Coding</title>
</head>
<body>
  <img src="https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif" width="300" />
  <h1 id="files">0</h1>

  <script>
    const vscode = acquireVsCodeApi();
    vscode.postMessage({ command: 'alert', text: 'Hello from the webview' });
    vscode.postMessage({ command: 'listDirectory' })

    const files = document.getElementById('files');

    window.addEventListener('message', event => {

      const message = event.data; // The JSON data our extension sent

      switch (message.command) {
        case 'listDirectory':
          files.textContent = message.text;
          break;
      }
    });

  </script>
</body>
</html>`;
}

exports.activate = activate;
