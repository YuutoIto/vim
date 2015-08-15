" #Capture {{{
" cmdをクォートなしでとれる
command! -nargs=+ -complete=command
      \ Capture call Capture(<q-args>)

" cmdをクォートで囲んでとる
function! Capture(cmd)
  redir => l:out
  silent execute a:cmd
  redir END
  let g:capture = substitute(l:out, '\%^\n', '', '')
  return g:capture
endfunction
" }}}

" #Capture New window {{{
command! -nargs=+ -complete=command
      \ CaptureWin call CaptureWin(<q-args>)

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

" #MoveToTab "{{{
command! Movett call s:MoveToTab()
function! s:MoveToTab()
    tab split
    tabprevious

    if winnr('$') > 1
        close
    elseif bufnr('$') > 1
        buffer #
    endif

    tabnext
endfunction
"}}}

" #EraseSpace "{{{
let g:erase_space_on = 1
command! EraseSpace :call EraseSpace()
command! EraseSpaceEnable :let g:erase_space_on=1
command! EraseSpaceDisable :let g:erase_space_on=0
function! EraseSpace()
  if g:erase_space_on != 1
    return
  endif

  " filetypeが一致したらreturn
  if index(['markdown', 'gitcommit'], &filetype) != -1
    return
  endif

  let l:cursor = getpos(".")
  %s/\s\+$//ge
  call setpos(".", l:cursor)
endfunction
"}}}

" #Buffer functions "{{{

" #BuffersInfo
" bufnr status modified name を返す
command! BuffersInfo for buf in BuffersInfo() | echo buf | endfor
function! BuffersInfo()
  return map(split(Capture('ls'), '\n'),
        \ 'matchlist(v:val, ''\v^\s*(\d*)\s+([^ ]*)\s*(\+?)\s*"(.*)"\s*.*\s(\d*)$'')[1:4]' )
endfunction

command! BufferCount ruby print VIM::Buffer.count
function! BufferCount()
  return Capture("BufferCount")
endfunction

command! Ao Aonly
function! ActiveBufferCount()
  let l:count = 0
  for l:buf in BuffersInfo()
    if -1 != stridx(l:buf[1], 'a')
      let l:count+=1
    endif
  endfor
  return l:count
endfunction

" #CurrentOnly
command! Co Conly
command! Conly call CurrentOnly()
command! CurrentOnly call CurrentOnly()
function! CurrentOnly()
  let l:old = &report
  set report=1000
  let l:count=0

  for l:buf in BuffersInfo()
    if -1 == stridx(l:buf[1], '%')
      execute "bdelete" l:buf[0]
      let l:count+=1
    endif
  endfor

  echo l:count "buffer deleted"
  let &report=l:old
endfunction

" #ActiveOnly
command! Aonly call ActiveOnly()
command! ActiveOnly call ActiveOnly()
function! ActiveOnly()
  let l:old = &report
  set report=1000
  let l:count=0

  for l:buf in BuffersInfo()
    if -1 == stridx(l:buf[1], 'a')
      execute "bdelete" l:buf[0]
      let l:count+=1
    endif
  endfor

  echo l:count "buffer deleted"
  let &report=l:old
endfunction
"}}}

" #Syntaxinfo "{{{
command! SyntaxInfo call s:get_syn_info()
function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction

function! s:get_syn_attr(synid)
  let name    = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg   = synIDattr(a:synid, "fg", "gui")
  let guibg   = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name"    : name,
        \ "ctermfg" : ctermfg,
        \ "ctermbg" : ctermbg,
        \ "guifg"   : guifg,
        \ "guibg"   : guibg }
endfunction

function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  let base = "name: "  . baseSyn.name    .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: "   . baseSyn.guifg   .
        \ " guibg: "   . baseSyn.guibg

  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  let link = "name: "  . linkedSyn.name    .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: "   . linkedSyn.guifg   .
        \ " guibg: "   . linkedSyn.guibg

  echo base
  if base != link
    echo "link to"
    echo link
  endif
endfunction
"}}}

function! SelectInteractive(question, candidates) " {{{
  try
    let a:candidates[0] = toupper(a:candidates[0])
    let l:select = 0
    while index(a:candidates, l:select, 0, 1) == -1
      let l:select = input(a:question . ' [' . join(a:candidates, '/') . '] ')
      if l:select == ''
        let l:select = a:candidates[0]
      endif
    endwhile
    return tolower(l:select)
  finally
    redraw!
  endtry
endfunction " }}}
function! BufferWipeoutInteractive() " {{{
  if &modified == 1
    let l:selected = SelectInteractive('Buffer is unsaved. Force quit?', ['n', 'w', 'y'])
    if l:selected == 'w'
      write
      bwipeout
    elseif l:selected == 'y'
      bwipeout!
    endif
  else
    bwipeout
  endif
endfunction " }}}

" TODO: 動作検証
function! OneShotAutocmd(name, event, pattern, cmd) "{{{
  function l:tmp_func()
    execute cmd
    autocmd! {a:name}
  endfunction

  augroup a:name
    autocmd!
    autocmd {a:event} {a:pattern} call l:tmp_func()
  augroup END
endfunction "}}}

command! Uclear UndoClear "{{{
command! UndoClear :call UndoClear()
function! UndoClear()
  let l:old = &undolevels
  set undolevels=-1
  exe "normal a \<BS>\<Esc>"
  let &undolevels = l:old
  unlet l:old
  write
endfunction "}}}

function Execute(cmd) "{{{
  execute a:cmd
  return ""
endfunction "}}}

" #OpenGitDiff "{{{
command! OpenGitDiffWin call OpenGitDiff('w')
command! OpenGitDiffTab call OpenGitDiff('t')
function! OpenGitDiff(type)
  let cmdname = 'git diff ' .  bufname('%')
  silent! execute 'bdelete \[' . escape(cmdname, ' ') . '\]'

  let tmp_spr = &splitright
  set splitright
  execute (a:type == 't')? 'tabnew' : 'vnew' '[' . cmdname . ']'
  let &splitright=tmp_spr

  setl buftype=nofile
  setl filetype=diff
  setl undolevels=-1
  setl nofoldenable
  setl foldcolumn=0
  silent put! =system(cmdname)
  nnoremap <buffer><silent>q :bdelete!<CR>
endfunction "}}}
