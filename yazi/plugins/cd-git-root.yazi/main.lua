-- https://github.com/stexus/cd-repo-root.yazi

local function get_repo_toplevel()
  local path = fs.cwd()

  while path do
    local _, err = fs.cha(path:join(".git"), true) -- if .git exists

    if not err then
      return path
    end

    path = path.parent
  end
end

return {
  entry = function()
    local destination = get_repo_toplevel()
    if destination then
      ya.emit("cd", { destination })
    else
      ya.notify({
        title = "Could not change directory!",
        content = "You are not in a git or sapling repository.",
        timeout = 3,
        level = "error",
      })
    end
  end,
}
