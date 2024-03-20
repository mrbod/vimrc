" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set encoding=utf-8

let mapleader = ","
let maplocalleader = ","

set undofile
set undodir=~/.vim/undodir

set backup              " keep a backup file
set backupdir=~/.vim/backup//,.

set path+=**
set wildmenu
set wildmode=full
set wildignore=*~

augroup syscheck
    let uname = substitute(system('uname'),'\n','','')
    if uname == 'Linux'
        let lines = readfile("/proc/version")
        if lines[0] =~ "icrosoft"
            source ~/.vim/vimrc.wsl
        else
            source ~/.vim/vimrc.linux
        endif
    endif
augroup END

set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching

" indentation
set shiftwidth=4
set softtabstop=4
set expandtab

"highlight ColorColumn ctermbg=red
"call matchadd('ColorColumn', '\%81v', 100)

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
      echo cmd
      exe cmd
      sil exe 'keepalt file '.temp
      sil keepjumps e!
      sil exe 'keepalt file '.fnameescape(fn)
      call delete(temp)
      set nomod
      set readonly
    endfun
    autocmd BufReadPost,FileReadPost *.xlsx setlocal noswapfile
    autocmd BufReadPost,FileReadPost *.xlsx call XLSXRead(expand("<amatch>"))
    autocmd BufReadPost,FileReadPost *.xlsm setlocal noswapfile
    autocmd BufReadPost,FileReadPost *.xlsm call XLSXRead(expand("<amatch>"))
augroup END

augroup fastcad_stuff
    autocmd!
    "let fcw_cmd = '%!fcw_dump -x -v -v'
    "let fcw_cmd = '%!fcw_dump -T -v -v'
    "let fcw_cmd = '%!fcw_dump -x -v'
    "let fcw_cmd = '%!fcw_dump -v -v'
    let fcw_cmd = '%!fcw_dump -v'
    "let fcw_cmd = '%!fcw_dump'
    "let fcw_cmd = '%!fcw_dump -T'
    autocmd BufReadPre,FileReadPre *.fcw set bin
    autocmd BufReadPost,FileReadPost *.fcw execute fcw_cmd
    autocmd BufReadPost,FileReadPost *.fcw set readonly
    autocmd BufReadPost,FileReadPost *.fcw setlocal noswapfile
    autocmd BufReadPre,FileReadPre *.fc$ set bin
    autocmd BufReadPost,FileReadPost *.fc$ execute fcw_cmd
    autocmd BufReadPost,FileReadPost *.fc$ set readonly
    autocmd BufReadPost,FileReadPost *.fc$ setlocal noswapfile
    autocmd BufReadPre,FileReadPre *.fct set bin
    autocmd BufReadPost,FileReadPost *.fct execute fcw_cmd
    autocmd BufReadPost,FileReadPost *.fct set readonly
    autocmd BufReadPost,FileReadPost *.fct setlocal noswapfile
augroup END

" Make vim work with the 'crontab -e' command
set backupskip+=/var/spool/cron/*

set scrolloff=0
let dircolors_is_slackware = 1
"autocmd CompleteDone * pclose

set suffixes=.bak,~,.o,.pyc,.info,.swp,.obj,.map,.lst,.size,.d,.zip,.hex,.elf,.exe

" also check vimrc.wsl
let g:ycm_enable_inlay_hints = 0
let g:ycm_clear_inlay_hints_in_insert_mode = 1
"let g:ycm_echo_current_diagnostic = 'virtual-text'
let g:ycm_show_detailed_diag_in_popup = 1
let g:ycm_rust_toolchain_root = '/home/per/.rustup/toolchains/stable-x86_64-unknown-linux-gnu'
let g:ycm_show_diagnostics_ui = 1
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_server_keep_logfiles = 0
"let g:ycm_server_log_level = 'debug'
let g:ycm_auto_hover = '' "'CursorHold'

nnoremap <silent> <leader>i <Plug>(YCMToggleInlayHints)
nnoremap <leader>w <Plug>(YCMFindSymbolInWorkspace)
nnoremap <leader>W <Plug>(YCMFindSymbolInDocument)
nnoremap <leader>D :YcmShowDetailedDiagnostic<cr>
nnoremap <leader>m :YcmCompleter GetDoc<cr>

let g:pymode = 0
let g:pymode_folding = 0

function! MyStatusLine()
    return '%.30F%m%r %y%=%B %3v-%-3c %l/%L'
endfunction

set laststatus=2
set statusline=%!MyStatusLine()

" airline
let g:airline_detect_spelllang='flag'
let g:airline_powerline_fonts = 1
"let g:airline_section_b = '%-0.10{getcwd()}'
let g:airline_section_z='%B %v-%-c %l/%L'
let g:airline#extensions#whitespace#mixed_indent_algo = 1

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
"inoremap <leader>= yyp:s/./=/g<cr>:nohlsearch<cr>o
"inoremap <leader>- yyp:s/./-/g<cr>:nohlsearch<cr>o
" soft wrapped line movement
"nnoremap j gj
"nnoremap k gk
" buffer movement
nnoremap <c-¨> <c-^>
nnoremap <C-S-n> :bprev<cr>
nnoremap <C-n> :bnext<cr>
nnoremap <leader>1 :b 1<cr>
nnoremap <leader>2 :b 2<cr>
nnoremap <leader>3 :b 3<cr>
nnoremap <leader>4 :b 4<cr>
nnoremap <leader>5 :b 5<cr>
nnoremap <leader>6 :b 6<cr>
nnoremap <leader>7 :b 7<cr>
nnoremap <leader>8 :b 8<cr>
nnoremap <leader>9 :b 9<cr>
nnoremap <leader>0 :b 10<cr>
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
" set window size to number of rows
nnoremap ,,s G:exec "resize " . line(".")<CR>
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
"inoremap <leader>" hviw<esc>a"<esc>hbi"<esc>lela
"inoremap <leader>' hviw<esc>a'<esc>hbi'<esc>lela
" split open previous buffer
nnoremap <leader>op :execute "below split " . bufname("#")<CR>
" grep word under cursor
let g:CGrepFiles=" --include='*.h' --include='*.c' --include='*.cpp' "
function! GitGrep(word)
    let tmpf = tempname()
    let cmd = '!git grep ' . a:word . ' 2>/dev/null | tr -d "\r" | tee ' . tmpf
    execute cmd
    let ef = &errorformat
    let &errorformat = &grepformat
    let &errorfile = tmpf
    cfile
    let &errorformat = ef
    copen
    execute '!rm -f ' . tmpf
endfunction
command! -nargs=1 -complete=file GG :call GitGrep(<q-args>)
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
"inoremap <leader><leader>f <c-o>:py3f /home/per/bin/clang-format.py<cr>

" fzf
nnoremap _ :FZF<cr>

command XMLPretty :%!python3 -c "import xml.dom.minidom as md, sys; print(md.parse(sys.stdin).toprettyxml())"

function! PandocPDF()
    execute "w !pandoc -f commonmark -t pdf -o " . expand('%:t:r') . ".pdf"
endfunction
function! PandocDOCX()
    execute "w !pandoc -f commonmark -t docx -o " . expand('%:t:r') . ".docx"
endfunction
function! PandocHTML()
    execute "w !pandoc -f commonmark -t html -o " . expand('%:t:r') . ".html"
endfunction
function! Pandoc()
    execute "w !pandoc -f commonmark -t html | xsel"
    "execute "!pandoc -f commonmark_x -t html % | xsel"
    "execute "!pandoc -f markdown -t html % | xsel"
endfunction
nnoremap <leader>pd :call Pandoc()<cr>
nnoremap <leader>pdp :call PandocPDF()<cr>
nnoremap <leader>pdh :call PandocHTML()<cr>

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
nnoremap <silent> <leader>d :call YcmTag()<cr>
nnoremap <silent> <c-cr> :call YcmTag()<cr>
nnoremap <silent> <c-s-cr> <c-t>
nnoremap <silent> <leader>r :YcmCompleter GoToReferences<cr>

" vimtex
let g:vimtex_view_method = 'zathura'
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
set conceallevel=0
let g:tex_conceal='abdmg'

" Ultisnips
"let g:UltiSnipsExpandTrigger="<S-t>"
"let g:UltiSnipsJumpForwardTrigger="<S-f>"
"let g:UltiSnipsJumpBackwardTrigger="<S-b>"

runtime colorscheme

