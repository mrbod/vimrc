" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set encoding=utf-8

let mapleader = ","
let maplocalleader = ","

set undofile
set undodir=~/.vim/undodir

set path+=**
set wildmenu
set wildmode=full
set wildignore=*~

augroup syscheck
    let uname = substitute(system('uname'),'\n','','')
    let rc = "~/.vim/vimrc"
    if uname == 'Linux'
        let lines = readfile("/proc/version")
        if lines[0] =~ "icrosoft"
            let rc = rc . ".wsl"
        else
            let rc = rc . "linux"
        endif
    else
        let rc = rc . "linux"
    endif
    exec "source " . rc
augroup END

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

autocmd BufRead,BufNewFile *.mnu set filetype=mnu

autocmd BufRead,BufNewFile *.cpy set filetype=asm
autocmd BufRead,BufNewFile *.inc set filetype=asm

augroup c_style_autocmds
    autocmd!
    autocmd FileType c setlocal cinoptions=t0g0l1N-s
    autocmd FileType cpp setlocal cinoptions=t0g0l1N-s
    " cscope stuff
    autocmd FileType c nnoremap <Leader>u :execute 'call CSUP()'<cr>
    autocmd FileType cpp nnoremap <Leader>u :execute 'call CSUP()'<cr>
augroup END

augroup xlsx_stuff
    autocmd!
    let g:zipPlugin_ext = '*.zip'
    fun! XLSXRead(fname)
      let temp = tempname()
      let fn   = expand('%:p')
      let xlsx_cmd = '/home/per/bin/xlsx'
      let cmd = "silent !" . xlsx_cmd . " " . shellescape(a:fname,1) . " > " . temp
      "let cmd = "silent !" . xlsx_cmd . " " . shellescape(fnameescape(a:fname),1) . " > " . temp
      echo cmd
      exe cmd
      sil exe 'keepalt file '.temp
      sil keepjumps e!
      sil exe 'keepalt file '.fnameescape(fn)
      call delete(temp)
      set nomod
      set readonly
    endfun
    autocmd BufReadPost,FileReadPost *.xlsx call XLSXRead(expand("<amatch>"))
    autocmd BufReadPost,FileReadPost *.xlsm call XLSXRead(expand("<amatch>"))
augroup END

augroup fastcad_stuff
    autocmd!
    "let fcw_cmd = '%!fcw_dump -x -v -v'
    let fcw_cmd = '%!fcw_dump -T -v -v'
    "let fcw_cmd = '%!fcw_dump -x -v'
    "let fcw_cmd = '%!fcw_dump -v'
    "let fcw_cmd = '%!fcw_dump'
    "let fcw_cmd = '%!fcw_dump -T'
    autocmd BufReadPre,FileReadPre *.fcw set bin
    autocmd BufReadPost,FileReadPost *.fcw execute fcw_cmd
    autocmd BufReadPost,FileReadPost *.fcw set readonly
    autocmd BufReadPre,FileReadPre *.fc$ set bin
    autocmd BufReadPost,FileReadPost *.fc$ execute fcw_cmd
    autocmd BufReadPost,FileReadPost *.fc$ set readonly
    autocmd BufReadPre,FileReadPre *.fct set bin
    autocmd BufReadPost,FileReadPost *.fct execute fcw_cmd
    autocmd BufReadPost,FileReadPost *.fct set readonly
augroup END

" Make vim work with the 'crontab -e' command
set backupskip+=/var/spool/cron/*

set scrolloff=0
let dircolors_is_slackware = 1
"autocmd CompleteDone * pclose

set suffixes=.bak,~,.o,.pyc,.info,.swp,.obj,.map,.lst,.size,.d,.zip,.hex,.elf,.exe

" also check vimrc.wsl
let g:ycm_show_diagnostics_ui = 1
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_server_keep_logfiles = 0
"let g:ycm_server_log_level = 'debug'
let g:ycm_auto_hover = ''

let g:pymode = 0
let g:pymode_folding = 0

function! MyStatusLine()
    return '%.30F%m%r %y%=%B %3c-%-3v %l/%L'
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
" underline headings for example
nnoremap <leader><leader>= yyp:s/./=/g<cr>:nohlsearch<cr>
nnoremap <leader><leader>- yyp:s/./-/g<cr>:nohlsearch<cr>
inoremap <leader>= yyp:s/./=/g<cr>:nohlsearch<cr>o
inoremap <leader>- yyp:s/./-/g<cr>:nohlsearch<cr>o
" soft wrapped line movement
"nnoremap j gj
"nnoremap k gk
" buffer movement
nnoremap <c-¨> <c-^>
nnoremap <C-S-n> :bprev<cr>
nnoremap <C-n> :bnext<cr>
" callgraph
nnoremap <leader>C :!callgraph <C-R><C-W> *.c *.cpp *.h \| dot -Tx11<CR>
" vimdiff mappings
if &diff
    nnoremap dj ]c
    nnoremap dk [c
endif
" quickfix shortcuts
nnoremap <F4> :cnext<CR>
nnoremap <c-F4> :clast<CR>
nnoremap [1;5S :clast<CR>
nnoremap [1;2S :cprev<CR>
nnoremap <F16> :cprev<CR>
nnoremap [1;6S :cfirst<CR>
" execute current buffer
nnoremap <F5> :!%<cr>
nnoremap <F7> :make<CR>
nnoremap <F9> :YcmCompleter FixIt<cr>
" find tag
nnoremap <leader>t :exec "tag " . expand("<cword>")<cr>
" tag next/prev
nnoremap <leader>n :tnext<CR>
nnoremap <leader>p :tprev<CR>
" turn of hilight
nnoremap <space> :nohlsearch<cR>
" set executable bit
nnoremap <leader>x :!chmod +x %<cr>
" edit ~/.vimrc
nnoremap <leader>rc :split $MYVIMRC<CR>
nnoremap <leader>rcs :source $MYVIMRC<CR>
nnoremap <leader>rcl :split .vimrc<CR>
nnoremap <leader>rcls :source .vimrc<CR>
" quote word
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
inoremap <leader>" hviw<esc>a"<esc>hbi"<esc>lela
inoremap <leader>' hviw<esc>a'<esc>hbi'<esc>lela
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
endfunction
command! -nargs=1 GG :call GitGrep(<q-args>)
nnoremap <leader><leader>g :execute "GG -w " . shellescape(expand("<cword>"))<cr><cr><cr>
nnoremap <leader>q :execute "grep -w -r " . g:CGrepFiles . shellescape(expand("<cword>")) . " ."<CR>
"nnoremap <leader>q :execute "silent grep! -r " . g:CGrepFiles . shellescape(expand("<cword>")) . " ."<CR>:copen<CR>
" indent buffer
nnoremap <leader>= gg=G''zz
" move selection
" vnoremap J :m '>+1<CR>gv
" vnoremap K :m '<-2<CR>gv
nnoremap <leader>l :execute "echo " . len(expand("<cword>")) . ""<cr>

nnoremap <leader><leader>d :set background=dark<cr>
nnoremap <leader><leader>l :set background=light<cr>

noremap <leader><leader>f :py3f /home/per/bin/clang-format.py<cr>
inoremap <leader><leader>f <c-o>:py3f /home/per/bin/clang-format.py<cr>

" fzf
nnoremap _ :FZF<cr>

function! Pandoc()
    execute "w !pandoc -f commonmark -t html | xsel"
    "execute "!pandoc -f commonmark_x -t html % | xsel"
    "execute "!pandoc -f markdown -t html % | xsel"
endfunction
nnoremap <leader>pd :call Pandoc()<cr>

function! YcmTag()
	" Store where we're jumping from before we jump.
	let tag = expand('<cword>')
	let pos = [bufnr()] + getcurpos()[1:]
	let item = {'bufnr': pos[0], 'from': pos, 'tagname': tag}
	execute('YcmCompleter GoTo ' . tag)
	let new_pos = [bufnr()] + getcurpos()[1:]
        let res = new_pos != pos
	if res
		" Jump was successful, write previous location to tag stack.
		let winid = win_getid()
		let stack = gettagstack(winid)
		let stack['items'] = [item]
		call settagstack(winid, stack, 't')
	endif
endfunction

"nnoremap <leader>y :execute "YcmCompleter GoToDefinition"<cr>
nnoremap <silent> <leader>y :call YcmTag()<cr>

runtime colorscheme

