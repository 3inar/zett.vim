# Some basic functionality for working with zettelkasten-style note taking

This is for my own use, based on an initial workflow in Obsidian. Probably
idiosyncratic and buggy, probably will change while I figure out how I want
this to work. Assumes for now that all files reside in a single folder.

## Functionality
Things you can do:
* `:Newz` or `,nn` creates a new note with filename `%Y%m%d%H%M.md`. Inserts a
  wiki-style link to the file you had open when executing the command.
* `:Newzl` or `,nl` does the same as `:Newz` but also inserts a wiki-style link (eg.,
  `[[202203201616]]`)to the new file in the old file.
* `:Backlinks` or `,b` searches the working directory for links to the current file and
  shows the hits in a quickfix window.
* `:Randomzettel` or `,r` opens a random note from current working directory
* `,y` places a wiki-style link to the current file in the unnamed register
  (the one used for yank).
* `,h` shows the first  five lines of the file linked to under cursor

Passive functionality:
* Highlights for links, hashtags, LaTex math (extremely basic, just patching up
  the very bad standard markdown highlighting)
* Appends `.md` so that a link can be followed by `gf` (this is important!)

## TODO
* [ ] Command to mash out a pandoc-pdf of current note
  * [ ] Make it play nice with a latex `.bib` file

## Might-do
* [ ] Link suggestion when writing `[[ something`
* [ ] Extract visual mode selection to new note 
* [ ] Find important notes by a pagerank-style sorting
  * [ ] Use to make a map of notes? Clustering?
* [ ] Goto and create a note that's linked to but does not exist

## Probaby-won't-do
* [ ] ~~Natural language search~~ use `:Ag` or `:Rg` from
  [fzf.vim](https://github.com/junegunn/fzf.vim)

## Already did
* [x] Show `head` of linked file
* [x] Open random note
* [x] Fix broken syntax highlighting for latex math in markdown
