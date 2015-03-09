" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

let mapleader = ","
let maplocalleader = ","

set backup		" keep a backup file
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

if has('mouse')
  set mouse=a
endif

if has("win32")
    set t_Co=256
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
        colorscheme slate
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

execute pathogen#infect()

set laststatus=2
set statusline=%.30F
set statusline+=%m
set statusline+=%r
set statusline+=\ %y
set statusline+=%=
set statusline+=%l
set statusline+=/
set statusline+=%L

" soft wrapped line movement
nnoremap j gj
nnoremap k gk
" previous buffer
nnoremap <C-e> :e#<CR>
" buffer movement
nnoremap <C-N> :bprev
nnoremap <C-n> :bnext
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
nnoremap [1;6S :cfirst<CR>
nnoremap <F7> :make<CR>
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
nnoremap <leader>2 viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
" inoremap <esc> <nop>
inoremap <M-Space> <esc>
" split open previous buffer
nnoremap <leader>op :execute "below split " . bufname("#")<CR>
" grep word under cursor
nnoremap <leader>q :execute "silent grep! -R " . shellescape(expand("<cword>")) . " ."<CR>:copen<CR>

