local neogit = require('neogit')
neogit.setup {
    -- auto refresh can slow things down for large repos
    auto_refresh = false,
    console_timeout = 2000
}
