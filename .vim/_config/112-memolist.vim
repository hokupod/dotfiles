UsePlugin 'memolist.vim'

let g:memolist_fzf = 1
if has('win32') || has('win64')
    let g:memolist_path = "G:\\マイドライブ\\memolist"
else
    let g:memolist_path = "/mnt/g/マイドライブ/memolist"
endif

nnoremap <silent> <space>mm :MemoNew<CR>
nnoremap <silent> <space>ml :MemoList<CR>
nnoremap <silent> <space>mg :MemoGrep<CR>
