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

let s:SKIP_LINES = '^\s*--'
let s:special_indent = &sw

function! s:GetPrevNonCommentLineNum()

  let nline = v:lnum
  while nline > 0
    let nline = prevnonblank(nline-1)
    if getline(nline) !~? s:SKIP_LINES
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

  if this_line !~? s:SKIP_LINES
    if this_line =~? '\<end\s*[a-zA-Z][a-zA-Z0-9]'
      let matches = matchlist( this_line, '\<end\s*\([a-zA-Z][a-zA-Z0-9]\)' )
      if this_line =~? '\<' . matches[ 1 ] . '\>'
        break
      else
        return prev_codeline_indent - &sw
      endif
    endif

    if this_line =~? '\<\%(else\|elsif\)\>'
      if this_line =~? '\<if\>'
        break
      else
        return prev_codeline_indent - &sw
      endif
    endif

    if this_line =~? '\<begin\>'
      if prev_codeline =~? '\<func\>'
        return prev_codeline_indent
      else
        return prev_codeline_indent - s:special_indent - &sw
      endif
    endif

    if this_line =~? '\<\%(type\|const\|var\|func\)\>'
      if prev_codeline =~? '\<func\>'
        return prev_codeline_indent + &sw
      else
        return prev_codeline_indent - s:special_indent
      endif
    endif
  endif

  if prev_codeline =~? '\<else\>'
    if prev_codeline =~? '\<then\>'
      break
    else
      return prev_codeline_indent + &sw
    endif
  endif

  if prev_codeline =~? '\<\%(begin\|then\|do\|func\)\>'
    if prev_codeline =~? '\<begin\>' && prev_codeline !~? '\<end\s+[a-zA-Z][a-zA-Z0-9]'
      return prev_codeline_indent + &sw
    elseif prev_codeline =~? '\<then\>' && prev_codeline !~? '\<endif\>'
      return prev_codeline_indent + &sw
    elseif prev_codeline =~? '\<do\>' && prev_codeline !~? '\<end\%(for\|while\)\>'
      return prev_codeline_indent + &sw
    elseif prev_codeline =~? '\<func\>'
      return prev_codeline_indent + &sw
    endif
  endif

  if prev_codeline =~? '\<\%(type\|const\|var\)\>'
    " If the section has an in-line declaration, align everything to it.
    " otherwise use the usual shift.
    if prev_codeline =~? ';'
      " TODO Could be better using the length
      " if prev_codeline =~? '\<type\>'
      "   let s:special_indent = 4
      " elseif prev_codeline =~? '\<const\>'
      "   let s:special_indent = 5
      " elseif prev_codeline =~? '\<var\>'
      "   let s:special_indent = 3
      " endif
      let s:special_indent = 5
      let s:special_indent += &sw - s:special_indent % &sw
    else
      let s:special_indent = &sw
    endif
    return prev_codeline_indent + s:special_indent
  endif

  return prev_codeline_indent
endfunction

