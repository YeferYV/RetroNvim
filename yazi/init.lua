require("bookmarks"):setup()
require("session"):setup { sync_yanked = true }
require("smart-enter"):setup { open_multi = true }

Status:children_add(function(self)
  local h = self._current.hovered
  if h and h.link_to then
    return " -> " .. tostring(h.link_to)
  else
    return ""
  end
end, 3300, Status.LEFT)
