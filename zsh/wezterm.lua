local wezterm = require 'wezterm'
local act = wezterm.action
local home = os.getenv("HOME") or os.getenv("USERPROFILE")
local retronvim_path = wezterm.glob(home .. '/.vscode/extensions/yeferyv.retronvim*')[1]

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then default_prog = { "powershell", "-nologo", "-noexit", "-file", retronvim_path .. "/powershell/profile.ps1" } end
if wezterm.target_triple == 'x86_64-unknown-linux-gnu' then default_prog = { "zsh" } end

return {
  audible_bell = "Disabled",
  bold_brightens_ansi_colors = false, --> for i in {0..255}; do; printf "\033[${i};1m color${i}"; done
  default_prog = default_prog,
  front_end = (wezterm.target_triple ~= 'x86_64-pc-windows-msvc') and "WebGpu" or "OpenGL", --> webgpu's transparency doesn't work on Windows
  hide_tab_bar_if_only_one_tab = true,
  scrollback_lines = 10000,
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  warn_about_missing_glyphs = false,
  window_close_confirmation = "NeverPrompt",
  window_background_image = retronvim_path .. "/assets/retronvim.jpg", --> https://wezterm.org/config/lua/config/background.html
  window_background_image_hsb = { brightness = 0.04 },                 --> https://github.com/wezterm/wezterm/discussions/5876
  -- text_background_opacity = 0.9,
  -- window_background_opacity = 0.9,

  set_environment_variables = {
    PATH = retronvim_path .. "/bin/env/bin:" .. os.getenv("PATH"),
    PSMODULEPATH = retronvim_path .. "/powershell/modules",
    ZDOTDIR = retronvim_path .. "/zsh"
  },

  font_rules = {
    {
      intensity = "Bold", --> bright palet colors
      font = wezterm.font_with_fallback(
        { { family = "FiraCode Nerd Font" } }, { stretch = "Normal", weight = "Bold", foreground = "#ffffff" }
      )
    },
    {
      intensity = "Normal", --> ansi palet colors
      font = wezterm.font_with_fallback({ { family = "FiraCode Nerd Font", stretch = "Normal", weight = "Regular", scale = 1.00 } }),
    },
  },

  keys = {
    { key = "1",          mods = "ALT",        action = act { ActivateTab = 0 } },
    { key = "2",          mods = "ALT",        action = act { ActivateTab = 1 } },
    { key = "3",          mods = "ALT",        action = act { ActivateTab = 2 } },
    { key = "4",          mods = "ALT",        action = act { ActivateTab = 3 } },
    { key = "5",          mods = "ALT",        action = act { ActivateTab = 4 } },
    { key = "6",          mods = "ALT",        action = act { ActivateTab = 5 } },
    { key = "7",          mods = "ALT",        action = act { ActivateTab = 6 } },
    { key = "8",          mods = "ALT",        action = act { ActivateTab = 7 } },
    { key = "9",          mods = "ALT",        action = act { ActivateTab = 8 } },
    { key = "0",          mods = "ALT",        action = act { ActivateTab = -1 } },
    { key = '-',          mods = 'ALT',        action = wezterm.action_callback(function(_, pane) pane:move_to_new_tab() end) },
    { key = '=',          mods = 'ALT',        action = wezterm.action_callback(function(_, pane) pane:move_to_new_window() end) },
    { key = "a",          mods = "ALT",        action = act { ScrollByPage = 1 } },
    { key = "q",          mods = "ALT",        action = act { ScrollByPage = -1 } },
    { key = "d",          mods = "ALT",        action = act { ScrollByLine = 1 } },
    { key = "D",          mods = "ALT",        action = act { ScrollToPrompt = 1 } },
    { key = "e",          mods = "ALT",        action = act { ScrollByLine = -1 } },
    { key = "E",          mods = "ALT",        action = act { ScrollToPrompt = -1 } },
    { key = "t",          mods = "ALT",        action = "ScrollToTop" },
    { key = "g",          mods = "ALT",        action = "ScrollToBottom" },
    { key = "s",          mods = "ALT",        action = act.ActivateTabRelative(-1) },
    { key = "S",          mods = 'ALT',        action = act.MoveTabRelative(-1) },
    { key = "f",          mods = "ALT",        action = act.ActivateTabRelative(1) },
    { key = "F",          mods = 'ALT',        action = act.MoveTabRelative(1) },
    { key = "c",          mods = "ALT",        action = act { CopyTo = "Clipboard" } },
    { key = "v",          mods = "ALT",        action = act { PasteFrom = "Clipboard" } },
    { key = "h",          mods = "CTRL|ALT",   action = act { SplitVertical = { domain = "CurrentPaneDomain" } } },
    { key = "v",          mods = "CTRL|ALT",   action = act { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
    { key = "r",          mods = "CTRL|ALT",   action = act.RotatePanes("CounterClockwise") },
    { key = "R",          mods = "CTRL|ALT",   action = act.RotatePanes("Clockwise") },
    { key = "LeftArrow",  mods = "CTRL|SHIFT", action = act { AdjustPaneSize = { "Left", 1 } } },
    { key = "RightArrow", mods = "CTRL|SHIFT", action = act { AdjustPaneSize = { "Right", 1 } } },
    { key = "UpArrow",    mods = "CTRL|SHIFT", action = act { AdjustPaneSize = { "Up", 1 } } },
    { key = "DownArrow",  mods = "CTRL|SHIFT", action = act { AdjustPaneSize = { "Down", 1 } } },
    { key = "LeftArrow",  mods = "CTRL",       action = act { ActivatePaneDirection = "Left" } },
    { key = "RightArrow", mods = "CTRL",       action = act { ActivatePaneDirection = "Right" } },
    { key = "UpArrow",    mods = "CTRL",       action = act { ActivatePaneDirection = "Up" } },
    { key = "DownArrow",  mods = "CTRL",       action = act { ActivatePaneDirection = "Down" } },
    { key = "L",          mods = "CTRL",       action = 'DisableDefaultAssignment' },
    { key = "K",          mods = "CTRL",       action = 'DisableDefaultAssignment' },
    { key = "N",          mods = 'CTRL',       action = act.SpawnWindow },
    { key = "t",          mods = "CTRL",       action = act { SpawnTab = "CurrentPaneDomain" } },
    { key = "w",          mods = "CTRL",       action = act { CloseCurrentPane = { confirm = false } } },
    { key = ";",          mods = "CTRL",       action = act.ActivateLastTab },

    --> Copy Mode
    {
      key = " ",
      mods = "SHIFT",
      action = act.Multiple {
        act.CopyMode("ClearPattern"),
        act.CopyMode("Close"),
        act.ActivateCopyMode,
      }
    },

    --> Search Case Insensitive
    {
      key = "F",
      mods = "SHIFT|CTRL",
      action = act.Multiple {
        act.Search { CaseInSensitiveString = "" },
        act.SendKey { key = "u", mods = "CTRL" },
        act.CopyMode("ClearPattern"),
      },
    },
  },

  --> https://wezterm.org/copymode.html
  --> https://github.com/wezterm/wezterm/discussions/2329
  key_tables = {
    copy_mode = {
      { key = "h",          mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "j",          mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "k",          mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "l",          mods = "NONE", action = act.CopyMode("MoveRight") },
      { key = "LeftArrow",  mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "DownArrow",  mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "UpArrow",    mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
      { key = "w",          mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "W",          mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "e",          mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
      { key = "E",          mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
      { key = "b",          mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "B",          mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "0",          mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = "Enter",      mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
      { key = "$",          mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = "^",          mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "g",          mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
      { key = "G",          mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
      { key = "o",          mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
      { key = "O",          mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      { key = "h",          mods = "ALT",  action = act.CopyMode("MoveToViewportTop") },
      { key = "m",          mods = "ALT",  action = act.CopyMode("MoveToViewportMiddle") },
      { key = "l",          mods = "ALT",  action = act.CopyMode("MoveToViewportBottom") },
      { key = " ",          mods = "NONE", action = act.CopyMode { SetSelectionMode = "Cell" } },
      { key = "v",          mods = "NONE", action = act.CopyMode { SetSelectionMode = "Cell" } },
      { key = "V",          mods = "NONE", action = act.CopyMode { SetSelectionMode = "Line" } },
      { key = "v",          mods = "CTRL", action = act.CopyMode { SetSelectionMode = "Block" } },
      { key = 'f',          mods = 'NONE', action = act.CopyMode { JumpForward = { prev_char = false } }, },
      { key = 'F',          mods = 'NONE', action = act.CopyMode { JumpBackward = { prev_char = false } }, },
      { key = 't',          mods = 'NONE', action = act.CopyMode { JumpForward = { prev_char = true } }, },
      { key = 'T',          mods = 'NONE', action = act.CopyMode { JumpBackward = { prev_char = true } }, },
      { key = ',',          mods = 'NONE', action = act.CopyMode('JumpReverse') },
      { key = ';',          mods = 'NONE', action = act.CopyMode('JumpAgain') },
      { key = "PageUp",     mods = "NONE", action = act.CopyMode("PageUp") },
      { key = "PageDown",   mods = "NONE", action = act.CopyMode("PageDown") },
      { key = "u",          mods = "NONE", action = act.CopyMode("PageUp") },
      { key = "d",          mods = "NONE", action = act.CopyMode("PageDown") },
      { key = "Escape",     mods = "NONE", action = act.Multiple { act.SendKey { key = "u", mods = "CTRL" }, act.CopyMode("ClearPattern"), act.CopyMode("Close"), } },
      { key = "q",          mods = "NONE", action = act.Multiple { act.SendKey { key = "u", mods = "CTRL" }, act.CopyMode("ClearPattern"), act.CopyMode("Close"), } },
      { key = "i",          mods = "NONE", action = act.Multiple { act.SendKey { key = "u", mods = "CTRL" }, act.CopyMode("ClearPattern"), act.CopyMode("Close"), } },
      { key = "/",          mods = "NONE", action = act.Multiple { act.Search { CaseInSensitiveString = "" } } },
      { key = "N",          mods = "NONE", action = act.Multiple { act.CopyMode("PriorMatch"), act.CopyMode { SetSelectionMode = "Cell" } } },
      { key = "n",          mods = "NONE", action = act.Multiple { act.CopyMode("NextMatch"), act.CopyMode { SetSelectionMode = "Cell" } } },
      { key = "y",          mods = "NONE", action = act.Multiple { act { CopyTo = "ClipboardAndPrimarySelection" }, act.CopyMode("ClearPattern"), act { CopyMode = "Close" } } },
      {
        key = "H",
        mods = "NONE",
        action = act.Multiple {
          act.CopyMode("MoveLeft"),
          act.CopyMode("MoveLeft"),
          act.CopyMode("MoveLeft"),
          act.CopyMode("MoveLeft"),
          act.CopyMode("MoveLeft"),
          act.CopyMode("MoveLeft"),
          act.CopyMode("MoveLeft"),
          act.CopyMode("MoveLeft"),
          act.CopyMode("MoveLeft"),
          act.CopyMode("MoveLeft"),
        },
      },
      {
        key = "J",
        mods = "NONE",
        action = act.Multiple {
          act.CopyMode("MoveDown"),
          act.CopyMode("MoveDown"),
          act.CopyMode("MoveDown"),
          act.CopyMode("MoveDown"),
          act.CopyMode("MoveDown"),
          act.CopyMode("MoveDown"),
          act.CopyMode("MoveDown"),
          act.CopyMode("MoveDown"),
          act.CopyMode("MoveDown"),
          act.CopyMode("MoveDown"),
        },
      },
      {
        key = "K",
        mods = "NONE",
        action = act.Multiple {
          act.CopyMode("MoveUp"),
          act.CopyMode("MoveUp"),
          act.CopyMode("MoveUp"),
          act.CopyMode("MoveUp"),
          act.CopyMode("MoveUp"),
          act.CopyMode("MoveUp"),
          act.CopyMode("MoveUp"),
          act.CopyMode("MoveUp"),
          act.CopyMode("MoveUp"),
          act.CopyMode("MoveUp"),
        },
      },
      {
        key = "L",
        mods = "NONE",
        action = act.Multiple {
          act.CopyMode("MoveRight"),
          act.CopyMode("MoveRight"),
          act.CopyMode("MoveRight"),
          act.CopyMode("MoveRight"),
          act.CopyMode("MoveRight"),
          act.CopyMode("MoveRight"),
          act.CopyMode("MoveRight"),
          act.CopyMode("MoveRight"),
          act.CopyMode("MoveRight"),
          act.CopyMode("MoveRight"),
        },
      },
    },
    search_mode = {
      { key = "Enter",  mods = "NONE", action = act.Multiple { act.ActivateCopyMode, act.CopyMode { SetSelectionMode = "Cell" }, } },
      { key = "Escape", mods = "NONE", action = act.Multiple { act.SendKey { key = "u", mods = "CTRL" }, act.CopyMode("ClearPattern"), act.CopyMode("Close"), } },
      { key = "n",      mods = "CTRL", action = act.CopyMode("NextMatch") },
      { key = "p",      mods = "CTRL", action = act.CopyMode("PriorMatch") },
      { key = "r",      mods = "CTRL", action = act.CopyMode("CycleMatchType") },
      { key = "u",      mods = "CTRL", action = act.CopyMode("ClearPattern") },
    }
  },

  --> to view colors --> for i in $(seq 256); do echo $(lua <<<"print('\27[${i}mReadydone${i}')"); done
  colors = {
    foreground    = "#a0a0a0",
    background    = "#000000",
    cursor_bg     = "#ffffff",
    cursor_border = "#a0a0a0",
    cursor_fg     = "#000000",
    selection_bg  = "#5555cc",
    selection_fg  = "#ffffff",
    split         = "#444444",
    ansi          = { "#3c3c3c", "#990000", "#009900", "#999900", "#5555cc", "#8855ff", "#5FB3A1", "#a0a0a0" }, -- Intensity Normal font SHELL:{30,37}
    brights       = { "#6c6c6c", "#ff0000", "#00ff00", "#ffff00", "#1c1cff", "#8844bb", "#5DE4C7", "#ffffff" }, -- Intensity Bold   font SHELL:{90,97}
    tab_bar       = {
      background         = "#000000",
      active_tab         = { bg_color = "#1c1c1c", fg_color = "#888888", },
      inactive_tab       = { bg_color = "#000000", fg_color = "#2c2c2c", },
      inactive_tab_hover = { bg_color = "#111111", fg_color = "#909090", italic = true, },
      new_tab            = { bg_color = "#000000", fg_color = "#000000", },
      new_tab_hover      = { bg_color = "#888888", fg_color = "#ffffff", italic = true, }
    }
  }
}
