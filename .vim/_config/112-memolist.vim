UsePlugin 'memolist.vim'

if has('win32') || has('win64')
    let g:memolist_path = "G:\\マイドライブ\\memolist"
else
    let g:memolist_path = "/mnt/g/マイドライブ/memolist"
endif
