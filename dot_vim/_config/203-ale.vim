UsePlugin 'ale'

let g:ale_fix_on_save = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_change = 0

let g:ale_set_quickfix = 1
let g:ale_set_loclist = 1
let g:ale_open_list = 0
let g:alg_keep_list_window_open = 0
let g:ale_list_window_size = 10

let g:ale_sign_column_always = 1
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_javascript_eslint_options = '--cache'
let g:ale_fixers = {
    \   'typescript': ['eslint', 'dprint'],
    \   'typescriptreact': ['eslint', 'dprint'],
    \ }
