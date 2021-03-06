"

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
    finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Turn backup off
set nobackup
set nowritebackup
set noundofile

set history=150     " keep 150 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set incsearch       " do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
    syntax on

    " Also switch on highlighting the last used search pattern.
    set hlsearch

    " I like highlighting strings inside C comments.
    let c_comment_strings=1
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
"   filetype plugin indent off
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
"   autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
    augroup END
else
    set autoindent        " always set autoindenting on
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
    " Prevent that the langmap option applies to characters that result from a
    " mapping.  If unset (default), this may break plugins (but it's backward
    " compatible).
    set langnoremap
endif

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
if v:version == 704 && has('patch1100')
    packadd matchit
endif

" Additional settings

" Parse modeline
set modeline
set modelines=5

if v:version >= 740
    " Encryption method
    set cm=blowfish2
endif

" Don't redraw while executing macros (good performance config)
set lazyredraw

"set ttyfast

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Makes search act like search in modern browsers
set incsearch

" Ignore case when searching
set ignorecase

" For regular expressions turn magic on
set magic

" Use Unix as the standard file type
set fileformats=unix,dos,mac

set mps+=<:> "

"set listchars=tab:··
"set list

" 1 tab == 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab                           " tabs are spaces
set smarttab
set softtabstop=4
set autoindent
set smartindent
"set shiftround
set backspace=indent,eol,start          "backspaces delete auto-inserted indents
"set formatoptions-=ro
"set preserveindent
"set copyindent

"setlocal spelllang=en spell

set t_Co=256

"set background=light
"set background=dark

" Comment's color
highlight Comment ctermfg=8

set guitablabel=%N/\ %t\ %M

" Tab's color
hi TabLineFill cterm=none ctermfg=grey  ctermbg=cyan
hi TabLine     cterm=none ctermfg=white ctermbg=cyan
hi TabLineSel  cterm=none ctermfg=black ctermbg=white

set cursorline
"set cursorcolumn

let g:netrw_liststyle=3
highlight LineNr ctermfg=grey

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c\ [%{LinePercent()}%h]

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

function! LinePercent()
    return line('.') * 100 / line('$') . '%'
endfunction

hi StatusLine ctermbg=black ctermfg=darkgrey

function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre * :%retab!

set pastetoggle=<F4>

" Display line numbers
nmap <F1> :set invnumber<CR>
nmap <F2> :set invrelativenumber<CR>

" Tabs
set showtabline=2
" Prev
nmap <silent> <F5> :tabprevious<CR>
" Next
nmap <silent> <F6> :tabnext<CR>
" Create
nmap <silent> <F7> :tabnew<CR>

" Changing the encoding
set wildmenu
set wcm=<Tab>
menu Encoding.koi8-r        :e ++enc=koi8-r ++ff=unix<CR>
menu Encoding.windows-1251  :e ++enc=cp1251 ++ff=dos<CR>
menu Encoding.cp866         :e ++enc=cp866 ++ff=dos<CR>
menu Encoding.utf-8         :e ++enc=utf8 <CR>
menu Encoding.koi8-u        :e ++enc=koi8-u ++ff=unix<CR>
map <silent> <F8> :emenu Encoding.<TAB>

map <silent> <F11>          :sp +Explore<CR>
map <silent> <F12>          :Explore<CR>

" Local settings
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
