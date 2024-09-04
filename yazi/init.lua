require("session"):setup { sync_yanked = true }

function Status:name()
  local h = cx.active.current.hovered
  if not h then
    return ui.Span("")
  end

  -- return ui.Span(" " .. h.name)
  local linked = ""
  if h.link_to ~= nil then
    linked = " -> " .. tostring(h.link_to)
  end
  return ui.Span(" " .. h.name .. linked)
end

require("bookmarks"):setup({
  last_directory = { enable = true, persist = true },
  persist = "all",
  desc_format = "parent",
  notify = {
    enable = true,
    message = {
      new = "New bookmark '<key>' -> '<folder>'",
      delete = "Deleted bookmark in '<key>'",
    },
  },
})
