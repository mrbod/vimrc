nnoremap <leader>q :set operatorfunc=<SID>GrepOperator<CR>g@
vnoremap <leader>q :<c-u>call <SID>GrepOperator(visualmode())<CR>

function! s:GrepOperator(type)
    let saved_unnamed = @@

    if a:type ==# 'v'
        execute "normal! `<v`>y"
    elseif a:type ==# 'char'
        execute "normal! `[v`]y"
    else
        return
    endif

    silent execute "grep! -R " . shellescape(@@) . " ."
    let @@ = saved_unnamed
    cwindow
endfunction

