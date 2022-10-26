let s:fixture = expand('%:p:h').'/fixture.txt'

function s:character_at_cursor()
  return matchstr(getline('.'), '\%'.col('.').'c.')
endfunction


function SetUp()
  execute 'edit!' s:fixture
endfunction


function Test_built_in_percent_motion_still_works()
  normal 1G0f(

  normal %

  call assert_equal(')', s:character_at_cursor())
endfunction


function Test_matchit_still_works()
  normal 8G0
  let b:match_words = '\<if\>:\<end\>'

  normal %

  call assert_equal(10, line('.'))
endfunction


function Test_noop_when_unmatched()
  normal 2G0f'
  let col = getpos('.')[2]

  normal %

  call assert_equal(getpos('.')[2], col)
endfunction


function Test_noremap()
  nmap : ,

  normal 3G0f'
  let col = getpos('.')[2]

  normal %

  call assert_equal('''', s:character_at_cursor())
  call assert_notequal(getpos('.')[2], col)

  unmap :
endfunction


function Test_single_quote_forwards()
  normal 3G0f'
  let col = getpos('.')[2]

  normal %

  call assert_equal('''', s:character_at_cursor())
  call assert_notequal(getpos('.')[2], col)
endfunction


function Test_single_quote_backwards()
  normal 3G$F'
  let col = getpos('.')[2]

  normal %

  call assert_equal('''', s:character_at_cursor())
  call assert_notequal(getpos('.')[2], col)
endfunction


function Test_double_quote_forwards()
  normal 4G0f"
  let col = getpos('.')[2]

  normal %

  call assert_equal('"', s:character_at_cursor())
  call assert_notequal(getpos('.')[2], col)
endfunction


function Test_double_quote_backwards()
  normal 4G$F"
  let col = getpos('.')[2]

  normal %

  call assert_equal('"', s:character_at_cursor())
  call assert_notequal(getpos('.')[2], col)
endfunction


function Test_backtick_forwards()
  normal 5G0f`
  let col = getpos('.')[2]

  normal %

  call assert_equal('`', s:character_at_cursor())
  call assert_notequal(getpos('.')[2], col)
endfunction


function Test_backtick_backwards()
  normal 5G$F`
  let col = getpos('.')[2]

  normal %

  call assert_equal('`', s:character_at_cursor())
  call assert_notequal(getpos('.')[2], col)
endfunction


function Test_pipe_forwards()
  normal 6G0f|
  let col = getpos('.')[2]

  normal %

  call assert_equal('|', s:character_at_cursor())
  call assert_notequal(getpos('.')[2], col)
endfunction


function Test_pipe_backwards()
  normal 6G$F|
  let col = getpos('.')[2]

  normal %

  call assert_equal('|', s:character_at_cursor())
  call assert_notequal(getpos('.')[2], col)
endfunction


function Test_visual_mode_matchit_still_works()
  normal 1Gf(v

  normal %

  call assert_equal(')', s:character_at_cursor())
endfunction


function Test_visual_mode_single_quote_forwards()
  normal 3G0f'v
  let col = getpos('.')[2]

  normal %

  call assert_equal('''', s:character_at_cursor())
  call assert_notequal(getpos('.')[2], col)
endfunction


function Test_visual_mode_single_quote_backwards()
  normal 3G02f'v
  let col = getpos('.')[2]

  normal %

  call assert_equal('''', s:character_at_cursor())
  call assert_notequal(getpos('.')[2], col)
endfunction


function Test_visual_mode_extend_selection_forwards()
  normal 12Gf"v%
  call assert_equal(10, getpos('.')[2])
  call assert_equal(4,  getpos("'<")[2])
  call assert_equal(10, getpos("'>")[2])

  normal f'%
  call assert_equal(20, getpos('.')[2])
  call assert_equal(4,  getpos("'<")[2])
  call assert_equal(20, getpos("'>")[2])
endfunction


function Test_visual_mode_extend_selection_backwards()
  normal 12G$F'v%
  call assert_equal(12, getpos('.')[2])
  call assert_equal(12, getpos("'<")[2])
  call assert_equal(20, getpos("'>")[2])

  normal F"%
  call assert_equal(4,  getpos('.')[2])
  call assert_equal(4,  getpos("'<")[2])
  call assert_equal(20, getpos("'>")[2])
endfunction


function Test_N_percent_motion()
  normal 50%
  call assert_equal(6, line('.'))
endfunction


function Test_operator_pending_bracket_forwards()
  normal 1Gf(d%
  call assert_equal('normal  matching', getline(1))
endfunction


function Test_operator_pending_bracket_backwards()
  normal 1Gf)d%
  call assert_equal('normal  matching', getline(1))
endfunction


function Test_operator_pending_single_quote_forwards()
  normal 3Gf'd%
  call assert_equal('single quote  for me', getline(3))
endfunction


function Test_operator_pending_single_quote_backwards()
  normal 3G2f'd%
  call assert_equal('single quote  for me', getline(3))
endfunction


function Test_operator_pending_double_quote_forwards()
  normal 4Gf"d%
  call assert_equal('double quote  for me', getline(4))
endfunction


function Test_operator_pending_double_quote_backwards()
  normal 4G2f"d%
  call assert_equal('double quote  for me', getline(4))
endfunction


function Test_operator_pending_backtick_forwards()
  normal 5Gf`d%
  call assert_equal('backtick  for me', getline(5))
endfunction


function Test_operator_pending_backtick_backwards()
  normal 5G2f`d%
  call assert_equal('backtick  for me', getline(5))
endfunction


function Test_operator_pending_pipe_forwards()
  normal 6Gf|d%
  call assert_equal('pipe  for me', getline(6))
endfunction


function Test_operator_pending_pipe_backwards()
  normal 6G2f|d%
  call assert_equal('pipe  for me', getline(6))
endfunction
