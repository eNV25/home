require("astronvim.utils.updater").update = function()
  local repo = "https://github.com/AstroNvim/AstroNvim.git"
  local tag = string.match(
    vim.fn.system({ "git", "-c", "versionsort.suffix=-", "ls-remote", "--tags", "--sort=version:refname", repo }),
    "refs/tags/(v%d+.%d+.%d+)\r?\n$"
  )
  print(vim.fn.system({
    "flock", "--", vim.env.XDG_RUNTIME_DIR .. "/astronvim-subtree-update.lock", "sh", "-xc",
    table.concat({
      [[export GIT_DIR="$HOME/.dotgit"]],
      [[export GIT_WORK_TREE="$HOME"]],
      [[cd "$GIT_WORK_TREE"]],
      [[git stash push]],
      [[git subtree --prefix .config/nvim pull --squash ]] .. repo .. " " .. tag,
      [[git stash pop]]
    }, "\n")
  }))
end
