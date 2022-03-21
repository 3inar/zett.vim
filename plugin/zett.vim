" start a new zettel with the current timestamp as filename
command Newz :call NewZettel()
command Newzl :call NewZettelLink()
command Backl :call GrepBacklinks()
"
" a custom yank that calls GrabLink 
nmap ,y :call GrabLink()<Enter>:echo ""<Enter>
nmap ,h :call Head()<Enter>

" enables goto-file from links
set suffixesadd=.md 

" Places a zettel link to the current file in unnamed register (used by yank)
function GrabLink()
  let $fn = expand("%:t")                       " get filename
  let $fn = substitute($fn, ".md", "", "")      " strip off .md
  let $fn = eval(string("[[" . $fn . "]]"))     " wrap in [[]]
  let @"=$fn                                    " place in register 
  unlet $fn
endfunction


" yank link to current file, jump to previous location, put, jump back
function LinkFromPrev()
  execute "normal ,y\<C-o>p\<C-i>"      
endfunction

" Creates a new zettel with link to where it  was created from
function NewZettel()
  normal ,y
  let $tstamp=strftime("%Y%m%d%H%M")
  e $tstamp.md
  unlet $tstamp
  execute "normal i# New note started from \<Esc>p"
endfunction

" Creates a new zettel and links to it from origin
function NewZettelLink()
  if &hidden
    call NewZettel()
    call LinkFromPrev()
  else
    echo "Must have hidden set for :Newlz to work"
  endif
endfunction

function GrepBacklinks()
  call GrabLink()
  exec ":vimgrep /" . escape(@", "[]") . "/j `find .`"
  copen
endfunction

" function to show head of file under cursor
function Head()
  norm yiw
  exec "! head -n5" . @" . ".md"
endfunction


" highligts for wiki-style links and hashtags in markdown files
function! ZetLights()
  if &ft == "markdown"
    highlight default link ZetLink mkdLinkDef
    highlight default link ZetTag Comment

    " containedin is crucial here; these will not match anything inside
    " another highlight group without it
    syntax match ZetTag /#\w\+/ containedin=ALL
    syntax match ZetLink /\[\[\w\+\]\]/ containedin=ALL
  endif
endfunction

augroup ZettelHighlights
    autocmd!
    autocmd BufRead,BufNewfile,BufWinEnter * call ZetLights()
augroup END
