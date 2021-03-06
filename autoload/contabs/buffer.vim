function! s:open(command, filepath)
  execute a:command . ' ' .  a:filepath
endfunction

function! s:starts_with(prefix, text)
  return stridx(a:text, a:prefix) == 0
endfunction

function! s:is_user_buffer(buffer_number)
  let l:type = getbufvar(a:buffer_number, '&filetype')
  return buflisted(a:buffer_number) && l:type != 'qf' && l:type != ''
endfunction

function! s:format(number, filepath, base_directory)
  let l:formatted_number = '[' . a:number . ']'
  let l:formatted_number = (a:number >= 10 ? '' : ' ') . l:formatted_number

  let l:relative_path = contabs#path#relative(a:base_directory, a:filepath)

  return l:formatted_number . ' ' . l:relative_path
endfunction

function! s:buffers(base_directory)
  let l:buffers = {}
  for l:buffer_number in range(1, bufnr('$'))
    let l:filepath = expand('#'. l:buffer_number . ':p')

    if ! s:is_user_buffer(l:buffer_number)
      continue
    endif

    if ! s:starts_with(a:base_directory, l:filepath)
      continue
    endif

    let l:pretty_entry = s:format(l:buffer_number, l:filepath, a:base_directory)
    let l:buffers[l:pretty_entry] = l:filepath
  endfor

  return l:buffers
endfunction

function! contabs#buffer#select()
  let s:actions = get(g:, 'fzf_action', { 'ctrl-t': 'tabedit',
                                        \ 'ctrl-v': 'vsplit',
                                        \ 'ctrl-x': 'split',
                                        \ 'ctrl-e': 'edit'
                                        \ })

  return contabs#window#open(
  \ 'buffers', s:buffers(getcwd()), funcref('s:open'), [ 'edit', s:actions ])
endfunction
