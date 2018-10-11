let mapleader = "\<Space>"

let g:contabs#project#locations = [
  \ { 'path': '~', 'depth': 1, 'git_only': 0 },
  \]

command! -nargs=1 -complete=dir EP call contabs#project#edit(<q-args>)
command! -nargs=1 -complete=dir TP call contabs#project#tabedit(<q-args>)

nnoremap <silent> <Leader>f :<C-u>Files<CR><C-u>
nnoremap <silent> <Leader>p :call contabs#project#select()<CR>
nnoremap <silent> <Leader>b :call contabs#buffer#select()<CR>