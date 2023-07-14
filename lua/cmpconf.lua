-- Setup nvim-cmp.
local cmp = require 'cmp'

---@diagnostic disable-next-line: redundant-parameter
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close()
        }),

        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select
        }), {'i', 'c'}),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select
        }), {'i', 'c'}),
        ["<Tab>"] = cmp.mapping(function(fallback)
            -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({
                        behavior = cmp.SelectBehavior.Select
                    })
                end
                cmp.confirm()
            else
                fallback()
            end
        end, {"i", "s", "c"})

    },
    sources = cmp.config.sources({
        {
            name = 'nvim_lsp'
        }, -- { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        {
            name = 'ultisnips'
        } -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        {
            name = 'buffer'
        }
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        {
            name = 'buffer'
        }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        {
            name = 'path'
        }
    }, {
        {
            name = 'cmdline'
        }
    })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                     .protocol
                                                                     .make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['cssls'].setup {
    capabilities = capabilities
}

require'lspconfig'.jsonls.setup {
    capabilities = capabilities
}

local nvim_lsp = require('lspconfig')
local wk = require('which-key')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(desc, type, mapping, cmd, opt)
        wk.register({
            [mapping] = desc
        }, {
            buffer = bufnr
        })
        vim.api.nvim_buf_set_keymap(bufnr, type, mapping, cmd, opt)
    end

    require"lsp_signature".on_attach()

    -- Mappings.
    local opts = {
        noremap = true,
        silent = true
    }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('Declaration', 'n', '<leader>D',
                   '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('Definition', 'n', '<leader>d',
                   '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('Hover', 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('Implementation', 'n', '<leader>i',
                   '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('Hover Doc', 'n', '<C-q>', "<cmd>Lspsaga hover_doc<cr>", opts)
    buf_set_keymap('Add W Folder', 'n', '<leader>sa',
                   '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('Remove W Folder', 'n', '<leader>sr',
                   '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('List W Folders', 'n', '<leader>sl',
                   '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                   opts)
    buf_set_keymap('Type Def', 'n', '<leader>T',
                   '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('Rename', 'n', '<leader>rn', "<cmd>Lspsaga rename<cr>", opts)
    buf_set_keymap('Code Action', 'n', '<leader>a',
                   "<cmd>Lspsaga code_action<cr>", opts)
    buf_set_keymap('References', 'n', '<leader>r',
                   "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", opts)
    buf_set_keymap('Float', 'n', '<leader>e',
                   '<cmd>lua vim.diagnostic.open_float()<CR>', opts)

    buf_set_keymap('Diag Prev', 'n', '[d',
                   '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('Diag Next', 'n', ']d',
                   '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('Fix Prev', 'n', '[e',
                   '<cmd>lua vim.diagnostic.goto_prev()<CR><cmd>Lspsaga code_action<CR>', opts)
    buf_set_keymap('Fix Next', 'n', ']e',
                   '<cmd>lua vim.diagnostic.goto_next()<CR><cmd>Lspsaga code_action<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {'cssls', 'jsonls', 'tsserver'}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true)
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false
            }
        }
    }
}
