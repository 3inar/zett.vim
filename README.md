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
* `:Backl` searches the working directory for links to the current file and
  shows the hits in a quickfix window.
* `,y` places a wiki-style link to the current file in the unnamed register
  (the one used for yank).

Passive functionality:
* Highlights for links, hashtags
* Appends `.md` so that a link can be followed by `gf` (this is important!)

## TODO
* ~~[ ] Natural language search~~ use `:Ag` or `:Rg` from
  [fzf.vim](https://github.com/junegunn/fzf.vim)
* [ ] Link suggestion when writing `[[ something`
* [x] Show "head" of linked file
