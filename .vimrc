" 挙動を vi 互換ではなく、Vim のデフォルト設定にする
set nocompatible
if !has('nvim')
  " 無名レジスタに入るデータを、*レジスタにも入れる。
  set clipboard&
  set clipboard^=unnamedplus
  " マウスを有効にする
  if has('mouse')
    set mouse=a
    if has('mouse_sgr')
      set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632') " I couldn't use has('mouse_sgr') :-(
      set ttymouse=sgr
    else
      set ttymouse=xterm2
    endif
  endif
endif
" Insertモードのときカーソルの形状を変更
if has('vim_starting')
  " 挿入モード時に非点滅の縦棒タイプのカーソル
  let &t_SI .= "\e[6 q"
  " ノーマルモード時に非点滅のブロックタイプのカーソル
  let &t_EI .= "\e[2 q"
  " 置換モード時に非点滅の下線タイプのカーソル
  let &t_SR .= "\e[4 q"
endif
" 一旦ファイルタイプ関連を無効化する
filetype off
""""""""""""""""""""""""""""""
" プラグインのセットアップ
""""""""""""""""""""""""""""""
let g:plug_shallow = 0

call plug#begin('~/.vim/plugged')

if has('nvim')
  Plug 'monaqa/modesearch.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
    Plug 'yioneko/nvim-yati'
  Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
else
  " LSP
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'htlsne/asyncomplete-look'
  Plug 'liuchengxu/vista.vim'
  " Snippet
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'rafamadriz/friendly-snippets'
  Plug 'mattn/vim-sonictemplate'
endif
Plug 'thinca/vim-quickrun'
Plug 'thinca/vim-qfreplace', { 'for': ['qf'] }
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'lambdalisue/gina.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'cohama/lexima.vim'
Plug 'markonm/traces.vim'
" denops
Plug 'vim-denops/denops.vim'
Plug 'vim-denops/denops-helloworld.vim'
Plug 'lambdalisue/guise.vim'
" Memo
Plug 'Shougo/junkfile.vim'
" ColorScheme
Plug 'joshdick/onedark.vim'
" Filer
Plug 'mattn/vim-findroot'
Plug 'mattn/vim-molder'
Plug 'mattn/vim-molder-operations'
" Search
Plug 'ctrlpvim/ctrlp.vim'
Plug 'sgur/ctrlp-extensions.vim'
Plug 'ompugao/ctrlp-history'
Plug 'mattn/ctrlp-matchfuzzy'
Plug 'mattn/ctrlp-ghq'
Plug 'haya14busa/vim-asterisk'
Plug 'jremmen/vim-ripgrep'
Plug 'tacahiroy/ctrlp-funky'
" Move
Plug 'easymotion/vim-easymotion'
" Syntax check
"Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
" Syntax
Plug 'sheerun/vim-polyglot'
" HTML
Plug 'mattn/emmet-vim'
" Go
Plug 'mattn/vim-goimports', { 'for': ['go'] }
Plug 'sebdah/vim-delve', { 'for': ['go'] }
" JS/TS
Plug 'pangloss/vim-javascript', { 'for': ['javascript','javascriptreact','typescript','typescriptreact'] }
Plug 'leafgarland/typescript-vim', { 'for': ['javascript','javascriptreact','typescript','typescriptreact'] }
Plug 'peitalin/vim-jsx-typescript', { 'for': ['javascript','javascriptreact','typescript','typescriptreact'] }
Plug 'styled-components/vim-styled-components', { 'for': ['javascript','javascriptreact','typescript','typescriptreact'] }
call plug#end()

let s:plugs = get(s:, 'plugs', get(g:, 'plugs', {}))
function! FindPlugin(name) abort
  return has_key(s:plugs, a:name) ? isdirectory(s:plugs[a:name].dir) : 0
endfunction
command! -nargs=1 UsePlugin if !FindPlugin(<args>) | finish | endif

runtime! _config/*.vim
""""""""""""""""""""""""""""""
" 各種オプションの設定
""""""""""""""""""""""""""""""
setglobal cmdheight=2
setglobal laststatus=2
setglobal fileformat=unix
setglobal formatoptions+=mb

if has('win32') || has('win64')
  " バックアップ
  set backupdir="G:\\マイドライブ\\vim_backup"
  set directory="G:\\マイドライブ\\vim_backup"
else
  setglobal shell=/bin/bash
  " バックアップ
  set backupdir=$HOME/.vim_backup
  set directory=$HOME/.vim_backup
  " WSL
  if system('uname -a | grep -i microsoft') != ''
    let win32yankIn="$WINHOME/win32yank.exe -i"
    let win32yankOut="$WINHOME/win32yank.exe -o --lf"
    augroup myYank
      autocmd!
      autocmd TextYankPost * :call system(win32yankIn, @")
    augroup END
    nnoremap <silent> p :call setreg('"',system(win32yankOut))<CR>""p
    " バックアップ
    set backupdir=/mnt/g/マイドライブ/vim_backup
    set directory=/mnt/g/マイドライブ/vim_backup
  endif
endif


if exists('&termguicolors')
  setglobal termguicolors
endif

if !has('gui_running')
  set t_Co=256
endif

if exists('&completeslash')
  setglobal completeslash=slash
endif

let g:no_gvimrc_example=1
let g:no_vimrc_example=1

let g:loaded_gzip               = 1
let g:loaded_tar                = 1
let g:loaded_tarPlugin          = 1
let g:loaded_zip                = 1
let g:loaded_zipPlugin          = 1
let g:loaded_rrhelper           = 1
let g:loaded_vimball            = 1
let g:loaded_vimballPlugin      = 1
let g:loaded_getscript          = 1
let g:loaded_getscriptPlugin    = 1
let g:loaded_netrw              = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_netrwSettings      = 1
let g:loaded_netrwFileHandlers  = 1
let g:did_install_default_menus = 1
let g:skip_loading_mswin        = 1
let g:did_install_syntax_menu   = 1
"let g:loaded_2html_plugin       = 1

let g:mapleader = '\'
let g:maplocalleader = ','

" git commit 時にはプラグインは読み込まない
if $HOME != $USERPROFILE && $GIT_EXEC_PATH != ''
  finish
end
" 文字コード自動判定
" set encoding=utf-8
" set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
" set fileformats=unix,dos,mac
" カレント行のハイライト
set cursorline
hi clear CursorLine
" カレント列のハイライト
"set cursorcolumn
" タグファイルの指定
" set tags=~/.tags
" スワップファイル
set noswapfile
" カーソルが何行目の何列目に置かれているかを表示する
set ruler
" コマンドラインに使われる画面上の行数
set cmdheight=2
" エディタウィンドウの末尾から2行目にステータスラインを常時表示させる
set laststatus=2
" ステータス行に表示させる情報の指定
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" ステータス行に現在のgitブランチを表示する
" "set statusline+=%{fugitive#statusline()}
" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title
" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu
" 入力中のコマンドを表示する
set showcmd
" バッファで開いているファイルのディレクトリでエクスクローラを開始する
set browsedir=buffer
" 小文字のみで検索したときに大文字小文字を無視する
set smartcase
" 検索結果をハイライト表示する
set hlsearch
" 暗い背景色に合わせた配色にする
set background=dark
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
" 行番号を表示する
set number
" 対応する括弧やブレースを表示する
set showmatch
" 改行時に前の行のインデントを継続する
set autoindent
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" タブ文字の表示幅
set tabstop=2
" Vimが挿入するインデントの幅
set shiftwidth=2
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" バックスペースで文字を消せるようにする
set backspace=indent,eol,start
au BufWritePre * let &bex = '.' . strftime("%Y%m%d_%H%M%S")
" バックアップ
set backup
set writebackup
" undo
set undodir=$HOME/.vim_undo
set undofile
" 構文毎に文字色を変化させる
syntax on
" カラースキーマの指定
colorscheme onedark
" 行番号の色
highlight LineNr ctermfg=darkyellow

" rg があれば使う
if executable('rg')
  set grepprg=rg\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif
" grep検索の実行後にQuickFix Listを表示する
autocmd QuickFixCmdPost *grep* cwindow

""""""""""""""""""""""""""""""
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
" if executable('osascript')
"   let s:keycode_jis_eisuu = 102
"   let g:force_alphanumeric_input_command = "osascript -e 'tell application \"System Events\" to key code " . s:keycode_jis_eisuu . "' &"
"
"   inoremap <silent> <Esc> <Esc>:call system(g:force_alphanumeric_input_command)<CR>
"
"   autocmd! FocusGained *
"     \ call system(g:force_alphanumeric_input_command)
" endif

""""""""""""""""""""""""""""""
" インサートモード時の移動
""""""""""""""""""""""""""""""
" insert mode でjjでesc
inoremap jj <Esc>
" インサートモード時のCtrl-cをESCと同じ挙動にする
inoremap <C-c> <ESC>
" 0番レジスタを使いやすくした
vnoremap <silent> <C-p> "0p
" x ではレジスタ書き込みさせない
nnoremap x "_x
nnoremap X "_x
vnoremap x "_x
vnoremap X "_x
" 検索は常に very magic
nnoremap /  /\v
" ESC*2 でハイライトやめる
let hlstate=0
nnoremap <Esc><Esc> :if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<cr>
" 保存時に行末の空白を除去する
function! s:remove_dust()
    let cursor = getpos(".")
    %s/\s\+$//ge
    %s/^M$//ge
    call setpos(".", cursor)
    unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()
" 2バイトの記号対策
set ambiwidth=double
" filetypeの自動検出(最後の方に書いた方がいいらしい)
filetype on
filetype plugin indent on
