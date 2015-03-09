"自動インデントで何も入力しないとインデントがなくなるのを何とかする
"Quickfixを使えるようにする
"よく意味の覚えていないオプションを正確に理解する
"visualモードでの:normalのショートカットを探す、または作る
"cindentに切り替えるモード、cppindentなるものも見つけた。
"タブ移動をdじゃなくてuに変える
"NERDTreeのEnterとかの動作を変える

set nocompatible
set cpo&vim
filetype plugin indent on
filetype plugin on
set path+=/usr/include/c++/4.9.1

	"------------"
	"    Look    "
	"------------"
syntax enable
set enc=utf-8
set number
set cursorline
set showmatch			" Show matching brackets.
set laststatus=2
set cmdheight=2
set nottybuiltin		" termの探索順序を 外部->組み込み にする
colorscheme railscasts-yuuto	"内部でtermの設定もしている



	"----------"
	"  Action  "
	"----------"
set timeout
set ttimeout			" なくても同じ
set timeoutlen=2500
set ttimeoutlen=100		" よくわかんないけどこれでESCの色適用が遅いのが解決した

set mouse=a
set nohidden				
set clipboard=unnamedplus	"この形なら動作した
set backspace=start,eol,indent
set whichwrap=b,s,[,],<,>,~
"set virtualedit=onemore
set wildmenu 
set wildmode=list:full	"cmodeでの補完
set incsearch			"リアルタイム検索みたいなもの
set hlsearch			"検索候補をハイライト	:noh でハイライトを消す

set nobackup
set viminfo+=n~/.vim/tmp/info.txt

set scrolloff=10
set wrapscan	"最後尾まで検索を終えたら次の検索で先頭に戻る
"set confirm	"未保存のファイルがあるときは終了前に確認
"set autoread	"外部でファイルが変更された時読みなおす


	"-------------"
	"Input support"
	"-------------"
set tabstop=2		"Tab表示幅
set softtabstop=2	"Tab押下時のカーソル移動量	
set shiftwidth=2	"インデント幅
set expandtab		"Tabキーでスペース挿入

set autoindent
set smartindent

"ここらへんの意味がわからない
set showcmd
set matchtime=1


	"==============="
	"   Dark vim?   "
	"==============="
"#Neobundle
source ~/.vim/neobundle.vim

"#run easy
source ~/.vim/easy-run.vim

"#When insert mode, change status line's color
source ~/.vim/imode-color.vim

"#Keymap
source ~/.vim/keymap.vim

"#Programing
source ~/.vim/filetype.vim


"######################
"######################
	"------------"
	"    Keep    "
	"------------"
"set term=gnome-256color
"set term=xterm-256color	"execute in the railscasts-yuuto

"set term=screen-256color	"あってもなくても動作は変わらなかった
"set term=screen-256color-bce
	"set <xHome>=OH
	"set <xEnd>=OF

"set listchars=tab:\ \	"としたら空白になった

	"-------------"
	"    Trash    "
	"-------------"

