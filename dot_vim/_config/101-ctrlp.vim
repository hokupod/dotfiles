UsePlugin 'ctrlp.vim'
" 終了時にキャッシュを削除しない
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_use_caching = 1
let g:ctrlp_custom_ignore = {
            \ 'dir': 'node_modules$\|\.git$\|\.next$',
            \ 'file': 'DS_STORE'
            \ }
let g:ctrlp_show_hidden = 1
nnoremap <silent><Space>f :<C-U>CtrlPMRUFiles<CR><F5>
nnoremap <silent><Space>e :<C-U>CtrlPCurWD<CR><F5>

UsePlugin 'ctrlp-matchfuzzy'
let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}

UsePlugin 'ctrlp-extensions.vim'
let g:ctrlp_extensions = ['tag', 'quickfix', 'dir', 'line', 'mixed', 'cmdline', 'yankring', 'menu']
nnoremap <silent><Space>: :<C-U>CtrlPCmdline<CR><F5>
nnoremap <silent><Space>; :<C-U>CtrlPMenu<CR><F5>
nnoremap <silent><Space>u :<C-U>CtrlPMRUFiles<CR><F5>

UsePlugin 'ctrlp-ghq'
nnoremap <silent><Space>g :<C-U>CtrlPGhq<CR><F5>

UsePlugin 'ctrlp-history'
nnoremap <silent><Space>/ :<C-U>CtrlPSearchHistory<CR><F5>

UsePlugin 'ctrlp-mark'
nnoremap <silent><Space>m :<C-U>CtrlPMark<CR><F5>

UsePlugin 'junkfile.vim'
nnoremap <silent><Space>j :<C-U>exe "CtrlP" g:junkfile#directory<CR><F5>
