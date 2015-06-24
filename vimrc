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
set nocursorcolumn
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
set ignorecase
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
let &softtabstop=&tabstop "Tab押下時のカーソル移動量
let &shiftwidth=&tabstop "インデント幅
set expandtab     "Tabキーでスペース挿入

set autoindent
set smartindent
set foldmethod=marker
set foldlevel=0
set foldnestmax=2

if IsMac()
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif

"ここらへんの意味がわからない
set showcmd
set matchtime=1
set cmdwinheight=4

function! FoldText()
  let base  = foldtext()
  let title = substitute(base, '\s*\d.*:', '', 'g')
  return title
endfunction

set foldtext=FoldText()

" Capture New window {{{
command!
      \ -nargs=1
      \ -complete=command
      \ CaptureWin call CaptureWin(<f-args>)

function! CaptureWin(cmd)
  redir => result
  silent execute a:cmd
  redir END

  let bufname = 'Capture: ' . a:cmd
  new
  setlocal bufhidden=unload
  setlocal nobuflisted
  setlocal buftype=nofile
  setlocal noswapfile
  silent file `=bufname`
  silent put =result
  1,2delete _
endfunction
" }}}

" Capture {{{
command!
      \ -nargs=1 -bang
      \ -complete=command
      \ Capture call Capture(<f-args>)

function! Capture(cmd)
  redir => g:capture
  silent execute a:cmd
  redir END
  return g:capture
endfunction
" }}}

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

au BufReadPost  * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
au BufWritePre  * EraseSpace
au BufEnter     * lcd %:p:h


" #source
source ~/.vim/neobundle.vim
source ~/.vim/keymap.vim
source ~/.vim/filetype.vim

filetype plugin indent on
syntax enable
set t_Co=256    " 色を256にしてくれるよ!
set background=dark

function! s:set_colors()
  if exists("g:set_colors")
    return 0
  elseif &filetype == 'cpp' || &filetype == 'c'
    colorscheme lettuce
    " colorscheme kalisi
  elseif &filetype == 'ruby' || &filetype == 'gitcommit'
    colorscheme railscasts_u10
  else
    colorscheme molokai
  endif

  hi YankRoundRegion cterm=italic
  " hi YankRoundRegion cterm=underline

  let g:set_colors = 1
endfunction

function! s:only_once()
  if !exists("g:only_once")
    SpeedDatingFormat! %v
    SpeedDatingFormat! %^v
  endif
  let g:only_once = 1
endfunction

au FileType * call s:set_colors()
au FileType * call s:only_once()
au FileType * highlight Visual          cterm=reverse
au FileType * highlight Search          ctermfg=39 ctermbg=56
au FileType * highlight IncSearch       ctermfg=39 ctermbg=50
