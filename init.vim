let g:pathogen_disabled = ['vim-localvimrc']

try
    execute pathogen#infect()
catch
endtry

set nocompatible
set ruler
set showcmd
set incsearch
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab
set number
set relativenumber
" set hidden
set background=dark
set textwidth=80
set colorcolumn=101
set ignorecase
set scrolloff=5
set matchpairs+=<:>
set autoread
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.pyc
set backspace=indent,eol,start
set directory-=.
set formatoptions=croqln
set autoindent
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set guicursor+=a:blinkon0
set noswapfile
set ttimeoutlen=100
set laststatus=2
set cursorline
set ttyfast
set exrc
if !has('nvim')
    set ttymouse=xterm2
endif
set mouse=a
set t_md=
set sessionoptions=blank,help,tabpages
set wildmode=longest,list
syntax on
filetype plugin indent on

if has('nvim')
    set termguicolors
endif

try
    colo vividchalk
catch
    colo elflord
endtry

if has("gui_running")
    if has("gui_macvim")
        set gfn=Droid\ Sans\ Mono:h12
        set go-=r go-=l go-=R go-=L
        set lines=50 columns=140
        set macmeta
    elseif has("gui_gtk")
        set gfn=Fixed\ Medium\ Semi-Condensed\ 10
        set go-=r go-=l go-=R go-=L go-=m go-=T

        " disabling italic for fixed font
        hi Comment gui=NONE
        hi railsUserClass gui=NONE
        hi railsUserMethod gui=NONE
    elseif exists("neovim_dot_app")
        set gfn=Droid\ Sans\ Mono:h12
        set go-=r go-=l go-=R go-=L
        set lines=50 columns=140
        set macmeta
    endif
endif

" let g:localvimrc_ask = 0
" let g:localvimrc_sandbox = 0

""" Creating a more hand-friendly <leader> key. Any custom mapping that depends
""" on the leader has to be defined **after** this command
let mapleader = " "

""" All-buffers wipe
command! Abw :%bw!

""" Initial state
function! InitialState()
    :Abw
    :vsplit
    :enew
    :vsplit
    :enew
endfunction
command! Initial :call InitialState()

function! InitialState2()
    :Abw
    :vsplit
    :enew
endfunction
command! Initial2 :call InitialState2()

""" Copy path to file
if has("gui_macvim") || has("gui_gtk")
    command! PathCopy :let @+ = expand("%")
else
    command! PathCopy :call system("clip", expand("%"))
endif

""" Add/remove search highlights
nnoremap <leader>h :set hls!<CR>

""" Simplifying pasting on the terminal
nnoremap <leader>v :set invpaste paste?<CR>

""" Extra whitespaces
function! ObliterateExtraWhitespace()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction
augroup NoExtraWhitespace
    autocmd!
    autocmd BufWritePre * :call ObliterateExtraWhitespace()
augroup END

""" CtrlP Configuration
let g:ctrlp_map = ''
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:30'
let g:ctrlp_switch_buffer = ''
let g:ctrlp_regexp = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v\.(git|hg|svn)$|\/node_modules$',
    \ 'file': '\v\/\.DS_Store$',
    \ }
"let g:ctrlp_default_input = 1
nnoremap <leader>pp :CtrlP
nnoremap <silent> <leader>pf :CtrlP b:current_work_dir<CR>
nnoremap <silent> <leader>pR :CtrlPRoot<CR>
nnoremap <silent> <leader>pb :CtrlPBuffer<CR>
nnoremap <silent> <leader>pm :CtrlPMRU<CR>
nnoremap <silent> <leader>pt :CtrlPTag<CR>
nnoremap <silent> <leader>pr :CtrlPBufTag<CR>
nnoremap <silent> <leader>pa :CtrlPBufTagAll<CR>
nnoremap <silent> <leader>pB :execute '!' . b:tags_build_command<CR>

""" NERDCommenter Configuration
let g:NERDSpaceDelims = 1

""" Vim-Kompleter Configuration
let g:kompleter_async_mode = 0
let g:kompleter_case_sensitive = 1
augroup VimKompleterKeywords
    autocmd!
    autocmd FileType lisp,clojure,html,xml,xhtml,haml setlocal iskeyword+=-
    autocmd FileType eruby,css,scss,sass,javascript setlocal iskeyword+=-
    autocmd FileType coffee setlocal iskeyword+=-
augroup END

""" Go
augroup GoConfig
    autocmd!
    autocmd FileType go setlocal noexpandtab
augroup END

""" Yaml
augroup YamlConfig
    autocmd!
    autocmd FileType yaml setlocal sts=2 sw=2
augroup END

""" NERDTree Configuration
" function! s:FixCursorLine()
"     let l:num_windows = winnr('$')
"     for l:i in range(1, l:num_windows)
"         execute 'wincmd w'
"     endfor
" endfunction
" command! FixCursorLineCmd call s:FixCursorLine()
let g:NERDTreeMapHelp = '<f1>'
nnoremap <silent> <leader>nB :NERDTree<CR>
nnoremap <silent> <leader>nf :NERDTreeFocus<CR>
nnoremap <silent> <leader>nF :NERDTreeFind<CR>
nnoremap <silent> <leader>nt :NERDTreeToggle<CR>
" nnoremap <silent> <leader>nr :FixCursorLineCmd<CR>

""" Making the active window more obvious
" augroup BgHighlight
"     autocmd!
"     autocmd WinEnter * set cursorline
"     autocmd WinLeave * set nocursorline
" augroup END

""" Argh nonexistent files
function! s:WipeBuffersWithoutFiles()
    let bufs=filter(range(1, bufnr('$')), 'bufexists(v:val) && '.
                                          \'empty(getbufvar(v:val, "&buftype")) && '.
                                          \'!filereadable(bufname(v:val))')
    if !empty(bufs)
        execute 'bwipeout!' join(bufs)
    endif
endfunction
command! BWnex call s:WipeBuffersWithoutFiles()

""" Checktime
nnoremap <leader>t :checktime<CR>:BWnex<CR>

""" Better StatusLine
highlight StatusLineNC
    \ ctermbg=DarkGray
    \ ctermfg=LightGray
    \ guibg=#999999
    \ guifg=White
highlight StatusLine
    \ ctermbg=LightBlue
    \ ctermfg=Black
    \ guibg=#5555ff
    \ guifg=White
augroup StatusLineMode
    autocmd!
    autocmd InsertEnter * highlight StatusLine
        \ ctermbg=Red
        \ ctermfg=White
        \ guibg=Red
        \ guifg=White
    autocmd InsertLeave * highlight StatusLine
        \ ctermbg=LightBlue
        \ ctermfg=Black
        \ guibg=#5555ff
        \ guifg=White
augroup END

""" Better moving through windows
nnoremap <silent> <C-S-k> :wincmd k<CR>
nnoremap <silent> <C-S-j> :wincmd j<CR>
nnoremap <silent> <C-S-h> :wincmd h<CR>
nnoremap <silent> <C-S-l> :wincmd l<CR>

""" More ways to move between windows, so I don't confuse myself between vim
""" and tmux. Plus a workaround so macvim stops ignoring my mappings.
let macvim_skip_cmd_opt_movement = 1
nnoremap <silent> <M-Up> :wincmd k<CR>
nnoremap <silent> <M-Down> :wincmd j<CR>
nnoremap <silent> <M-Left> :wincmd h<CR>
nnoremap <silent> <M-Right> :wincmd l<CR>
nnoremap <silent> <M-S-Up> :wincmd K<CR>
nnoremap <silent> <M-S-Down> :wincmd J<CR>
nnoremap <silent> <M-S-Left> :wincmd H<CR>
nnoremap <silent> <M-S-Right> :wincmd L<CR>
nnoremap <silent> <M-x> :wincmd x<CR>
nnoremap <silent> <M-q> :wincmd q<CR>
nnoremap <silent> <M-w> :wincmd q<CR>

""" Some C-mappings to make it easier for GUI users (me)
nnoremap <silent> <C-s> :w<CR>

""" vim-go
""" We can't use vim-go's powerful highlighting because it slows down vim quite
""" a bit for large screens
let g:go_highlight_functions = 0
let g:go_highlight_methods = 0
let g:go_highlight_structs = 0
let g:go_highlight_operators = 0
let g:go_highlight_build_constraints = 0
let g:go_fmt_command = "goimports"

""" Better undo
set undodir=$HOME/.vimundo/
set undofile
set undolevels=1000
set undoreload=10000
nnoremap <silent> <leader>uf :UndotreeFocus<CR>
nnoremap <silent> <leader>ut :UndotreeToggle<CR>

""" vim-session
let g:session_autosave = 'no'
let g:session_autoload = 'no'
let g:session_autosave_periodic = 5

""" Python sort imports
nnoremap <silent> <leader>S gg/^import<CR>vip!sort<CR>
nnoremap <silent> <leader>s vip!sort<CR>

""" JSX
let g:jsx_ext_required = 0

""" Syntastic
nnoremap <silent> <leader>;s :SyntasticCheck<CR>:echo "Done checking."<CR>
nnoremap <silent> <leader>;S :SyntasticReset<CR>

let g:syntastic_mode_map = { "mode": "passive" }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_aggregate_errors = 1

""" Status line
set statusline=%<%f\ %h%m%r
set statusline+=%=
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=\   " final space
set statusline+=(%l:%c)

""" vim-flow (default disabled, enable per project)
nnoremap <silent> <leader>;f :FlowMake<CR>
nnoremap <silent> <leader>;F :cclose<CR>
let g:flow#enable = 0
let g:flow#omnifunc = 0
