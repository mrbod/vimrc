" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

let mapleader = ","
let maplocalleader = ","

set undofile
set undodir=~/.vim/undodir

set path+=**
set wildmenu

set backup              " keep a backup file
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching

" indentation
set shiftwidth=4
set softtabstop=4
set expandtab

" execute local .vimrc
set exrc

set spelllang=en_gb
"set spell

if has('mouse')
    set mouse=a
endif

if has("win32")
    let os = "Windows"
else
    let os = substitute(system('uname'), "\n", "", "")
    if os =~ "CYGWIN.*"
        let os = "Cygwin"
    endif
endif

if os == "Cygwin"
    set notermguicolors
else
    set termguicolors
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if has("gui_running")
    syntax on
    set hlsearch
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    if has("win32")
        set guifont=Source\ Code\ Pro\ Semibold:h14
    else
        set guifont=Source\ Code\ Pro\ Semibold\ 14
    endif
elseif &t_Co > 2
    syntax on
    set hlsearch
endif

" Enable file type detection.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
    autocmd!
    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
augroup END

let mapleader=','
if exists(":Tabularize")
    nmap <Leader>Tt :Tabularize /<Tab><CR>
    vmap <Leader>Tt :Tabularize /<Tab><CR>
    nmap <Leader>T= :Tabularize /=<CR>
    vmap <Leader>T= :Tabularize /=<CR>
    nmap <Leader>T: :Tabularize /:\zs<CR>
    vmap <Leader>T: :Tabularize /:\zs<CR>
endif

let g:CSextra=''
function! CSUP()
    echo "Updating cscope database"
    execute ':!cscope -b ' . g:CSextra
    execute ':cscope reset'
endfunction

augroup scons_stuff
    autocmd!
    autocmd BufRead,BufNewFile SConstruct set filetype=python
    autocmd BufRead,BufNewFile SConscript set filetype=python
augroup END

augroup arduino_stuff
    autocmd!
    autocmd BufRead,BufNewFile *.pde set filetype=cpp
    autocmd BufRead,BufNewFile *.ino set filetype=cpp
augroup END

autocmd BufRead,BufNewFile *.mnu set filetype=mnu

autocmd BufRead,BufNewFile *.cpy set filetype=asm

augroup c_style_autocmds
    autocmd!
    autocmd FileType c setlocal cinoptions=t0,g0,l1,N-s
    autocmd FileType cpp setlocal cinoptions=t0,g0,l1,N-s,j1
    " handle lambda correctly
    " setlocal cino=j1,(0,ws,Ws
    " cscope stuff
    autocmd FileType c nnoremap <Leader>u :execute 'call CSUP()'<cr>
    autocmd FileType cpp nnoremap <Leader>u :execute 'call CSUP()'<cr>
augroup END

augroup asm_stuff
    autocmd FileType asm setlocal shiftwidth=8
    autocmd FileType asm setlocal softtabstop=8
    autocmd FileType asm setlocal noexpandtab
augroup END

augroup fastcad_stuff
    autocmd!
    "let fcw_cmd = '%!fcw_dump -T -x -v -v'
    "let fcw_cmd = '%!fcw_dump -v -v | sed "s/\s*\(.*ERLen [0-9]*\).*/\1/"'
    let fcw_cmd = '%!fcw_dump -v -v'
    "let fcw_cmd = '%!fcw_dump -v | sed "s/, Tag [0-9]\+//"'
    "let fcw_cmd = '%!fcw_dump'
    autocmd BufReadPre,FileReadPre *.fcw set bin
    autocmd BufReadPost,FileReadPost *.fcw execute fcw_cmd
    autocmd BufReadPost,FileReadPost *.fcw set readonly
    autocmd BufReadPre,FileReadPre *.fct set bin
    autocmd BufReadPost,FileReadPost *.fct execute fcw_cmd
    autocmd BufReadPost,FileReadPost *.fct set readonly
augroup END

" Make vim work with the 'crontab -e' command
set backupskip+=/var/spool/cron/*

set scrolloff=0
let dircolors_is_slackware = 1
autocmd CompleteDone * pclose

" for clang_complete
"let g:clang_library_path='/usr/bin/cygclang-8.dll'

set suffixes=.bak,~,.o,.pyc,.info,.swp,.obj,.map,.lst,.size,.d,.zip,.hex,.elf,.exe
let g:ycm_use_clangd = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'

let g:pymode = 0
let g:pymode_folding = 0

let g:ctrlp_custom_ignore = {'dir': '\v[\/]\.(git|hg|svn)$', 'file': '\v\.(exe|dll|obj|sbr)$'}
let g:ctrlp_mruf_case_sensitive = 0

execute pathogen#infect()
execute pathogen#helptags()

function! MyStatusLine()
    return '%.30f%m%r %y%=%B %3c-%-3v %l/%L'
endfunction

set laststatus=2
set statusline=%!MyStatusLine()

" TDD
augroup tdd_style_autocmds
    autocmd!
    autocmd FileType python nnoremap <F12> :!nosetests<cr>
augroup END

" stop using arrow keys
" noremap <Up> <Nop>
" noremap <Down> <Nop>
" noremap <Left> <Nop>
" noremap <Right> <Nop>
" open c/cpp header
nnoremap <leader>h :execute "edit " . fnameescape(substitute(expand('%'), '\.c\(pp\)\?$', '.h', ''))<cr><cr>
" create c/cpp header cruft
"nnoremap <leader>H GO#ifndef
" underline headings for example
nnoremap <leader><leader>= yyp:s/./=/g<cr>:nohlsearch<cr>
nnoremap <leader><leader>- yyp:s/./-/g<cr>:nohlsearch<cr>
inoremap <leader>= yyp:s/./=/g<cr>:nohlsearch<cr>o
inoremap <leader>- yyp:s/./-/g<cr>:nohlsearch<cr>o
" soft wrapped line movement
"nnoremap j gj
"nnoremap k gk
" previous buffer
"nnoremap <C-e> :e#<CR>
nnoremap <C-e> <c-^>
" buffer movement
nnoremap <C-S-n> :bprev<cr>
nnoremap <C-n> :bnext<cr>
" window movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>w
nnoremap <C-k> <C-w>W
nnoremap <C-l> <C-w>l
" callgraph
nnoremap <leader>C :!callgraph <C-R><C-W> *.c *.cpp *.h \| dot -Tx11<CR>
" quickfix shortcuts
if &diff
	nnoremap <F4> :norm ]c<CR>
	nnoremap [1;2S :norm [c<CR>
else
	nnoremap <F4> :cnext<CR>
	nnoremap <c-F4> :clast<CR>
	nnoremap [1;5S :clast<CR>
	nnoremap [1;2S :cprev<CR>
	nnoremap <F16> :cprev<CR>
	nnoremap [1;6S :cfirst<CR>
endif
" execute current buffer
nnoremap <F5> :!%<cr>
autocmd FileType c nnoremap <F5> :make test<CR>
autocmd FileType cpp nnoremap <F5> :make test<CR>
nnoremap <F7> :make<CR>
nnoremap <F5> :make test<CR>
nnoremap <F9> :YcmCompleter FixIt
" tag next/prev
nnoremap <leader>t :tag <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>n :tnext<CR>
nnoremap <leader>p :tprev<CR>
" turn of hilight
nnoremap <space> :nohlsearch<cR>
" set executable bit
nnoremap <leader>x :!chmod +x %<cr>
" upper/lower case
inoremap <c-u> <esc>viwUi
inoremap <c-l> <esc>viwui
" goto beginning/end
inoremap <c-b> <esc>bi
inoremap <c-e> <esc>ea
" edit ~/.vimrc
nnoremap <leader>rc :split $MYVIMRC<CR>
nnoremap <leader>rcs :source $MYVIMRC<CR>
nnoremap <leader>rcl :split .vimrc<CR>
nnoremap <leader>rcls :source .vimrc<CR>
" source current buffer
nnoremap <leader>bs :source %<CR>
" quote word
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
inoremap <leader>" hviw<esc>a"<esc>hbi"<esc>lela
inoremap <leader>' hviw<esc>a'<esc>hbi'<esc>lela
" inoremap <esc> <nop>
inoremap <M-Space> <esc>
" split open previous buffer
nnoremap <leader>op :execute "below split " . bufname("#")<CR>
" grep word under cursor
let g:CGrepFiles=" --include='*.h' --include='*.c' --include='*.cpp' "
function! GitGrep(word)
    let tmpf = tempname()
    let cmd = '!git grep -E ' . a:word . ' 2>/dev/null | tr -d "\r" | tee ' . tmpf
    execute cmd
    let ef = &errorformat
    let &errorformat = &grepformat
    let &errorfile = tmpf
    cfile
    let &errorformat = ef
    copen
    execute '!rm -f ' . tmpf
    echo cmd
endfunction
function! OldGitGrep(word)
    let m = &grepprg
    let &grepprg = 'git grep -E $* | tr -d "\r"'
    execute "grep " . a:word
    copen
    let &grepprg = m
endfunction
command! -nargs=1 GG :call GitGrep(<q-args>)
nnoremap <leader><leader>g :execute "GG -w " . shellescape(expand("<cword>"))<cr><cr><cr>
nnoremap <leader><leader>y :execute "YcmCompleter GoToDefinition"<cr><cr><cr>
nnoremap <leader>q :execute "grep -w -r " . g:CGrepFiles . shellescape(expand("<cword>")) . " ."<CR>
nnoremap <leader><leader>p :execute "GG -i '^[[:space:]]*" . shellescape(expand("<cword>")) . "[[:space:]]\\+proc\\>'"<cr><cr><cr>
"nnoremap <leader>q :execute "silent grep! -r " . g:CGrepFiles . shellescape(expand("<cword>")) . " ."<CR>:copen<CR>
" indent buffer
nnoremap <leader>= gg=G''zz
" search for full line
nnoremap <leader>* 0wy$/\V<c-r>=escape(@", '/\')<cr><cr><cr>
" move selection
vnoremap J :m '>+1<CR>gv
vnoremap K :m '<-2<CR>gv
nnoremap <leader>l :execute "echo " . len(expand("<cword>")) . ""<cr>

map <leader><leader>d :set background=dark<cr>
map <leader><leader>l :set background=light<cr>

map <leader><leader>f :pyf /home/per/bin/clang-format.py<cr>
imap <leader><leader>f <c-o>:pyf /home/per/bin/clang-format.py<cr>

function! Pandoc()
    execute "!pandoc -f markdown -t html % | xsel"
endfunction

runtime colorscheme

