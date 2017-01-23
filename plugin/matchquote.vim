scriptencoding utf-8

if exists("g:loaded_matchquote") || &cp
  finish
endif
let g:loaded_matchquote = 1

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
  normal! %
endfunction

" Capture character under cursor in a way that works with multi-byte
" characters.  Credit to http://stackoverflow.com/a/23323958/151007.
function! s:character_at_cursor()
  return matchstr(getline('.'), '\%'.col('.').'c.')
endfunction

nmap <silent> % :call <SID>matchquote()<CR>

