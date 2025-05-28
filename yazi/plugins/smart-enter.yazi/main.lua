--- @sync entry

-- https://github.com/yazi-rs/plugins/tree/main/smart-enter.yazi
local function setup(self, opts) self.open_multi = opts.open_multi end

local function entry(self)
  local h = cx.active.current.hovered
  ya.emit(h and h.cha.is_dir and "enter" or "open", { hovered = not self.open_multi })
end

return { entry = entry, setup = setup }
