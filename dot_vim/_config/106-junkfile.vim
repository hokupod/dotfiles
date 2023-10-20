UsePlugin 'junkfile.vim'

if has('win32') || has('win64')
    let g:junkfile#directory = "G:\\マイドライブ\\junkfile"
else
    let g:junkfile#directory = '/mnt/g/マイドライブ/junkfile'
endif
" Open junk file."{{{
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
  let l:junk_dir = g:junkfile#directory . strftime('/%Y/%m')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
  if l:filename != ''
    execute 'edit ' . l:filename
  endif
endfunction"}}}
