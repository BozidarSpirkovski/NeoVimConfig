local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope find git files' })
vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Telescope: live grep" })

vim.keymap.set("n", "<leader>pp", function()
  builtin.find_files({ cwd = vim.fn.expand("%:p:h") })  -- directory of the current file
end, { desc = "Telescope: find files in file's directory" })
