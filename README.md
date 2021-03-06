# Some basic functionality for working with zettelkasten-style note taking

This is for my own use, based on my workflow in Obsidian. Probably
idiosyncratic and buggy, probably will change frequently while I figure out how
I want this to work. Assumes all files reside in a single folder.

## Functionality
Things you can do:
* `:Newz` creates a new note with filename `%Y%m%d%H%M.md`. Inserts a
  wiki-style link to the file you had open when executing the command.
* `:Newzl` does the same as `:Newz` but also inserts a wiki-style link (eg.,
  `[[202203201616]]`)to the new file in the old file.
* `:Backlinks` searches the working directory for links to the current file and
  shows the hits in a quickfix window.
* `:Randomzettel` opens a random note in current working directory
* `,y` places a wiki-style link to the current file in the unnamed register
  (the one used for yank).
* `,h` shows the first  five lines of the file linked to under cursor

Passive functionality:
* Highlights for links, hashtags, LaTex math (extremely basic, just patching up the very bad standard markdown highlighting)
* Appends `.md` so that a link can be followed by `gf` (this is important!)

## TODO
* [ ] ~~Natural language search~~ use `:Ag` or `:Rg` from
  [fzf.vim](https://github.com/junegunn/fzf.vim)
* [ ] Link suggestion when writing `[[ something`
* [x] Show `head` of linked file
* [ ] Maybe: Extract visual mode selection to new note 
* [x] Open random note
* [x] Fix broken syntax highlighting for latex math in markdown
* [ ] Command to mash out a pandoc-pdf of current note
* [ ] Goto and create a note that's linked to but does not exist

