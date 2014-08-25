nnoremap <leader>q :set operatorfunc=<SID>GrepOperatorC<CR>g@
vnoremap <leader>q :<c-u>call <SID>GrepOperatorC(visualmode())<CR>

nnoremap <leader>qc :set operatorfunc=<SID>GrepOperatorAll<CR>g@
vnoremap <leader>qc :<c-u>call <SID>GrepOperatorAll(visualmode())<CR>

function! s:YankIt(type)
    if a:type ==# 'v'
        execute "normal! `<v`>y"
    elseif a:type ==# 'char'
        execute "normal! `[v`]y"
    else
        return 0
    endif
    return 1
endfunction

function! s:GrepOperatorAll(type)
    let saved_unnamed = @@
    if s:YankIt(a:type)
        execute "grep! -R " . shellescape(@@) . " ."
    endif
    let @@ = saved_unnamed
endfunction

function! s:GrepOperatorC(type)
    let saved_unnamed = @@
    if s:YankIt(a:type)
        execute "grep! " . shellescape(@@) . " *.[hc]"
    endif
    let @@ = saved_unnamed
endfunction

