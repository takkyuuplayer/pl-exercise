let g:quickrun_config['perl.unit'] = {}
let g:quickrun_config['perl.unit']['command'] = 'make'
let g:quickrun_config['perl.unit']['cmdopt'] = 'perl'
let g:quickrun_config['perl.unit']['exec'] = '%c %o SRC=@%'
let g:quickrun_config['perl.unit']['hook/cd/enable'] = 1
let g:quickrun_config['perl.unit']['hook/cd/directory'] = '$PWD'

let g:quickrun_config['perl'] = {}
let g:quickrun_config['perl']['command'] = 'make'
let g:quickrun_config['perl']['cmdopt'] = 'perl'
let g:quickrun_config['perl']['exec'] = '%c %o SRC=@%'
let g:quickrun_config['perl']['hook/cd/enable'] = 1
let g:quickrun_config['perl']['hook/cd/directory'] = '$PWD'

map ,ct <Esc>:%! perltidy -se<CR>
map ,ctv <Esc>:'<,'>! perltidy -se<CR>

