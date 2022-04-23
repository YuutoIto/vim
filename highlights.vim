" filetypeでスキーマを切り替えていたときの名残
function! s:set_common_highlights() abort
  hi Pmenu        ctermfg=255  ctermbg=240 guifg=#eeeeee guibg=#3a3a3a cterm=NONE gui=NONE
  hi PmenuSel     ctermfg=255  ctermbg=250 guifg=#eaeaea guibg=#5a5a5a cterm=NONE gui=NONE
  hi! link WildMenu    Pmenu
  hi! link SignColumn  LineNr
  " hi! link FoldColumn  LineNr
  hi FoldColumn   guifg=#616155 guibg=NONE

  hi NormalFloat  ctermfg=254  ctermbg=0   guifg=#eeeeee guibg=#1c1b19 cterm=NONE gui=NONE
  hi Search       ctermfg=75   ctermbg=18  guifg=#eeefff guibg=#404050 cterm=NONE gui=NONE
  hi IncSearch    ctermfg=56   ctermbg=39  guifg=#eeefff guibg=#40a0d0 cterm=NONE gui=bold
  hi VertSplit    guifg=#7C7863 guibg=NONE

  " hi Title      ctermfg=118               guifg=#87ff00
  hi Error      ctermfg=161  ctermbg=NONE guifg=#d7005f guibg=NONE
  hi QFError    ctermfg=198               guifg=#ff0087               cterm=NONE gui=NONE
  hi QFWarning  ctermfg=202               guifg=#ff5f00               cterm=NONE gui=NONE
  hi QuickFixLine ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
endfunction

" filetypeでスキーマを切り替えていたときの名残
function! s:set_overwrite_highlights()
  " Diff:
  hi DiffAdd     ctermfg=255 ctermbg=163 guifg=#eeeeee guibg=#d700af
  hi DiffDelete  ctermfg=200 ctermbg=56  guifg=#ff00d7 guibg=#5f00d7
  hi DiffChange  ctermfg=252 ctermbg=22  guifg=#d0d0d0 guibg=#005f00
  hi DiffText    ctermfg=226 ctermbg=29  guifg=#ffff00 guibg=#00875f
  hi diffFile    ctermfg=227             guifg=#fed06e
  hi diffAdded   ctermfg=1               guifg=#c9ea5a
  hi diffRemoved ctermfg=2               guifg=#ff6666

  " Signify:
  hi SignifySignAdd    ctermfg=70  guifg=#41be30
  hi SignifySignChange ctermfg=226 guifg=#fbff00
  hi SignifySignDelete ctermfg=1   guifg=#ff2222
  hi! link SignifySignChangeDelete    SignifySignDelete
  hi! link SignifySignDeleteFirstLine SignifySignDelete

  " ALE:
  hi ALEVirtualTextError   guifg=#ff5e80 guibg=NONE
  hi ALEVirtualTextWarning guifg=#f0ff80 guibg=NONE
  hi ALEVirtualTextInfo    guifg=#80cff0 guibg=NONE

  " Hop:
  hi HopNextKey   guifg=#00dfff gui=bold ctermfg=45 cterm=bold
  hi! link HopNextKey1 HopNextKey
  hi! link HopNextKey2 HopNextKey
  hi HopUnmatched guifg=#666666 ctermfg=242

  " StatusLine:
  hi StatusLine gui=NONE guibg=#20202f
  hi StatusLineNC gui=NONE guibg=#20202f

  if g:colors_name ==? 'srcery'
    hi Normal guibg=#0c0b09
    hi! link Comment SrceryBrightBlack

    " gitcommit
    hi! link gitcommitSelectedFile SrceryBrightWhite
    hi! link gitcommitBranch SrceryMagenta
    hi! link gitcommitSummary SrceryBrightWhite
    hi! link gitcommitDiscardedFile gitcommitSelectedFile

    " vim-markdown
    " bgはsrceryで設定できないので直書き
    hi! mkdLineBreak       ctermbg=240 guibg=#585858
    hi! link mkdBlockquote SrceryBrightGreen
    hi! link mkdLink       SrceryBrightBlue
    hi! link mkdInlineURL  mkdLink
    hi! link mkdURL        SrceryBrightWhite
    hi! link mkdListItem   markdownListMarker

    " vim-markdown: codes
    hi! link mkdCode          SrceryBrightYellow " `hoge`
    hi! link mkdCodeDelimiter mkdCode            " `hoge`
    hi! link mkdCodeStart     SrceryBrightBlack  " ```hoge
    hi! link mkdCodeEnd       mkdCodeStart       " ```

    " vim-markdown: headers
    hi! link htmlH1 SrceryBrightMagenta
    hi! link htmlH2 SrceryBrightBlue
    hi! link htmlH3 SrceryBrightGreen
    hi! link htmlH4 SrceryYellow
    hi! link htmlH5 SrceryBrightRed
    hi! link htmlH6 SrceryBrightCyan
  endif
endfunction

if &g:loadplugins
  hi Normal       ctermfg=252 ctermbg=233 guifg=#F8F8F2 guibg=#1B1D1E
  hi CursorLine               ctermbg=234               guibg=#293739 cterm=NONE gui=NONE
  hi Visual       cterm=reverse gui=reverse

  hi! link Statement   Visual
  hi! link LineNr      Normal

  colorscheme srcery
  call s:set_common_highlights()
  call s:set_overwrite_highlights()
endif
