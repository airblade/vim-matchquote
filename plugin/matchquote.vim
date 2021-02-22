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
"     vnoremap <silent> % :<C-U>call <SID>Match_wrapper('',1,'n') <CR>m'gv``
"     nmap <silent> % <Plug>MatchitNormalForward
"     nmap <silent> % <Plug>(MatchitNormalForward)
"
let s:matchit_n_rhs = maparg('%', 'n')
let s:matchit_x_rhs = maparg('%', 'x')

if s:matchit_n_rhs =~# 'Match_wrapper'
  " Make the function easier to call ourselves.
  let s:matchit_n_rhs = s:matchit_n_rhs[6:]  " drop leading :<C-U>
  let s:matchit_n_rhs = substitute(s:matchit_n_rhs, '<CR>', '', '')  " drop trailing <CR>

  let s:matchit_x_rhs = s:matchit_x_rhs[6:]  " drop leading :<C-U>
  let s:matchit_x_rhs = substitute(s:matchit_x_rhs, '\s\?<CR>', '', '')  " drop trailing <CR>
  if s:matchit_x_rhs[-1:] != ')'
    let s:matchit_x_rhs = substitute(s:matchit_x_rhs, ')', ') | normal! ', '')
  endif
endif

if s:matchit_n_rhs =~# '<Plug>'
  " drop <Plug> so we can escape it later
  let s:matchit_n_rhs = s:matchit_n_rhs[6:]
  let s:matchit_x_rhs = s:matchit_x_rhs[6:]
endif


let s:quotes = ['"', '''', '`', '|']


function! s:matchquote(mode)
  if a:mode == 'x'
    normal! gv
  endif
  let c = s:character_at_cursor()
  execute "normal! \<Esc>"

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
    execute 'normal!' a:mode == 'n' ? 'F'.c : 'F'.c.'m>gv'
  else
    execute 'normal!' a:mode == 'n' ? 'f'.c : 'f'.c.'m>gv'
  endif
endfunction


" NOTE: see here for an alternative way to invoke an overridden mapping:
" https://vi.stackexchange.com/a/27763/1643
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


nnoremap <silent> %      :call <SID>matchquote('n')<CR>
xnoremap <silent> % :<C-U>call <SID>matchquote('x')<CR>

