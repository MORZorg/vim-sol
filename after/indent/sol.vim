" Vim indent file
" Language:     Structured Odd Language
" Maintainer:   Zucchelli Maurizio
" Last Change:  June 01, 2014
" Version:      1.0.0

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetSolIndent()

if exists("*GetSolIndent")
  finish
endif

function! s:GetPrevNonCommentLineNum()

  let SKIP_LINES = '^\s*--'

  let nline = v:lnum
  while nline > 0
    let nline = prevnonblank(nline-1)
    if getline(nline) !~? SKIP_LINES
      break
    endif
  endwhile

  return nline
endfunction

function! GetSolIndent()
  if v:lnum <= 1
    return 0
  endif

  let this_line = getline(v:lnum)
  let prev_codeline_num = s:GetPrevNonCommentLineNum()
  let prev_codeline = getline(prev_codeline_num)
  let prev_codeline_indent = indent(prev_codeline_num)

  if this_line =~? '\<end\s*[a-zA-Z][a-zA-Z0-9]'
    let matches = matchlist( this_line, '\<end\(\s*[a-zA-Z][a-zA-Z0-9]\)' )
    if this_line =~? '\<' . matches[ 1 ] . '\>'
      return prev_codeline_indent
    else
      return prev_codeline_indent - &sw
    endif
  endif

  if this_line =~? '\<\%(else\|elsif\)\>'
    return prev_codeline_indent - &sw
  endif

  if this_line =~? '\<begin\>'
    if prev_codeline =~? '\<func\>'
      return prev_codeline_indent - &sw
    else
      return prev_codeline_indent - 2 * &sw
    endif
  endif

  if this_line =~? '\<\%(type\|const\|var\)\>'
    if prev_codeline =~? '\<func\>'
      return prev_codeline_indent + &sw
    else
      return prev_codeline_indent - &sw
    endif
  endif

  if prev_codeline =~? '\<else\>'
    if prev_codeline =~? '\<then\>'
      return prev_codeline_indent
    else
      return prev_codeline_indent + &sw
    endif
  endif

  if prev_codeline =~? '\<\%(begin\|then\|do\|func\)\>'
    return prev_codeline_indent + &sw
  endif

  if prev_codeline =~? '\<\%(type\|const\|var\)\>'
    return prev_codeline_indent + &sw
  endif

  return prev_codeline_indent
endfunction
