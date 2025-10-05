" Shortcake filetype detection
au BufRead,BufNewFile *.sho set filetype=shortcake

" Set comment string for hyprlang filetype
au FileType shortcake setlocal commentstring=#\ %s
