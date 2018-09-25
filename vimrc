" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

let mapleader = ","
let maplocalleader = ","

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
set nospell

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

let g:CSextra=''
function! CSUP()
    echo "Updating cscope database"
    execute ':!cscope -b ' . g:CSextra
    execute ':cscope reset'
endfunction

augroup arduino_stuff
    autocmd!
    autocmd BufRead,BufNewFile *.pde set filetype=cpp
    autocmd BufRead,BufNewFile *.ino set filetype=cpp
augroup END

autocmd CompleteDone * pclose

autocmd BufRead,BufNewFile *.cpy set filetype=asm

augroup c_style_autocmds
    autocmd!
    autocmd FileType c setlocal cinoptions=:0t0g0l1N-s
    autocmd FileType cpp setlocal cinoptions=:0t0g0l1N-s
    " cscope stuff
    autocmd FileType c nnoremap <Leader>u :execute 'call CSUP()'<cr>
    autocmd FileType cpp nnoremap <Leader>u :execute 'call CSUP()'<cr>
augroup END

" Make vim work with the 'crontab -e' command
set backupskip+=/var/spool/cron/*

autocmd CompleteDone * pclose

let dircolors_is_slackware = 1

set suffixes=.bak,~,.o,.pyc,.info,.swp,.obj,.map,.lst,.size,.d,.zip,.hex,.elf
let g:ycm_show_diagnostics_ui = 0

let g:pymode = 0
let g:pymode_folding = 0

if has("win32") || (os == "Cygwin")
    let g:pathogen_disabled=["YouCompleteMe"]
endif

execute pathogen#infect()
execute pathogen#helptags()

function! MyStatusLine()
    return '%.30F%m%r %y%=%l/%L'
endfunction

set laststatus=2
"set statusline=%!MyStatusLine()

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
" execute current buffer
nnoremap <F5> :!%<cr>
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
nnoremap <C-e> :e#<CR>
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
nnoremap <F4> :cnext<CR>
nnoremap <c-F4> :clast<CR>
nnoremap [1;5S :clast<CR>
nnoremap [1;2S :cprev<CR>
nnoremap <F16> :cprev<CR>
nnoremap [1;6S :cfirst<CR>
nnoremap <F7> :make<CR>
nnoremap <F9> :YcmCompleter FixIt
" tag next/prev
nnoremap <Leader>n :tnext<CR>
nnoremap <Leader>p :tprev<CR>
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
	let m = &grepprg
	let &grepprg = 'git grep -P $*'
	execute "grep " . a:word
	copen
	let &grepprg = m
endfunction
command! -nargs=1 GG :call GitGrep(<q-args>)
nnoremap <leader><leader>g :execute "GG " . shellescape(expand("<cword>"))<cr><cr>
nnoremap <leader>q :execute "grep -w -r " . g:CGrepFiles . shellescape(expand("<cword>")) . " ."<CR>
"nnoremap <leader>q :execute "silent grep! -r " . g:CGrepFiles . shellescape(expand("<cword>")) . " ."<CR>:copen<CR>
" indent buffer
nnoremap <leader>= gg=G''zz
" move selection
" vnoremap J :m '>+1<CR>gv
" vnoremap K :m '<-2<CR>gv
nnoremap <leader>l :execute "echo " . len(expand("<cword>")) . ""<cr>

runtime colorscheme
