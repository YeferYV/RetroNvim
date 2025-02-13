require("session"):setup { sync_yanked = true }
require("bookmarks"):setup()
require("yazi-rs.plugins/git"):setup()
require("yazi-rs.plugins/mime-ext"):setup { fallback_file1 = true, }

Status:children_add(function(self)
  local h = self._current.hovered
  if h and h.link_to then
    return " -> " .. tostring(h.link_to)
  else
    return ""
  end
end, 3300, Status.LEFT)
