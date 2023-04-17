require("astronvim.utils.updater").update = function()
  local repo = "https://github.com/AstroNvim/AstroNvim.git"
  local tag = string.match(
    vim.fn.system({ "git", "-c", "versionsort.suffix=-", "ls-remote", "--tags", "--sort=v:refname", repo }),
    "refs/tags/(v%d+.%d+.%d+)\r?\n$"
  )
  local HOME = vim.env.HOME
  print(vim.fn.system({
    "git", "--git-dir", HOME .. "/.dotgit/", "--work-tree", HOME,
    "subtree", "--prefix", ".config/nvim",
    "pull", "--squash", repo, tag,
  }))
end
