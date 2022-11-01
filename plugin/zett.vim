" start a new zettel with the current timestamp as filename
command Newz :call NewZettel()
command Newzl :call NewZettelLink()
command Backlinks :call GrepBacklinks()
command Randomzettel :call RandomZettel()

" a custom yank that calls GrabLink 
nmap ,y :call GrabLink()<Enter>:echo ""<Enter>

" shows head of linked file under cursor
nmap ,h :call Head()<Enter>

" Quicker way to show random note
nmap ,r :call RandomZettel()<Enter>:echo ""<Enter>

" show backlinks
nmap ,b :call GrepBacklinks()<Enter>:echo ""<Enter>

" new notes
nmap ,nn :call NewZettel()<Enter>:echo ""<Enter>
nmap ,nl :call NewZettelLink()<Enter>:echo ""<Enter>

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

" open a random file from working directory
function RandomZettel()
  exec ':e ' . system("ls *.md | sort -R | tail -n1")
endfunction


" store link to this file, jump to previous location, put link there, jump back
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
    echo "Must have hidden set for :Newzl to work"
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
    highlight default link MathBlock Include
    highlight default link MathInline Include

    " containedin is crucial below; these will not match anything inside
    " another highlight group without it
     
    syntax region MathBlock start=/\$\$/ end=/\$\$/ 
          \ containedin=mkdNonListItemBlock
    syn match MathInline '\$[^$].\{-}\$' 
          \ containedin=mkdNonListItemBlock,mkdListItemLine

    syntax match ZetTag /#\w\+/ 
          \ containedin=mkdNonListItemBlock,mkdListItemLine
    syntax match ZetLink /\[\[\w\+\]\]/
          \ containedin=mkdNonListItemBlock,mkdListItemLine
  endif
endfunction

augroup ZettelHighlights
    autocmd!
    autocmd BufRead,BufNewfile,BufWinEnter * call ZetLights()
augroup END
