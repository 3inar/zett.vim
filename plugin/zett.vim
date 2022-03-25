" start a new zettel with the current timestamp as filename
command Newz :call NewZettel()
command Newzl :call NewZettelLink()
command Backlinks :call GrepBacklinks()

" a custom yank that calls GrabLink 
nmap ,y :call GrabLink()<Enter>:echo ""<Enter>
nmap ,h :call Head()<Enter>

" enables goto-file from links
set suffixesadd=.md 

" saves a [[link]] to current buffer in its own variable
function SaveLink()
  let s:stored_link = expand("%:t")
  let s:stored_link = substitute(s:stored_link, ".md", "", "")
  let s:stored_link = eval(string("[[" . s:stored_link . "]]"))
endfunction

" Places a zettel link to the current file in unnamed register (used by yank)
function GrabLink()
  call SaveLink()
  let @"=s:stored_link
endfunction


" yank link to current file, jump to previous location, put, jump back
function LinkFromPrev()
  call SaveLink()
  execute "normal \<C-o>a " . s:stored_link . " \<Esc>\<C-i>"      
endfunction

" Creates a new zettel with link to where it  was created from
function NewZettel()
  call SaveLink()
  let $tstamp=strftime("%Y%m%d%H%M")
  e $tstamp.md
  unlet $tstamp
  execute "normal i# New note started from " . s:stored_link
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
  call SaveLink()
  if executable("ag")
    exec "call setqflist([], ' ', {'lines' : systemlist('ag \""
          \ . escape(s:stored_link, "[]") . "\"')})"
  else
    exec ":vimgrep /" . escape(s:stored_link, "[]") . "/j `find .`"
  endif
  copen
endfunction

" function to show head of file under cursor
function Head()
  norm yiw
  exec "! head -n5 " . @" . ".md"
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
