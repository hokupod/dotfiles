UsePlugin 'ctrlp.vim'
" 終了時にキャッシュを削除しない
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_use_caching = 1
UsePlugin 'ctrlp-matchfuzzy.vim'
let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}

UsePlugin 'ctrlp-extensions.vim'
let g:ctrlp_extensions = ['tag', 'quickfix', 'dir', 'line', 'mixed', 'cmdline', 'yankring', 'menu']
