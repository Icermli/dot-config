-- Structure of the nvim config:
--
-- * lua/ contains nvim's vanilla configs, as well as packer setup
--
-- * plugin/ contains configs for plugins under packer's management
--   note that files under plugin/ are auto-loaded by nvim
--

require('options')
require('ai')
require('remaps')

-- To start, install packer from AUR: https://aur.archlinux.org/packages/nvim-packer-git
-- After that, let packer manage a copy of itself and the AUR package may be removed
require('packer-plugins')

-- Maintenance
-- * Keep plugins updated with packer :PackerSync
--   Tip: after editing config, it needs to be sourced first
--        e.g., use this ":w |so % |PackerSync"
-- * Keep treesitter parsers updated with :TSUpdate

-- ## Notes to self
--
-- ### Spelling
-- zg         add word to dictionary
-- [s ]s      go to previous/next spell error
-- <Ctrl-XS>  correct spelling error in insert mode
-- z=         correct spelling error in normal mode
--
-- ### Navigation
-- 1gt 2gt         go to tab 1,2...
--
-- ### LSP
-- See more info in :LspInfo
