if &compatible
  set nocompatible
endif

function! Source_rc(path)
  execute 'source' fnameescape(expand('~/.vim/rc/' . a:path))
endfunction

function! IsMac()
  return has('mac') || has('macunix') || has('gui_mac')
endfunction

filetype off
filetype plugin indent off
set viminfo+=n~/.vim/tmp/info.txt
set path+=/usr/include/c++/HEAD/

set enc=utf-8
set number
set cursorline
set showmatch       " Show matching brackets.
set laststatus=2
set cmdheight=2

set timeout
set ttimeout          " なくても同じ
set timeoutlen=3000
set ttimeoutlen=100
set nobackup
set mouse=a
set nohidden
set backspace=start,eol,indent
set whichwrap=b,s,[,],<,>,~
"set virtualedit=onemore
set wildmenu
set wildmode=longest:full,full
set scrolloff=10
set wrapscan  "最後尾まで検索を終えたら次の検索で先頭に戻る
"set confirm  "未保存のファイルがあるときは終了前に確認
"set autoread "外部でファイルが変更された時読みなおす
set iskeyword+=$,@-@  "設定された文字が続く限り単語として扱われる @は英数字を表す
set nrformats-=octal  " 加減算で数値を8進数として扱わない

set tabstop=2               "Tab表示幅
let &softtabstop = &tabstop "Tab押下時のカーソル移動量
let &shiftwidth  = &tabstop "インデント幅
set expandtab     "Tabキーでスペース挿入

set autoindent
set smartindent
set foldmethod=marker

if IsMac()
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif

"ここらへんの意味がわからない
set showcmd
set matchtime=1

function! EraseSpace_func()
  if &filetype != 'markdown'
    let s:cursor = getpos(".")
    %s/^\s\+$//ge
    %s/\s\+$//ge
    call setpos(".", s:cursor)
  endif
endfunction

command! EraseSpace :call EraseSpace_func()
command! NoEraseSpace :au! BufWritePre


if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  au BufWritePre * EraseSpace
  au VimEnter * lcd %:h
endif

  "==============="
  "   Dark vim?   "
  "==============="
source ~/.vim/neobundle.vim
source ~/.vim/imode-color.vim
source ~/.vim/keymap.vim
source ~/.vim/filetype.vim

filetype plugin indent on
syntax enable
set t_Co=256    " 色を256にしてくれる
set background=dark
