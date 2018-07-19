" used for the markdown previewer
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

call plug#begin('~/.vim/plugged')
" ==========================
" Formatting/Colors
" ==========================
Plug 'altercation/vim-colors-solarized'
Plug 'editorconfig/editorconfig-vim'
Plug 'sbdchd/neoformat'
Plug 'prettier/vim-prettier', {
    \ 'do': 'yarn install',
    \ 'for': ['javascript', 'typescript', 'css', 'scss']
    \ }

" Linters
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Auto close html tags (also for js and ts)
Plug 'alvan/vim-closetag'

" Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Typescript
Plug 'Quramy/tsuquyomi', { 'for': ['typescript'] }
Plug 'leafgarland/typescript-vim', { 'for': ['typescript'] }

" Scss/CSS
Plug 'cakebaker/scss-syntax.vim', { 'for': ['css', 'scss'] }

" Other
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'fatih/vim-nginx'
Plug 'avakhov/vim-yaml'

" ==========================
" General plugin "helpers"
" ==========================
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat' " mostly used so that vim-surround can be repeated
Plug 'tpope/vim-commentary' " easy comments with `gc` or `gcc`
Plug 'airblade/vim-rooter' " Auto lcd to git dir on BufEnter
Plug 'matze/vim-move'
Plug 'jiangmiao/auto-pairs' " auto close brackets and quotes


" ==========================
" File browser, buffers, general
" ==========================
Plug 'scrooloose/nerdtree'
Plug 'albfan/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb' " nice GitHub git wrapper for fugitive

" used for fast fuzy filename opening
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'Valloric/YouCompleteMe', { 'do': 'python3 ./install.py --js-completer' }

" allows \bo to close all buffers except current focus
Plug 'vim-scripts/BufOnly.vim'
" really just so i can do \bd to close the current buffer
Plug 'rbgrouleff/bclose.vim'

Plug 'SirVer/ultisnips'
Plug 'mlaursen/vim-react-snippets'

call plug#end()

" ================================================================
" Plugin settings
" ================================================================

" update key bindings for UltiSnips
let g:UltiSnipsExpandTrigger="<c-space>"
let g:UltiSnipsListSnippets="<c-h>"
let g:UltiSnipsJumpForwardTrigger="<c-s-right>"
let g:UltiSnipsJumpBackwardTrigger="<c-s-left>"
let g:UltiSnipsEditSplit="vertical"

" hide more stuff in NERDTree
let g:NERDTreeShowHidden=1

" Update linters so typescript isn't running both eslint and tslint which is super slow
let g:ale_linters = {
      \ 'scss': ['scsslint'],
      \ 'javascript': ['eslint'],
      \ 'typescript': ['tslint', 'tsserver', 'typecheck'],
      \ }
let g:ale_fixers = {
      \ 'typescript': ['prettier']
      \ }
let g:ale_javascript_prettier_use_local_config = 1


" Update fzf.vim actions for bindings like command-t
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-t': 'tabedit',
      \ 'ctrl-v': 'vsplit',
      \ }
let g:fzf_layout = { 'down': '~40%' }

" I don't like this enabled by default, but might be helpful for projects that use prettier
" autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx Neoformat
nmap <C-f> :Neoformat<cr>:w<cr>

" update vim-move to use control instead of alt since mac is stupid
let g:move_key_modifier='C'

" allow jsx syntax in .js files
let g:jsx_ext_required=0

" Update closetag to also work on js/ts files
let g:closetag_html_style=1
let g:closetag_filenames='*.html,*.js,*.jsx,*.ts*.tsx'

" only start markdown previewer after :ComposerStart
let g:markdown_composer_autostart=0
let g:markdown_composer_external_renderer='pandoc -f gfm -t html'

nmap <F1> :YcmCompleter GetType<CR>
nmap <F2> :YcmCompleter GetDoc<CR>
nmap <F3> :YcmCompleter GoTo<CR>
nmap <F4> :YcmCompleter RefactorRename<space>
nmap <F5> :YcmRestartServer<CR>

" go to previous and next matches when using <leader>g
nmap <F9> :cp<cr>
nmap <F10> :cn<cr>

autocmd FileType markdown nnoremap <buffer> <F12> :ComposerStart<cr>

" When linting, go to next and previous errors
nmap <leader>n :lnext<cr>
nmap <leader>p :lprev<cr>

" Use ag instead of ack
if executable('ag')
  let g:ackprg='ag --vimgrep'

  " Update fzf to ignore files that can't be opened by vim and to use the silver searcher
  let $FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore "*.(png|svg|jpe?g|pdf|ttf|woff2?|eot|otf|zip|tar|bz)" -g ""'
endif

" Use ag for grepping
nmap <leader>g :Ag<space>

" lazyily toggle nerdtree
nmap <leader>] :NERDTreeToggle<cr>

" Allow fzf search as \t
nmap <leader>t :FZF<cr>

" Linting and fixing
nmap <leader>f :FixJS<cr>

" For some reason it stopped setting tw correctly
au FileType gitcommit setlocal tw=72

au BufRead,BufNewFile .babelrc,.eslintrc set ft=json
au BufRead,BufNewFile *nginx.conf.* set ft=nginx

" ================================================================
" => General
" ================================================================

" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = "\\"
let g:mapleader = "\\"

" Fast saving
nmap <leader>w :w!<cr>
nmap <leader>q :lclose<cr>:q<cr>
nmap <leader>wq :x<cr>
nmap <leader>Q :qall!<cr>

" Line Numbers
set nu


" ================================================================
" => VIM user interface
" ================================================================

" Turn on the WiLd menu
set wildmenu

" Opens up the autocomplete help in the YouCompleteMe menu instead of a preview buffer
set completeopt=menuone

set cmdheight=2

" Always show the status bar and airline
set laststatus=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500



" ================================================================
" => Colors and Fonts
" ================================================================

" Enable syntax highlighting
syntax enable
set background=dark

if $TERM == "xterm-256color"
  set t_Co=256
  colorscheme solarized
else
  colorscheme desert
endif

" also update airline to use solarized
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

" Update cursor after the changes to nvim
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0
set guicursor+=i-ci:block-Cursor/lCursor
set guicursor+=r-cr:hor20-Cursor/lCursor

" ================================================================
" => Files, backups and undo
" ================================================================

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


" ================================================================
" => Text, tab and indent related
" ================================================================

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set nowrap "Wrap lines



" ================================================================
" => Moving around, tabs, windows and buffers
" ================================================================

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

map <leader>b :Buffers<cr>
map <leader>bd :Bclose<cr>

" Close all buffers except current
map <leader>bo :BufOnly<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" ================================================================
" => Spell checking
" ================================================================

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=



" ================================================================
" => Helper functions
" ================================================================

function! FormatXml()
  execute("silent %!xmllint --format --recover - 2>/dev/null")
endfunction

function! FixJS()
  execute('silent !eslint --fix % 2>/dev/null')
  redraw!
endfunction

function! FormatJson()
  execute('silent %!python -m json.tool')
endfunction

command! XMLint exec ":silent %!xmllint --format --recover - 2>/dev/null"

command! FixJS call FixJS()
command! FormatJson call FormatJson()
