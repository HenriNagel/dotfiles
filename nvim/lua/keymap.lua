-- Map j and k to gj and gk in normal and visual modes
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', opts)
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', opts)

-- Optionally remap other movement keys for visual lines
vim.keymap.set({ 'n', 'v' }, '0', 'g0', opts)  -- Beginning of visual line
vim.keymap.set({ 'n', 'v' }, '^', 'g^', opts)  -- First non-blank character of visual line

-- Run latest command
