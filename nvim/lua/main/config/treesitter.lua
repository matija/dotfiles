local parsers = {
  "astro",
  "bash",
  "c",
  "dockerfile",
  "git_config",
  "html",
  "ini",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "query",
  "robots",
  "ruby",
  "tmux",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

local ok, treesitter = pcall(require, "nvim-treesitter")
if not ok or type(treesitter.install) ~= "function" then
  return
end

treesitter.setup {
  install_dir = vim.fn.stdpath("data") .. "/site",
}

treesitter.install(parsers)

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local max_filesize = 100 * 1024
    local ok_stat, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok_stat and stats and stats.size > max_filesize then
      return
    end

    pcall(vim.treesitter.start, args.buf)
  end,
})
