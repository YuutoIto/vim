if &compatible
  set nocompatible
endif

function! IsMac()
  return (has('mac') || has('macunix') || has('gui_macvim') ||
        \   (!executable('xdg-open') && system('uname') =~? '^darwin'))
endfunction

function! s:source_rc(path)
  execute 'source' fnameescape(expand('~/.vim/rc/' . a:path))
endfunction

augroup uAutoCmd
  autocmd!
augroup END

command! -nargs=1 Source
      \ execute 'source' expand('~/.vim/' . <args> . '.vim')

let $CACHE = expand('~/.cache')
set viminfo+=n~/.vim/tmp/info.txt
set path+=/usr/include/c++/HEAD/


" Release keymappings for plug-in.
let mapleader = ";"
nnoremap Q <Nop>
nnoremap ; <Nop>
xnoremap ; <Nop>
nnoremap , <Nop>
xnoremap , <Nop>
nnoremap s <Nop>
xnoremap s <Nop>

Source 'neobundle'
filetype plugin indent on " Required
syntax enable

if has('vim_starting')
  NeoBundleCheck
endif

language message C
scriptencoding=utf-8
set encoding=utf-8
set fileformats=unix,dos,mac
" set fileencodings=ucs-bom,utf-8,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932

set number
set hidden
set showcmd
set cursorline
set showmatch
set laststatus=2
set cmdheight=2 cmdwinheight=4
set mouse=a
set nobackup

" Keymapping timeout.
set timeout timeoutlen=3000 ttimeoutlen=100
" CursorHold time.
set updatetime=1000

set autoindent smartindent
set ignorecase smartcase

set backspace=start,eol,indent
set whichwrap=b,s,[,],<,>
set matchpairs+=<:>
set iskeyword+=$,@-@  "設定された文字が続く限り単語として扱われる @は英数字を表す

" Enable virtualedit in visual block mode.
set virtualedit=block

" #menu
set wildmenu
set wildmode=longest:full,full
set nrformats-=octal  " 加減算で数値を8進数として扱わない

" #search
set incsearch
set hlsearch | nohlsearch "Highlight search patterns, support reloading

" #tab
set shiftround
set expandtab     "Tabキーでスペース挿入
set tabstop=2     "Tab表示幅
set softtabstop=2 "Tab押下時のカーソル移動量
set shiftwidth=2  "インデント幅
" set smarttab

" #fold
set foldmethod=marker
set foldcolumn=1
set foldtext=FoldCCtext()
set foldlevel=0     " どのレベルから折りたたむか
set foldnestmax=2   " どの深さまで折りたたむか
" set foldenable
" set foldclose=all " 折りたたんでるエリアからでると自動で閉じる

" set list
set listchars=tab:❯\ ,trail:˼,extends:»,precedes:«,nbsp:%

let &clipboard = IsMac()? 'unnamed' : 'unnamedplus'
set cpoptions-=m

" Change cursor shape.
if &term =~ "xterm"
  let &t_SI = "\<Esc>]12;lightgreen\x7"
  let &t_EI = "\<Esc>]12;white\x7"
endif

Source 'function'
Source 'keymap'

au uAutoCmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
au uAutoCmd BufEnter    * lcd %:p:h
au uAutoCmd VimResized  * wincmd =

" 引数を全てタブで開く 条件付けないとcommittiaがうまくいなかくなる
au uAutoCmd VimEnter    * nested if 2 <= argc() | tab ball | endif

" windowの行数の20%にセットする scrolloffはglobal-option
command! SmartScrolloff let &scrolloff=float2nr(winheight('')*0.2)
au uAutoCmd VimEnter * SmartScrolloff
au uAutoCmd WinEnter * SmartScrolloff

au uAutoCmd FileType vim setl iskeyword-=#
au uAutoCmd FileType * setl formatoptions-=ro
" r When type <return> in insert-mode auto insert commentstring
" o	ノーマルモードで'o'、'O'を打った後に、現在のコメント指示を自動的に挿入する。

set t_Co=256
set background=dark

au uAutoCmd FileType * nested call s:set_colors()
au uAutoCmd ColorScheme * highlight Visual cterm=reverse
"au uAutoCmd CursorMoved * nohlsearch

function! s:set_colors() "{{{
  if exists("g:set_colors")
    return 0
  end

  if &filetype == 'cpp' || &filetype == 'c'
    colorscheme lettuce
    " colorscheme kalisi
  elseif &filetype == 'ruby' || &filetype == 'gitcommit'
    colorscheme railscasts_u10
  elseif &filetype == 'vimfiler'
    " 一度だけ実行するautocmd
    augroup set_airline_color
      autocmd!
      autocmd FileType * colorscheme airline_color | autocmd! set_airline_color
    aug END

    colorscheme vimfiler_color
    return 0
  else
    colorscheme molokai
  endif

  colorscheme vimfiler_color

  let g:set_colors=1
endfunction "}}}

" each filetype config
au uAutoCmd FileType c,cpp,ruby,zsh,php,perl set cindent
au uAutoCmd FileType c,cpp set commentstring=//\ %s
au uAutoCmd FileType html,css set foldmethod=indent

au uAutoCmd FileType help call s:help_config()
function! s:help_config()
  nnoremap <buffer> q :q<CR>
  setlocal foldmethod=indent
  setlocal foldcolumn=1
  setlocal foldclose=all
  setlocal number
endfunction
