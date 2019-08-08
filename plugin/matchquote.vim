scriptencoding utf-8

if exists("g:loaded_matchquote") || &cp
  finish
endif
let g:loaded_matchquote = 1

if has('nvim')
  let loaded_matchit = 1
endif

" Different versions of the matchit plugin map % to
" either a <SID> function or a <Plug> function.
"
"     nnoremap <silent> % :<C-U>call <SID>Match_wrapper('',1,'n') <CR>
"     nmap <silent> % <Plug>MatchitNormalForward
"     nmap <silent> % <Plug>(MatchitNormalForward)
"
let s:matchit_n_rhs = maparg('%', 'n')
let s:matchit_x_rhs = maparg('%', 'x')

if s:matchit_n_rhs =~# 'Match_wrapper'
  " Make the function easier to call ourselves.
  let s:matchit_n_rhs = s:matchit_n_rhs[6:]  " drop leading :<C-U>
  let s:matchit_n_rhs = substitute(s:matchit_n_rhs, '<CR>', '', '')  " drop trailing <CR>
endif

if s:matchit_n_rhs =~# '<Plug>'
  " drop <Plug> so we can escape it later
  let s:matchit_n_rhs = s:matchit_n_rhs[6:]
  let s:matchit_x_rhs = s:matchit_x_rhs[6:]
endif


let s:quotes = ['"', '''', '`', '|']


function! s:matchquote(mode)
  let c = s:character_at_cursor()

  if index(s:quotes, c) == -1
    call s:fallback_to_original(a:mode)
    return
  endif

  let num = len(split(getline('.'), c, 1)) - 1
  if num % 2 == 1
    return
  endif

  " is quotation mark under cursor odd or even?
  let col = getpos('.')[2]
  let num = len(split(getline('.')[0:col-1], c, 1)) - 1

  if num % 2 == 0
    execute 'normal!' a:mode == 'n' ? 'F'.c : 'm>F'.c.'m<gvo'
  else
    execute 'normal!' a:mode == 'n' ? 'f'.c : 'm<f'.c.'m>gv'
  endif
endfunction


function! s:fallback_to_original(mode)
  " Matchit plugin inactive.
  if empty(s:matchit_n_rhs)
    if a:mode == 'n'
      normal! %
    else
      normal! gv%
    endif
    return
  endif

  if s:matchit_n_rhs =~# 'Match_wrapper'
    if a:mode == 'n'
      execute s:matchit_n_rhs
    else
      execute s:matchit_x_rhs
    endif
    return
  endif

  if a:mode == 'n'
    execute "normal \<Plug>".s:matchit_n_rhs
  else
    execute "normal gv\<Plug>".s:matchit_x_rhs
  endif
endfunction


" Capture character under cursor in a way that works with multi-byte
" characters.  Credit to http://stackoverflow.com/a/23323958/151007.
function! s:character_at_cursor()
  return matchstr(getline('.'), '\%'.col('.').'c.')
endfunction


nmap <silent> %      :call <SID>matchquote('n')<CR>
xmap <silent> % :<C-U>call <SID>matchquote('x')<CR>

