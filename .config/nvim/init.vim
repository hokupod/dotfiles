augroup MyAutoCmd
  autocmd!
augroup END

" dein settings {{{
if &compatible
  set nocompatible
endif
" dein.vim
let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let s:dein_cache_dir = g:cache_home . '/dein'
" let s:dein_cache_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'

" なければgit clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_cache_dir)
  call dein#begin(s:dein_cache_dir)

  " Required:
  let s:toml_dir = g:config_home . '/dein'

  call dein#load_toml(s:toml_dir . '/plugins.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/lazy.toml', {'lazy': 1})
  if has('nvim')
    call dein#load_toml(s:toml_dir . '/neovim.toml', {'lazy': 1})
    set termguicolors
  endif

  call dein#end()
  call dein#save_state()
endif
if dein#check_install()
  call dein#install()
endif
" }}}

" " Required:
filetype plugin indent on
syntax enable
"End dein Scripts-------------------------
"
set termguicolors
" マウスを有効にする
if has('mouse')
  set mouse=a
endif
" Insertモードのときカーソルの形状を変更
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" 一旦ファイルタイプ関連を無効化する
filetype off
""""""""""""""""""""""""""""""
" 各種オプションの設定
""""""""""""""""""""""""""""""
" 文字コード自動判定
" set encoding=utf-8
" set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
" set fileformats=unix,dos,mac
" カレント行のハイライト
set cursorline
hi clear CursorLine
" タグファイルの指定(でもタグジャンプは使ったことがない)
" set tags=~/.tags
" スワップファイルは使わない(ときどき面倒な警告が出るだけで役に立ったことがない)
set noswf
" カーソルが何行目の何列目に置かれているかを表示する
set ruler
" コマンドラインに使われる画面上の行数
set cmdheight=2
" エディタウィンドウの末尾から2行目にステータスラインを常時表示させる
set laststatus=2
" ステータス行に表示させる情報の指定(どこからかコピペしたので細かい意味はわかっていない)
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" ステータス行に現在のgitブランチを表示する
set statusline+=%{fugitive#statusline()}
" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title
" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu
" 入力中のコマンドを表示する
set showcmd
" バッファで開いているファイルのディレクトリでエクスクローラを開始する(でもエクスプローラって使ってない)
set browsedir=buffer
" 小文字のみで検索したときに大文字小文字を無視する
set smartcase
" 検索結果をハイライト表示する
set hlsearch
" 暗い背景色に合わせた配色にする
"set background=dark
" タブ入力を複数の空白入力に置き換える
set expandtab
" 検索ワードの最初の文字を入力した時点で検索を開始する
set incsearch
" 保存されていないファイルがあるときでも別のファイルを開けるようにする
set hidden
" 不可視文字を表示する
set list
" タブと行の続きを可視化する
set listchars=tab:>\ ,extends:<
" " 行番号を表示する
" set number
" 対応する括弧やブレースを表示する
set showmatch
" 改行時に前の行のインデントを継続する
set autoindent
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" タブ文字の表示幅
set tabstop=4
" set tabstop=2
" Vimが挿入するインデントの幅
set shiftwidth=4
" set shiftwidth=2
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" バックスペースで文字を消せるようにする
set backspace=indent,eol,start
" バックアップ
set backupdir=$HOME/.vim_backup
set directory=$HOME/.vim_backup
set backup
set writebackup
set undodir=$HOME/.vim_undo
set undofile
au BufWritePre * let &bex = '.' . strftime("%Y%m%d_%H%M%S")
" 無名レジスタに入るデータを、*レジスタにも入れる。
set clipboard+=unnamedplus

" シェルをZSHに
set sh=zsh

let g:python3_host_prog='/usr/local/bin/python3'
" 構文毎に文字色を変化させる
"syntax on
" 行番号の色
highlight LineNr ctermfg=darkyellow
""""""""""""""""""""""""""""""
" grep検索の実行後にQuickFix Listを表示する
autocmd QuickFixCmdPost *grep* cwindow
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
    let g:ackprg='rg --vimgrep --no-heading'
endif

" http://blog.remora.cx/2010/12/vim-ref-with-unite.html
" 全角スペースの表示
""""""""""""""""""""""""""""""
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme * call ZenkakuSpace()
    autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
  augroup END
  call ZenkakuSpace()
endif
""""""""""""""""""""""""""""""
" 挿入モード時、ステータスラインの色を変更
""""""""""""""""""""""""""""""
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'
if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction
""""""""""""""""""""""""""""""
" 最後のカーソル位置を復元する
""""""""""""""""""""""""""""""
if has("autocmd")
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \ exe "normal! g'\"" |
        \ endif
endif

""""""""""""""""""""""""""""""
" ノーマルモードでは「英数」に切り替える
""""""""""""""""""""""""""""""
if executable('osascript')
  let s:keycode_jis_eisuu = 102
  let g:force_alphanumeric_input_command = "osascript -e 'tell application \"System Events\" to key code " . s:keycode_jis_eisuu . "' &"

  inoremap <silent> <Esc> <Esc>:call system(g:force_alphanumeric_input_command)<CR>

  autocmd! FocusGained *
    \ call system(g:force_alphanumeric_input_command)
endif

""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" ペーストモード切替
""""""""""""""""""""""""""""""
"set pastetoggle=<C-Y>
""""""""""""""""""""""""""""""
" inoremap { {}<LEFT>
" inoremap [ []<LEFT>
" inoremap ( ()<LEFT>
" inoremap " ""<LEFT>
" inoremap ' ''<LEFT>

""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" インサートモード時の移動
""""""""""""""""""""""""""""""
inoremap <c-e><c-h> <left>
inoremap <c-e><c-l> <right>
inoremap <c-e><c-k> <up>
inoremap <c-e><c-j> <down>
inoremap <c-e><c-w> <S-right>
inoremap <c-e><c-b> <S-left>
inoremap <c-e>O <esc>O
inoremap <c-e>o <esc>o
inoremap <c-e><c-e> <esc>A
inoremap <c-e><c-a> <esc>I
" insert mode でjjでesc
inoremap jj <Esc>

" コンマの後に自動的にスペースを挿入
inoremap , ,<Space>

" インサートモード時のCtrl-cをESCと同じ挙動にする
inoremap <C-c> <ESC>

" コマンド履歴便利キーマップ
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" 0番レジスタを使いやすくした
" via http://qiita.com/items/bd97a9b963dae40b63f5
vnoremap <silent> <C-p> "0p
" x ではレジスタ書き込みさせない
nnoremap x "_x
nnoremap X "_x
vnoremap x "_x
vnoremap X "_x
"" visual モードでの貼り付けの場合は、ヤンクしたくない
"vnoremap p "0p

"" ノーマルモードでも改行挿入
"noremap <CR> o<ESC>
"noremap <S-CR> O<ESC>
" 検索は常に very magic
nnoremap /  /\v
" " tagsジャンプの時に複数ある時は一覧表示
" nnoremap <C-]> g<C-]>
" 行番号の相対表示
nnoremap <F3> :<C-u>setlocal number! \| :setlocal relativenumber!<CR>

" ESC*2 でハイライトやめる
let hlstate=0
nnoremap <Esc><Esc> :if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<cr>

tnoremap <silent> <ESC> <C-\><C-n>
tnoremap <silent> jj <C-\><C-n>

" 保存時に行末の空白を除去する
function! s:remove_dust()
    let cursor = getpos(".")
    " 保存時に行末の空白を除去する
    %s/\s\+$//ge
    "" 保存時にtabを2スペースに変換する
    "%s/\t/  /ge
    call setpos(".", cursor)
    unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()
" autocmd BufWritePost *.rb Dispatch! ripper-tags -R

" 2バイトの記号対策
set ambiwidth=double
" filetypeの自動検出(最後の方に書いた方がいいらしい)
filetype on
