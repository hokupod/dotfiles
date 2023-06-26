set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
if !has('nvim')
  autocmd BufWritePre *.ts call execute('LspDocumentFormatSync --server=efm-langserver')
endif
