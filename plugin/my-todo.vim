if exists('g:loaded_my_todo')
  finish
endif
let g:loaded_my_todo = 1
let s:todo_add_txt = $HOME.'/todo/todo_add'
let s:todo_edit_txt = $HOME.'/todo/todo_edit'

function! ReloadTodo() abort
  exec '%!t ls'
  exec ':w'
endfunction

function! DoneTodo() abort
  let cursor_line = getline('.')
  let todo_num = split(cursor_line, " ")[0]
  if todo_num == 0
    return
  endif
  exec '!t do '.todo_num
  call ReloadTodo()
endfunction

function! DeleteTodo() abort
  let cursor_line = getline('.')
  let todo_num = split(cursor_line, " ")[0]
  if todo_num == 0
    return
  endif
  exec '!echo "y" | t del '.todo_num
  exec '!t archive'
  call ReloadTodo()
endfunction

function! AddTodo() abort
  exec ':vs '.todo_txt_add
  set filetype=todo_txt_add
endfunction

function! EditTodo() abort
  let cursor_line = getline('.')
  let todo_num = split(cursor_line, " ")[0]
  if todo_num == 0
    return
  endif
  exec ':vs '.todo_edit_txt
  call setline(1, cursor_line)
  set filetype=todo_txt_edit
endfunction

function! SetTodoTxtList() abort
  nnoremap <silent> <buffer> d :call DoneTodo()<CR>
  nnoremap <silent> <buffer> x :call DeleteTodo()<CR>
  nnoremap <silent> <buffer> r :call ReloadTodo()<CR>
  nnoremap <silent> <buffer> e :call EditTodo()<CR>
  nnoremap <silent> <buffer> a :call AddTodo()<CR>
endfunction

function! ShowMyTodo() abort
  new `=tempname()`
  exec '%!t ls'
  exec ':w'
  set filetype=todo_txt_list
endfunction

function! AddTodoTxt() abort
  let lines = getline(0, line('$'))
  for line in lines
    if line == ''
      return
    endif
    exec '!t a '.line
  endfor
  exec ':!rm '.todo_add_txt
endfunction

function! EditTodoTxt() abort
    if getline('.') == ''
      return
    endif
  exec '!t replace '.getline('.')
  exec ':!rm '.todo_edit_txt
endfunction

autocmd FileType todo_txt_list call SetTodoTxtList()
autocmd FileType todo_txt_add autocmd! BufWritePost <buffer> call AddTodoTxt()
autocmd FileType todo_txt_edit autocmd! BufWritePost <buffer> call EditTodoTxt()

command! ShowMyTodo call ShowMyTodo()

