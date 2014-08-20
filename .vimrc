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

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
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
    autocmd FileType c nnoremap <Leader>u :execute 'call CSUP()'
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

colorscheme koehler

" indentation
set shiftwidth=4
set softtabstop=4
set expandtab

" quickfix shortcuts
noremap <F4> :cn<CR>
noremap [1;2S :cp<CR>
noremap <F9> :make<CR>

" tag next/prev
noremap <Leader>n :tnext<CR>
noremap <Leader>p :tprev<CR>

" execute local .vimrc
set exrc

let dircolors_is_slackware = 1

" pathogen
"execute pathogen#infect()

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

let VCSCommandMapPrefix='<Leader><Leader>'

set laststatus=2
set statusline=%.30F
set statusline+=%m
set statusline+=%r
set statusline+=\ %y
set statusline+=%=
set statusline+=%l
set statusline+=/
set statusline+=%L

" upper/lower case
inoremap <c-u> <esc>viwUi
inoremap <c-l> <esc>viwui
" goto start/end
inoremap <c-e> <esc>ea
inoremap <c-b> <esc>bi
" edit ~/.vimrc
nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>lev :split .vimrc<CR>
nnoremap <leader>lsv :source .vimrc<CR>
" quote word
nnoremap <leader>2 viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
" inoremap <esc> <nop>
inoremap kk <esc>

