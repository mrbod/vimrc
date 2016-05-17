set makeprg=pylint\ --reports=n\ --msg-template=\"{path}:{line}:\ {msg_id}\ {symbol},\ {obj}\ {msg}\"\ %:p
set errorformat=%f:%l:\ %m
nnoremap <F12> :!nosetests<cr>

