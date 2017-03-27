let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &compatible
      	set nocompatible
endif
if !isdirectory(s:dein_repo_dir)
	execute '!git clone https://github.com/Shougo/dein.vim.git' s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir
call dein#begin(s:dein_dir)

call dein#add('majutsushi/tagbar')
call dein#add('Shougo/vimfiler')
call dein#add('Shougo/vimproc')
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/unite-outline')
call dein#add('dgryski/vim-godef')
call dein#add('vim-jp/vim-go-extra')
" vim-ft-goは最新版のvimを使えない場合のみ
call dein#end()

if dein#check_install()
	call dein#install()
endif
filetype plugin indent on

" for golang {{{
set path+=$GOPATH/src/**
let g:gofmt_command = 'goimports'
au BufWritePre *.go Fmt
au BufNewFile,BufRead *.go set sw=4 noexpandtab ts=4 completeopt=menu,preview
au FileType go compiler go
" }}}

" VimFilerTree {{{
command! VimFilerTree call VimFilerTree(<f-args>)
function VimFilerTree(...)
    let l:h = expand(a:0 > 0 ? a:1 : '%:p:h')
    let l:path = isdirectory(l:h) ? l:h : ''
    exec ':VimFiler -buffer-name=explorer -split -simple -winwidth=45 -toggle -no-quit ' . l:path
    wincmd t
    setl winfixwidth
endfunction
autocmd! FileType vimfiler call s:my_vimfiler_settings()
function! s:my_vimfiler_settings()
    nmap     <buffer><expr><CR> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
    nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<CR>
    nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<CR>
endfunction

let my_action = {'is_selectable' : 1}
function! my_action.func(candidates)
    wincmd p
    exec 'split '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_split', my_action)

let my_action = {'is_selectable' : 1}
function! my_action.func(candidates)
    wincmd p
    exec 'vsplit '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_vsplit', my_action)
" }}}
