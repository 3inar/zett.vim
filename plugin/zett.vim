" start a new zettel with the current timestamp as filename
command Newz :call NewZettel()
command Newzl :call NewZettelLink()
command Backl :call GrepBacklinks()

" Places a zettel link to the current file in unnamed register (used by yank)
function GrabLink()
  let $fn = expand("%:t")                       " get filename
  let $fn = substitute($fn, ".md", "", "")      " strip off .md
  let $fn = eval(string("[[" . $fn . "]]"))     " wrap in [[]]
  let @"=$fn                                    " place in register 
  unlet $fn
endfunction

" a custom yank that calls GrabLink 
nmap ,y :call GrabLink()<Enter>:echo ""<Enter>

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
  call NewZettel()
  call LinkFromPrev()
endfunction

function GrepBacklinks()
  call GrabLink()
  exec ":vimgrep /" . escape(@", "[]") . "/j `find .`"
  copen
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
    autocmd bufread * call ZetLights()
augroup END
