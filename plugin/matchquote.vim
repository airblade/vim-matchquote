scriptencoding utf-8

if exists("g:loaded_matchquote") || &cp
  finish
endif
let g:loaded_matchquote = 1


" Different versions of the matchit plugin map % to
" either a <SID> function or a <Plug> function.
"
"     nnoremap <silent> % :<C-U>call <SID>Match_wrapper('',1,'n') <CR>
"     nmap <silent> % <Plug>MatchitNormalForward
"     nmap <silent> % <Plug>(MatchitNormalForward)
"
let s:matchit_rhs = maparg('%', 'n')

if s:matchit_rhs =~# 'Match_wrapper'
  " Make the function easier to call ourselves.
  let s:matchit_rhs = s:matchit_rhs[6:]  " drop leading :<C-U>
  let s:matchit_rhs = substitute(s:matchit_rhs, '<CR>', '', '')  " drop trailing <CR>
endif

if s:matchit_rhs =~# '<Plug>'
  let s:matchit_rhs = s:matchit_rhs[6:]  " drop <Plug> so we can escape it later
endif

let s:quotes = ['"', '''', '`', '|']

function! s:matchquote()
  let c = s:character_at_cursor()
  if index(s:quotes, c) > -1
    " count quotation marks in line
    let num = len(split(getline('.'), c, 1)) - 1
    if num % 2 == 0  " only proceed if quotation marks are balanced
      " is quotation mark under cursor odd or even?
      let col = getpos('.')[2]
      let num = len(split(getline('.')[0:col-1], c, 1)) - 1
      if num % 2 == 0
        execute "normal! F".c
      else
        execute "normal! f".c
      endif
    endif
    return
  endif

  if s:matchit_rhs =~# 'Match_wrapper'
    execute s:matchit_rhs
  elseif empty(s:matchit_rhs)
    " Matchit plugin not loaded.
    normal! %
  else
    execute "normal \<Plug>".s:matchit_rhs
  endif
endfunction

" Capture character under cursor in a way that works with multi-byte
" characters.  Credit to http://stackoverflow.com/a/23323958/151007.
function! s:character_at_cursor()
  return matchstr(getline('.'), '\%'.col('.').'c.')
endfunction

nmap <silent> % :call <SID>matchquote()<CR>

