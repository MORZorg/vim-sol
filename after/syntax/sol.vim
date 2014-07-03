" Vim syntax file
" Language:     Structured Odd Language
" Maintainer:   Zucchelli Maurizio
" Last Change:  June 01, 2014
" Version:      1.0.1

if exists("b:current_syntax")
  finish
endif

syn case ignore 

syn keyword solType FUNC CHAR INT REAL STRING BOOL OF
syn keyword solStructure STRUCT VECTOR
syn keyword solTypeDef TYPE VAR CONST
syn keyword solBlock BEGIN END 
syn keyword solConditional IF THEN ENDIF ELSIF ELSE
syn keyword solRepeat WHILE DO ENDWHILE FOR TO ENDFOR FOREACH ENDFOREACH
syn keyword solCommand RETURN READ WRITE RD WR DEFINE ASSIGN BREAK
syn keyword solBool TRUE FALSE

syn match solSymbolOperator "\([()\[\]+*/:.,;=-]\|<=\|>=\|==\|!=\)"
syn match solWordOperator /\<\(AND\|OR\|IN\|NOT\|TOINT\|TOREAL\)\>/
syn match solString "\"\(.\|\n\)\{-}\""
syn match solCharacter "\'.\+\'"
syn match solNumber "\<[0-9]\+"
syn match solFloat "\<[0-9]\+\.[0-9]\+"

syn keyword solTodo contained TODO FIXME XXX NOTE
syn match solComment "--.*$" contains=solTodo

hi def link solTodo           Todo
hi def link solComment        Comment
hi def link solType           Type
hi def link solStructure      Structure
hi def link solTypeDef        TypeDef
hi def link solBlock          Keyword
hi def link solConditional    Conditional
hi def link solRepeat         Repeat
hi def link solCommand        Conditional

hi def link solSymbolOperator Operator
hi def link solWordOperator   Operator
hi def link solBool           Boolean
hi def link solString         String
hi def link solCharacter      Character
hi def link solNumber         Number
hi def link solFloat          Float

let b:current_syntax = "sol"

