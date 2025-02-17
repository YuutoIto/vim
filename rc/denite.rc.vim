" Config:

" Set Default Options:
call denite#custom#option('default', {
  \ 'filter_updatetime': 150,
  \ })

function! s:set_denite_win(height_percent, width_percent) abort
  let denite_win_width = u#clamp(&columns * a:width_percent, v:numbermin, 150)
  let denite_win_col_pos = (&columns - denite_win_width) / 2
  let denite_win_height = u#clamp(&lines * a:height_percent, v:numbermin, 60)
  let denite_win_row_pos = (&lines - denite_win_height) / 2

  call denite#custom#option('default', 'winwidth',  float2nr(denite_win_width))
  call denite#custom#option('default', 'wincol',    float2nr(denite_win_col_pos))
  call denite#custom#option('default', 'winheight', float2nr(denite_win_height))
  call denite#custom#option('default', 'winrow',    float2nr(denite_win_row_pos))
endfunction

" Set Floating Window Size:
call s:set_denite_win(0.7, 0.8)
au myac VimEnter,VimResized * call s:set_denite_win(0.7, 0.8)

" Custom Actions:
call denite#custom#action('_', 'show_context', { context -> Debug(context) })
call denite#custom#action('source/neosnippet', 'expand', { context -> s:action_neosnippet_expand(context)})

function! s:action_neosnippet_expand(context)
  call denite#do_action(a:context, 'append', a:context['targets'])
  exec "normal \<Plug>(neosnippet_expand)"
endfunction

" Default Actions:
call denite#custom#source('neosnippet', 'default_action', 'expand')

" Filters:
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs', [ '.git/', '.ropeproject/', '__pycache__/', 'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])
call denite#custom#filter('matcher/clap', 'clap_path', expand('$CACHE/dein') . '/repos/github.com/liuchengxu/vim-clap')

" Matchers:
" let s:default_matcher = 'matcher/regexp'
let s:default_matcher = 'matcher/substring'
call denite#custom#source('_', 'matchers', [s:default_matcher])
call denite#custom#source('buffer', 'matchers', [s:default_matcher, 'matcher/ignore_current_buffer'])
call denite#custom#source('file/rec', 'matchers', [s:default_matcher, 'matcher/hide_hidden_files'])

" Sorters:
" 空にすればファイル順になるソースもある(lineと同じ)
call denite#custom#source('grep', 'sorters', [])
call denite#custom#source('command_history', 'sorters', [])
call denite#custom#source('file/rec', 'sorters', ['sorter/path'])
call denite#custom#source('file_mru', 'sorters', ['sorter/oldfiles'])

" Converters:
call denite#custom#source('file/old', 'converters', ['converter/relative_word'])

" Aliases:
" call denite#custom#alias('source', 'file/rec/git', 'file/rec')

" Vars:
" call denite#custom#var('file/rec/git', 'command', ['git', 'ls-files', '-co', '--exclude-standard'])

if executable('rg') " ripgrep
  " https://github.com/BurntSushi/ripgrep
  call denite#custom#var('file/rec',
        \ 'command', ['rg', '--files', '--hidden', '--glob', '!.git', '--color', 'never', '--smart-case', '-P']
        \ )
  " multilineをいい感じに使うために --vimgrep ではなく --columnと--no-headingを使う
  call denite#custom#var('grep', {
        \ 'command': ['rg', '--threads', '0'],
        \ 'default_opts': ['--multiline', '--column', '--no-heading', '--hidden', '--glob=!.git/', '--smart-case', '-P'],
        \ 'recursive_opts': [],
        \ 'final_opts': [],
        \ 'separator': ['--'],
        \ 'max_path_length': 999,
        \ })
endif
