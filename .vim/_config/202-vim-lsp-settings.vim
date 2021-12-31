UsePlugin 'vim-lsp-settings'
let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_diagnostics_float_cursor = 0
let g:lsp_diagnostics_enabled = 1
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1
let g:lsp_virtual_text_enabled = 0

let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼'}
nmap <silent> gd :LspDefinition<CR>
nmap <silent> <f2> :LspRename<CR>
nmap <silent> <Leader>d :LspTypeDefinition<CR>
nmap <silent> <Leader>r :LspReferences<CR>
nmap <silent> <Leader>i :LspImplementation<CR>
nmap <silent> <Leader>h :LspHover<CR>
