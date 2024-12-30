" ddu-ff {{{
nnoremap <buffer> <CR>
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \   ddu#ui#get_item()->get('action', {})->get('isDirectory', v:false)
      \ ? #{ name: 'narrow' }
      \ : #{ name: 'default' })<CR>
nnoremap <buffer> <2-LeftMouse>
      \ <Cmd>call ddu#ui#do_action('itemAction')<CR>

" #### core ####
nnoremap <buffer><nowait> <Space>
      \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>j
xnoremap <silent><buffer><nowait> <Space>
      \ :call ddu#ui#do_action('toggleSelectItem')<CR>
nnoremap <buffer> *
      \ <Cmd>call ddu#ui#do_action('toggleAllItems')<CR>
nnoremap <buffer> i
      \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
nnoremap <buffer> <C-l>
      \ <Cmd>call ddu#ui#do_action('redraw', #{ method: 'refreshItems' })<CR>
nnoremap <buffer> q
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
nnoremap <buffer> <esc>
      \ <Cmd>call ddu#ui#do_action('quit')<CR>

" #### preview ####
nnoremap <buffer> p
      \ <Cmd>call ddu#ui#do_action('previewPath')<CR>
nnoremap <buffer> P
      \ <Cmd>call ddu#ui#do_action('togglePreview')<CR>
nnoremap <buffer> <C-p>
      \ <Cmd>call ddu#ui#do_action('previewExecute',
      \ #{ command: 'execute "normal! \<C-y>"' })<CR>
nnoremap <buffer> <C-n>
      \ <Cmd>call ddu#ui#do_action('previewExecute',
      \ #{ command: 'execute "normal! \<C-e>"' })<CR>

" #### choose actions ####
nnoremap <buffer> <tab>
      \ <Cmd>call ddu#ui#do_action('chooseAction')<CR>
      \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
nnoremap <buffer> a
      \ <Cmd>call ddu#ui#do_action('chooseAction')<CR>
      \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
nnoremap <buffer> A
      \ <Cmd>call ddu#ui#do_action('inputAction')<CR>

" #### open actions ####
nnoremap <buffer><nowait> t
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'tabopen' })<CR>
nnoremap <buffer><nowait> s
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'split' })<CR>
nnoremap <buffer><nowait> v
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'vsplit' })<CR>

nnoremap <buffer> o
      \ <Cmd>call ddu#ui#do_action('expandItem',
      \ #{ mode: 'toggle' })<CR>
nnoremap <buffer> O
      \ <Cmd>call ddu#ui#do_action('collapseItem')<CR>
nnoremap <buffer> d
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \   b:ddu_ui_name ==# 'filer'
      \ ? #{ name: 'trash' }
      \ : #{ name: 'delete' })<CR>
nnoremap <buffer> e
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \   ddu#ui#get_item()->get('action', {})->get('isDirectory', v:false)
      \ ? #{ name: 'narrow' }
      \ : #{ name: 'edit' })<CR>
nnoremap <buffer> E
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ params: input('params: ', '{}')->eval() })<CR>
nnoremap <buffer> N
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \   b:ddu_ui_name ==# 'file'
      \ ? #{ name: 'newFile' }
      \ : #{ name: 'new' })<CR>
nnoremap <buffer> r
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'quickfix' })<CR>
nnoremap <buffer> yy
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'yank' })<CR>
nnoremap <buffer> gr
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'grep' })<CR>
nnoremap <buffer> n
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'narrow' })<CR>
nnoremap <buffer> K
      \ <Cmd>call ddu#ui#do_action('kensaku')<CR>
nnoremap <buffer> <C-v>
      \ <Cmd>call ddu#ui#do_action('toggleAutoAction')<CR>

" TODO
" " Qfrepace:
" nnoremap <silent><buffer><nowait><expr>r denite#do_map('do_action', 'qfreplace')
" nmap <buffer>R *r

" Switch options
nnoremap <buffer> u
      \ <Cmd>call ddu#ui#multi_actions([
      \   [
      \      'updateOptions', #{
      \        filterParams: #{
      \          matcher_files: #{
      \             globs: 'Filter files: '
      \                    ->cmdline#input('', 'file')->split(','),
      \          },
      \        },
      \      }
      \   ],
      \   [
      \      'redraw', #{ method: 'refreshItems' },
      \   ],
      \ ])<CR>

" Switch sources
nnoremap <buffer> ff
      \ <Cmd>call ddu#ui#do_action('updateOptions', #{
      \   sources: [
      \     #{ name: 'file' },
      \   ],
      \ })<CR>
      \<Cmd>call ddu#ui#do_action('redraw', #{ method: 'refreshItems' })<CR>

" Cursor move

nnoremap <buffer> <C-j>
      \ <Cmd>call ddu#ui#do_action('cursorNext')<CR>
nnoremap <buffer> <C-k>
      \ <Cmd>call ddu#ui#do_action('cursorPrevious')<CR>

nnoremap <buffer> >
      \ <Cmd>call ddu#ui#do_action('updateOptions', #{
      \   uiParams: #{
      \     ff: #{
      \       winWidth: 80,
      \     },
      \   },
      \ })<CR>
      \<Cmd>call ddu#ui#do_action('redraw', #{ method: 'uiRedraw' })<CR>
" }}}

" hook_source {{{
autocmd myac User Ddu:ui:ff:openFilterWindow call s:ddu_ff_filter_my_settings()
function s:ddu_ff_filter_my_settings() abort
  call ddu#ui#ff#save_cmaps([
    \  '<C-n>', '<C-p>', '<C-t>', '<C-s>', '<C-v>', '<ESC>', '<CR>', '<Tab>',
    \ ])

  cnoremap <C-n>
    \ <Cmd>call ddu#ui#do_action('cursorNext', #{ loop: v:true })<CR>
  cnoremap <C-p>
    \ <Cmd>call ddu#ui#do_action('cursorPrevious', #{ loop: v:true })<CR>
  cnoremap <Tab>
    \ <CR><Cmd>call ddu#ui#do_action('chooseAction')<CR>

  cnoremap <C-t>
    \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'tabopen' })<CR><ESC>
  cnoremap <C-s>
    \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'split' })<CR><ESC>
  cnoremap <C-v>
    \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'vsplit' })<CR><ESC>
  cnoremap <CR>
    \ <Cmd>call ddu#ui#do_action('itemAction')<CR><ESC>
  cnoremap <ESC> <CR>
endfunction

autocmd myac User Ddu:ui:ff:closeFilterWindow call s:ddu_ff_filter_cleanup()
function s:ddu_ff_filter_cleanup() abort
  call ddu#ui#ff#restore_cmaps()
endfunction

" }}}
