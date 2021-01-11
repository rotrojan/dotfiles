"------------------------------------------------------------------------------"
"  ____                 _____                                                  "
" /\  _`\    __        /\  __`\          Neovim configuration                  "
" \ \ \L\ \ /\_\     __\ \ \/\ \                                               "
"  \ \  _ <'\/\ \  /'_ `\ \ \ \ \        ~/.config/nvim/init.vim               "
"   \ \ \L\ \\ \ \/\ \L\ \ \ \_\ \                                             "
"    \ \____/ \ \_\ \____ \ \_____\      modified by BigO, github.com/rotrojan "
"     \/___/   \/_/\/___L\ \/_____/                                            "
"                    /\____/             rotrojan@student.42.fr                "
"                    \_/__/                                                    "
"------------------------------------------------------------------------------"

" PLUGINS

" Autoinstall Vim-Plug plugin manager if not already install.

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  Plug 'dense-analysis/ale'
  Plug 'preservim/nerdtree' |
   \ Plug 'Xuyuanp/nerdtree-git-plugin' |
   \ Plug 'ryanoasis/vim-devicons'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'preservim/nerdcommenter'
  Plug 'ap/vim-css-color'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  Plug 'pandark/42header.vim'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'morhetz/gruvbox'
  Plug 'simnalamburt/vim-mundo'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'Valloric/YouCompleteMe'
call plug#end()

" MISCELLANEOUS

colorscheme gruvbox
set mouse=a
set clipboard=unnamed,unnamedplus
set scrolloff=5
set splitbelow splitright
" set nowrap
set noswapfile
set ignorecase smartcase tagcase=followscs
let mapleader=" "

" Set transparency.
highlight Normal guibg=NONE ctermbg=NONE

" Finding files : search down into subfolders and provide tab-completion for
" all file related tasks.
set path+=**

" Format the tabs and the EOL properly.
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:\|-,eol:¬

" Always center the result of search.
cnoremap <silent> <expr> <enter> CenterSearch()
function! CenterSearch()
  let cmdtype = getcmdtype()
  if cmdtype == '/' || cmdtype == '?'
    return "\<enter>zz"
  endif
  return "\<enter>"
endfunction

" AUTOCOMMANDS

" Mark the 80th column and hightlight the text when going over (only in c
" files).
set colorcolumn=80
augroup vimrc_autocmds
  autocmd BufEnter *.c highlight OverLength
    \ ctermbg=red ctermfg=white guibg=#592929
  autocmd BufEnter *.c match OverLength /\%81v.\+/
augroup END

" Set hybrid relative numbers and automate toggle between Insert and Normal
" mode.
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &rnu | set nornu | endif
augroup END

" Help always displayed above.
augroup vimrc_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd K | endif
augroup END

" Autoquit vim when all relevant buffers are closed.
autocmd BufEnter * call CheckLeftBuffers()
function! CheckLeftBuffers()
  if tabpagenr('$') == 1
    let i = 1
    while i <= winnr('$')
      if getbufvar(winbufnr(i), '&buftype') == 'help' ||
          \ getbufvar(winbufnr(i), '&buftype') == 'quickfix' ||
          \ exists('t:NERDTreeBufName') &&
          \   bufname(winbufnr(i)) == t:NERDTreeBufName ||
          \ bufname(winbufnr(i)) == '__Mundo__' ||
          \ bufname(winbufnr(i)) == '__Mundo_Preview__'
        let i += 1
      else
        break
      endif
    endwhile
    if i == winnr('$') + 1
      qall
    endif
    unlet i
  endif
endfunction

" Open NERDTree on start.
autocmd VimEnter * if &filetype!=#'man' | NERDTree | wincmd l | endif 
" KEY-BINDINGS

" Make buffers navigation and management easier.
noremap <A-Right> <C-w><Right>
noremap <A-Left> <C-w><Left>
noremap <A-Up> <C-w><Up>
noremap <A-Down> <C-w><Down>
noremap <A-l> <C-w><Right>
noremap <A-h> <C-w><Left>
noremap <A-k> <C-w><Up>
noremap <A-j> <C-w><Down>
noremap <A-r> <C-w>r
noremap <A-v> <C-w>t<C-w>H
noremap <A-s> <C-w>t<C-w>K
noremap <A-i> :vertical resize +1<CR>
noremap <A-d> :vertical resize -1<CR>
noremap <C-A-i> :resize +1<CR>
noremap <C-A-d> :resize -1<CR>

" Auto parentheses.
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O

" PLUGINS CONFIGURATIONS

" NERDTree configuration.
let g:NERDTreeGitStatusUseNerdFonts = 1
nnoremap <leader>n :NERDTreeToggle<CR>

" Mundo configuration.
set undofile
set undodir=~/.vim/undo
let g:mundo_right = 1
nnoremap <leader>m :MundoToggle<CR>

" NERDCommenter configuration.
let g:NERDSpaceDelims = 1

" Airline configuration.
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
set noshowmode

" ALE configuration.
let g:ale_linters = { 'c': ['clangd'] }
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_open_list = 1
let g:ale_completion_enabled = 0
let g:ale_list_window_size = 3
" let $C_INCLUDE_PATH='./includes:./include:../includes:../include:../../includes:
" \../../include:./'

" 42header configuration.
command! Stdheader FortyTwoHeader
let b:fortytwoheader_user = "rotrojan"
let b:fortytwoheader_mail = "rotrojan@student.42.fr"
