-- https://github.com/dedukun/bookmarks.yazi

local SUPPORTED_KEYS = {
  { on = "0" }, { on = "1" }, { on = "2" }, { on = "3" }, { on = "4" },
  { on = "5" }, { on = "6" }, { on = "7" }, { on = "8" }, { on = "9" },
  { on = "A" }, { on = "B" }, { on = "C" }, { on = "D" }, { on = "E" },
  { on = "F" }, { on = "G" }, { on = "H" }, { on = "I" }, { on = "J" },
  { on = "K" }, { on = "L" }, { on = "M" }, { on = "N" }, { on = "O" },
  { on = "P" }, { on = "Q" }, { on = "R" }, { on = "S" }, { on = "T" },
  { on = "U" }, { on = "V" }, { on = "W" }, { on = "X" }, { on = "Y" }, { on = "Z" },
  { on = "a" }, { on = "b" }, { on = "c" }, { on = "d" }, { on = "e" },
  { on = "f" }, { on = "g" }, { on = "h" }, { on = "i" }, { on = "j" },
  { on = "k" }, { on = "l" }, { on = "m" }, { on = "n" }, { on = "o" },
  { on = "p" }, { on = "q" }, { on = "r" }, { on = "s" }, { on = "t" },
  { on = "u" }, { on = "v" }, { on = "w" }, { on = "x" }, { on = "y" }, { on = "z" },
}

local _save_state = ya.sync(function(state, bookmarks)
  ps.pub_to(0, "@bookmarks", bookmarks)
end)

local _load_state = ya.sync(function(state)
  ps.sub_remote("@bookmarks", function(body)
    if not state.bookmarks and body then
      state.bookmarks = {}
      for _, value in pairs(body) do
        table.insert(state.bookmarks, value)
      end
    end
  end)
end)

local save_bookmark = ya.sync(function(state, idx)
  local folder = cx.active.current.hovered.url

  state.bookmarks = state.bookmarks or {}
  state.bookmarks[#state.bookmarks + 1] = {
    on = SUPPORTED_KEYS[idx].on,
    desc = tostring(folder),
  }

  _save_state(state.bookmarks)
end)

local all_bookmarks = ya.sync(function(state)
  return state.bookmarks or {}
end)

local delete_bookmark = ya.sync(function(state, idx)
  table.remove(state.bookmarks, idx)
  _save_state(state.bookmarks)
end)

return {
  entry = function(_, job)
    local action = job.args[1]
    if not action then
      return
    end

    if action == "save" then
      local key = ya.which({ cands = SUPPORTED_KEYS, silent = true })
      if key then
        save_bookmark(key)
      end
      return
    end

    local bookmarks = all_bookmarks()
    local selected = #bookmarks > 0 and ya.which({ cands = bookmarks })
    if not selected then
      return
    end

    if action == "jump" then
      ya.emit("reveal", { bookmarks[selected].desc })
    end

    if action == "delete" then
      delete_bookmark(selected)
    end
  end,
  setup = function(state, args)
    _load_state()
  end
}
