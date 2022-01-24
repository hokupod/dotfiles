UsePlugin 'asyncomplete.vim'
"let g:asyncomplete_auto_popup = 0

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" enable preview window
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview

UsePlugin 'asyncomplete-look'
au User asyncomplete_setup call asyncomplete#register_source({
    \ 'name': 'look',
    \ 'allowlist': ['text', 'markdown'],
    \ 'completor': function('asyncomplete#sources#look#completor'),
    \ })
