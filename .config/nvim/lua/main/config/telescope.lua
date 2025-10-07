local actions = require "telescope.actions"

require('telescope').setup {
  defaults = {
    find_command = { "fd", "-t=f", "-a" },
    path_display = { "absolute" },
    wrap_results = true,
    file_ignore_patterns = { ".git/", ".cache", "%.o", "%.a", "%.out", "%.class",
      "%.pdf", "%.mkv", "%.mp4", "%.zip" },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      }
    }
  },
  pickers = {
    find_files = {
      -- theme = "ivy",
      theme = "dropdown",
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  }
}
