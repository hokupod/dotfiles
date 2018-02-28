" 挙動を vi 互換ではなく、Vim のデフォルト設定にする
set nocompatible
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
" プラグインのセットアップ
""""""""""""""""""""""""""""""
if has('vim_starting')
  set nocompatible " Be iMproved

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
" Required:
call neobundle#begin(expand('~/.vim/bundle/'))
" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'
" ファイルオープンを便利に
NeoBundle 'Shougo/unite.vim'
" Unite.vimで最近使ったファイルを表示できるようにする
NeoBundle 'Shougo/neomru.vim'
" 使い捨てファイル生成
NeoBundle 'Shougo/junkfile.vim'
" Open junk file."{{{
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
  let l:junk_dir = $HOME . '/OneDrive\ -\ 武宮北斗/work/vim_junk'. strftime('/%Y/%m')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
  if l:filename != ''
    execute 'edit ' . l:filename
  endif
endfunction
"}}}

" スクリプト実行
NeoBundle 'thinca/vim-quickrun'
" quickrun設定----
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
      \ 'runner'    : 'vimproc',
      \ 'runner/vimproc/updatetime' : 60,
      \ 'outputter' : 'error',
      \ 'outputter/error/success' : 'buffer',
      \ 'outputter/error/error'   : 'quickfix',
      \ 'outputter/buffer/split'  : ':rightbelow 8sp',
      \ 'outputter/buffer/close_on_empty' : 1,
      \ }
" q でquickfixを閉じれるようにする。
au FileType qf nnoremap <silent><buffer>q :quit<CR>
" <C-c> でquickrunを停止
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
" ----

" ファイルをtree表示してくれる
NeoBundle 'scrooloose/nerdtree'
" 保存時にCtags実行
NeoBundle 'soramugi/auto-ctags.vim'
"let g:auto_ctags = 1
" Gitを便利に使う
NeoBundle 'tpope/vim-fugitive'
" Rails向けのコマンドを提供する
NeoBundle 'tpope/vim-rails'
" Ruby向けにendを自動挿入してくれる
NeoBundle 'tpope/vim-endwise'
" コメントON/OFFを手軽に実行
NeoBundle 'tomtom/tcomment_vim'
" シングルクオートとダブルクオートの入れ替え等
NeoBundle 'tpope/vim-surround'
" インデントに色を付けて見やすくする
NeoBundle 'nathanaelkane/vim-indent-guides'
" ログファイルを色づけしてくれる
NeoBundle 'vim-scripts/AnsiEsc.vim'
" 行末の半角スペースを可視化(うまく動かない？)
NeoBundle 'bronson/vim-trailing-whitespace'
" 置換予定の文字をハイライト :OverCommandLine で起動
NeoBundle 'osyo-manga/vim-over'
" Emmetを使用可能にする
NeoBundle 'mattn/emmet-vim'
" Emmetのキーバインドを変更
let g:user_emmet_leader_key='<c-t>'
" テーマ
NeoBundle 'jpo/vim-railscasts-theme'
" インデント
NeoBundle 'nathanaelkane/vim-indent-guides'
" vim-indent-guides
let g:indent_guides_auto_colors=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=52
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=94
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1
" less用のsyntaxハイライト
NeoBundle 'KohPoll/vim-less'
" slim用のsyntaxハイライト
NeoBundle "slim-template/vim-slim"
" JavaScript系用のsyntaxハイライト
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'JavaScript-syntax'
NeoBundle 'jQuery'
NeoBundle 'marijnh/tern_for_vim', {
  \ 'build': {
  \   'others': 'npm install'
  \}}
NeoBundle 'syntastic'
" syntastic用----
let g:syntastic_javascript_checker = "jshint"
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['ruby', 'javascript'],
                           \ 'passive_filetypes': [] }
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
highlight SyntasticErrorSign guifg=red ctermfg=red
highlight SyntasticWarningSign guifg=yellow ctermfg=yellow
" ----
" テキストオブジェクト系 ----
" textobj のベース
NeoBundle "kana/vim-textobj-user"
" バッファ全体
" ae, ie
NeoBundle "kana/vim-textobj-entire"
" カーソル位置と同じインデント
" al, il
NeoBundle "kana/vim-textobj-indent"
" 関数内
" af, if
NeoBundle "kana/vim-textobj-function"
" シンタックス
" ay, iy
NeoBundle "kana/vim-textobj-syntax"
" 「foo」 or 【bar】など
" ajb, ijb
NeoBundle "kana/vim-textobj-jabraces"

" 20150718追加ここから
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }

NeoBundleLazy 'edsono/vim-matchit', { 'autoload' : {
      \ 'filetypes': 'ruby',
      \ 'mappings' : ['nx', '%'] }}

NeoBundleLazy 'basyura/unite-rails', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload' : {
      \   'unite_sources' : [
      \     'rails/bundle', 'rails/bundled_gem', 'rails/config',
      \     'rails/controller', 'rails/db', 'rails/destroy', 'rails/features',
      \     'rails/gem', 'rails/gemfile', 'rails/generate', 'rails/git', 'rails/helper',
      \     'rails/heroku', 'rails/initializer', 'rails/javascript', 'rails/lib', 'rails/log',
      \     'rails/mailer', 'rails/model', 'rails/rake', 'rails/route', 'rails/schema', 'rails/spec',
      \     'rails/stylesheet', 'rails/view'
      \   ]
      \ }}

NeoBundleLazy 'alpaca-tc/neorspec.vim', {
      \ 'depends' : ['alpaca-tc/vim-rails', 'tpope/vim-dispatch'],
      \ 'autoload' : {
      \   'commands' : ['RSpec', 'RSpecAll', 'RSpecCurrent', 'RSpecNearest', 'RSpecRetry']
      \ }}

" NeoBundleLazy 'alpaca-tc/alpaca_tags', {
"       \    'depends': ['Shougo/vimproc'],
"       \    'autoload' : {
"       \       'commands' : [
"       \          { 'name' : 'AlpacaTagsBundle', 'complete': 'customlist,alpaca_tags#complete_source' },
"       \          { 'name' : 'AlpacaTagsUpdate', 'complete': 'customlist,alpaca_tags#complete_source' },
"       \          'AlpacaTagsSet', 'AlpacaTagsCleanCache', 'AlpacaTagsEnable', 'AlpacaTagsDisable', 'AlpacaTagsKillProcess', 'AlpacaTagsProcessStatus',
"       \       ],
"       \    }
"       \ }
"
" let g:alpaca_tags#config = {
"       \    '_' : '-R --sort=yes',
"       \    'ruby': '--languages=+Ruby',
"       \    'js' : '--languages=+js',
"       \    'php' : '--languages=+php',
"       \    'scss' : '--languages=+scss --languages=-css',
"       \    'css' : '--languages=+css',
"       \    'coffee': '--languages=+coffee'
"       \ }

NeoBundleLazy 'tsukkee/unite-tag', {
      \ 'depends' : ['Shougo/unite.vim'],
      \ 'autoload' : {
      \   'unite_sources' : ['tag', 'tag/file', 'tag/include']
      \ }}

NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" for TypeScript
NeoBundle 'Quramy/tsuquyomi'
let mapleader = ","
noremap \ ,
augroup typescript_key_mapping
  autocmd FileType typescript nmap <buffer> <Leader>e <Plug>(TsuquyomiRenameSymbol)
augroup END
NeoBundle 'leafgarland/typescript-vim'
let g:typescript_indent_disable = 1
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
autocmd FileType typescript :set makeprg=tsc
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
NeoBundle 'osyo-manga/vim-monster'
NeoBundle 'Shougo/neocomplete'
" Set async completion.
let g:monster#completion#rcodetools#backend = "async_rct_complete"

" Use neocomplete.vim
let g:neocomplete#sources#omni#input_patterns = {
\   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
\}
" NeoCompleteを有効にする
let g:neocomplete#enable_at_startup = 1
" smart case有効化。 大文字が入力されるまで大文字小文字の区別を無視する
let g:neocomplete#enable_smart_case = 1

" Ruby用のテキストオブジェクト拡張
NeoBundle 'rhysd/vim-textobj-ruby'
" vibみたいなのを簡単にする
NeoBundle 'terryma/vim-expand-region'
map <CR> <Plug>(expand_region_expand)
map <C-CR> <Plug>(expand_region_shrink)

" ローカル変数のハイライト
NeoBundleLazy 'todesking/ruby_hl_lvar.vim', {
\   'autoload': {
\     'filetypes': ['ruby']
\   }
\ }
let s:bundle = neobundle#get('ruby_hl_lvar.vim')
function! s:bundle.hooks.on_post_source(bundle)
  function! Ruby_hl_lvar_filetype()
    let groupname = 'vim_hl_lvar_'.bufnr('%')
    execute 'augroup '.groupname
      autocmd!
      if &filetype ==# 'ruby'
        if g:ruby_hl_lvar_auto_enable
          call ruby_hl_lvar#refresh(1)
          "autocmd TextChanged <buffer> call ruby_hl_lvar#refresh(0)
          autocmd InsertEnter <buffer> call ruby_hl_lvar#disable(0)
          autocmd InsertLeave <buffer> call ruby_hl_lvar#refresh(0)
        else
          call ruby_hl_lvar#disable(1)
        endif
      endif
    augroup END
  endfunction

  silent! execute 'doautocmd FileType' &filetype
endfunction
unlet s:bundle


" ====================================
" Rsenseは重いのでお休み
" ====================================
" NeoBundle 'supermomonga/neocomplete'
" NeoBundleLazy 'supermomonga/neocomplete-rsense.vim', { 'autoload' : {
"   \ 'insert' : 1,
"   \ 'filetypes': 'ruby',
"   \ }}
" let g:rsenseUseOmniFunc = 1
" if !exists('g:neocomplete#force_omni_input_patterns')
"   let g:neocomplete#force_omni_input_patterns = {}
" endif
" let g:acp_enableAtStartup = 0
" let g:neocomplete#enable_at_startup = 1
" let g:neocomplete#enable_smart_case = 1
" let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
" let g:neocomplete#sources#rsense#home_directory = '/usr/local/bin/rsense'
" let g:rsenseHome = '/usr/local/Cellar/rsense/0.3/libexec'
" ====================================

" Markdown用
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'
" 拡張子mdもMarkdownとして扱う
au BufRead,BufNewFile *.md set filetype=markdown

" 20150718追加ここまで

call neobundle#end()
" Required:
filetype plugin indent on
" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
""""""""""""""""""""""""""""""
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
set noswapfile
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
" バックアップ
set backupdir=$HOME/OneDrive\ -\ 武宮北斗/Apps/vim_backup
set directory=$HOME/OneDrive\ -\ 武宮北斗/Apps/vim_backup
set backup
set writebackup
au BufWritePre * let &bex = '.' . strftime("%Y%m%d_%H%M%S")
" 無名レジスタに入るデータを、*レジスタにも入れる。
set clipboard+=unnamed

" 構文毎に文字色を変化させる
syntax on
" カラースキーマの指定
"colorscheme desert
colorscheme railscasts
" 行番号の色
highlight LineNr ctermfg=darkyellow
""""""""""""""""""""""""""""""
" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1
" grep検索の実行後にQuickFix Listを表示する
autocmd QuickFixCmdPost *grep* cwindow
" http://blog.remora.cx/2010/12/vim-ref-with-unite.html
""""""""""""""""""""""""""""""
" Unit.vimの設定
""""""""""""""""""""""""""""""
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
noremap <C-P> :Unite buffer<CR>
" ファイル一覧
noremap <C-N> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Unite file_mru<CR>
" sourcesを「今開いているファイルのディレクトリ」とする
noremap :uff :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
" タグジャンプ
nnoremap <C-h> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <C-k> :split<CR> :exe("tjump ".expand('<cword>'))<CR>
""""""""""""""""""""""""""""""
" http://inari.hatenablog.com/entry/2014/05/05/231307
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
" https://sites.google.com/site/fudist/Home/vim-nihongo-ban/-vimrc-sample
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
""""""""""""""""""""""""""""""
" AlpacaTags
""""""""""""""""""""""""""""""
augroup AlpacaTags
  autocmd!
  if exists(':AlpacaTags')
    autocmd BufWritePost Gemfile AlpacaTagsBundle
    autocmd BufEnter * AlpacaTagsSet
    autocmd BufWritePost * AlpacaTagsUpdate
  endif
augroup END

""""""""""""""""""""""""""""""
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
""""""""""""""""""""""""""""""
" ペーストモード切替
""""""""""""""""""""""""""""""
set pastetoggle=<C-Y>
""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" 自動的に閉じ括弧を入力
""""""""""""""""""""""""""""""
imap { {}<LEFT>
imap [ []<LEFT>
imap ( ()<LEFT>

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

" ノーマルモードでも改行挿入
noremap <CR> o<ESC>
noremap <S-CR> O<ESC>
" 検索は常に very magic
nnoremap /  /\v

" ESC*2 でハイライトやめる
nnoremap <Esc><Esc> :<C-u>set nohlsearch<Return>

" 保存時に行末の空白を除去する
autocmd BufWritePre * :%s/\s\+$//ge

" 2バイトの記号対策
set ambiwidth=double
" filetypeの自動検出(最後の方に書いた方がいいらしい)
filetype on
