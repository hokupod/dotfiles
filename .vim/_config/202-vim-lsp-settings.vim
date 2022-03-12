UsePlugin 'vim-lsp-settings'
let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_diagnostics_float_cursor = 0
let g:lsp_diagnostics_enabled = 1
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1
let g:lsp_virtual_text_enabled = 0
let g:lsp_settings_filetype_ruby = ['solargraph', 'steep']

let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼'}

nmap <buffer> gd <plug>(lsp-definition)
nmap <buffer> gs <plug>(lsp-document-symbol-search)
nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
nmap <buffer> gr <plug>(lsp-references)
nmap <buffer> gi <plug>(lsp-implementation)
nmap <buffer> gt <plug>(lsp-type-definition)
nmap <buffer> <f2> <plug>(lsp-rename)
nmap <buffer> [g <plug>(lsp-previous-diagnostic)
nmap <buffer> ]g <plug>(lsp-next-diagnostic)
nmap <buffer> K <plug>(lsp-hover)
nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
