" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

let mapleader = ","
let maplocalleader = ","

set backup              " keep a backup file
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching

if has('mouse')
  set mouse=a
endif

if !has('nvim')
    set history=500          " keep X lines of command line history
    set t_Co=256
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
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
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

augroup c_style_autocmds
    autocmd!
    autocmd FileType c setlocal cinoptions=:0t0g0l1
    autocmd FileType cpp setlocal cinoptions=:0t0g0l1
    " cscope stuff
    autocmd FileType c nnoremap <Leader>u :execute 'call CSUP()'<cr>
    autocmd FileType cpp nnoremap <Leader>u :execute 'call CSUP()'<cr>
augroup END

" Make vim work with the 'crontab -e' command
set backupskip+=/var/spool/cron/*

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                  \ | wincmd p | diffthis
endif

" indentation
set shiftwidth=4
set softtabstop=4
set expandtab

" execute local .vimrc
set exrc

autocmd CompleteDone * pclose

let dircolors_is_slackware = 1

function! SetCursorColour()
    if &term =~ "xterm\\|rxvt"
        " use an orange cursor in insert mode
        let &t_SI = "\<Esc>]12;orange\x7"
        " use a red cursor otherwise
        let &t_EI = "\<Esc>]12;red\x7"
        silent !echo -ne "\033]12;red\007"
        " reset cursor when vim exits
        autocmd VimLeave * silent !echo -ne "\033]112\007"
        " use \003]12;gray\007 for gnome-terminal
    endif
endfunction
" call SetCursorColour()

set suffixes=.bak,~,.o,.pyc,.info,.swp,.obj,.map,.lst,.size,.d,~,.zip,.hex,.o,.elf
let g:ycm_show_diagnostics_ui = 0

let g:pymode = 0
let g:pymode_folding = 0

if has("win32") || (os == "Cygwin")
    let g:pathogen_disabled=["YouCompleteMe"]
endif

execute pathogen#infect()
execute pathogen#helptags()

if has('nvim')
    set clipboard+=unnamed
    " let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
endif

set laststatus=2

" TDD
augroup tdd_style_autocmds
    autocmd!
    autocmd FileType python nnoremap <F12> :!nosetests<cr>
augroup END

let g:lightline = {'colorscheme': 'wombat'}

" execute current buffer
nnoremap <F5> :!%<cr>
" open c/cpp header
nnoremap <leader>h :execute "edit " . fnameescape(substitute(expand('%'), '\.c\(pp\)\?$', '.h', ''))<cr><cr>
" underline headings for example
nnoremap <leader>= yyp:s/./=/g<cr>:nohlsearch<cr>
nnoremap <leader>- yyp:s/./-/g<cr>:nohlsearch<cr>
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
nnoremap <leader><leader>g yiw:grep <c-r>" *<cr>
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
nnoremap <leader>q :execute "silent grep! -R " . shellescape(expand("<cword>")) . " ."<CR>:copen<CR>
" indent buffer
nnoremap <leader>= gg=G''zz

runtime colorscheme
