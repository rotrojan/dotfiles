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
	Plug 'neoclide/coc.nvim', {'branch': 'release'}" Plug 'dense-analysis/ale'
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
	" if has('nvim')
		" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	" else
		" Plug 'Shougo/deoplete.nvim'
		" Plug 'roxma/nvim-yarp'
		" Plug 'roxma/vim-hug-neovim-rpc'
	" endif
	Plug 'voldikss/vim-floaterm'
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
set number
augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &rnu | set nornu | endif
	autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &nu | set rnu | endif
augroup END

" Help always displayed above.
augroup vimrc_help
	autocmd!
	autocmd BufEnter *.txt if &buftype == 'help' | wincmd K | endif
augroup END

" Open NERDTree on start.
autocmd VimEnter * if &filetype!=#'man' | NERDTree | wincmd l | endif

" Autoquit vim when all if only buffers are closed.
" autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
" function! s:CloseIfOnlyNerdTreeLeft()
	" if exists("t:NERDTreeBufName")
		" if bufwinnr(t:NERDTreeBufName) != -1
			" if winnr("$") == 1
				" q
			" endif
		" endif
	" endif
" endfunction
autocmd BufEnter * call CheckLeftBuffers()
function! CheckLeftBuffers()
	if tabpagenr('$') == 1
		let i = 1
		while i <= winnr('$')
			if getbufvar(winbufnr(i), '&buftype') == 'help' ||
				\ getbufvar(winbufnr(i), '&buftype') == 'quickfix' ||
				\ exists('t:NERDTreeBufName') &&
				\ bufname(winbufnr(i)) == t:NERDTreeBufName ||
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

" Auto brackets.
inoremap {<CR> {<CR>}<ESC>O

" Prevent from treating C headers files as C++ files.
"
augroup project
  autocmd!
  autocmd BufRead,BufNewFile *.h,*.c set filetype=c
augroup END

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
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_open_list = 'on_save'
augroup CloseLoclistWindowGroup
	autocmd!
	autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END
" augroup ResetALEWhenAllErrorsCorrected
	" autocmd!
	" autocmd BufWrite * ALEReset | echo toto
" augroup END
		" autocmd!
		" autocmd QuickFixCmdPre * if (&buftype = 'quickfix') | ALEreset | endif
let g:ale_completion_enabled = 0
let g:ale_list_window_size = 3
nnoremap <leader>r ALEReset<CR>

" Deoplete configuration.
let g:deoplete#enable_at_startup = 1

" Floaterm configuration.
" noremap <leader>t <C-\><C-n>:FloatermToggle<CR>
let g:floaterm_keymap_toggle = '<C-T>'
let g:floaterm_wintype = 'normal'
let g:floaterm_position = 'bottom'
let g:floaterm_height = 0.2

" 42header configuration.
" command! Stdheader FortyTwoHeader
let b:fortytwoheader_user = "rotrojan"
let b:fortytwoheader_mail = "rotrojan@student.42.fr"

" Coc configuration
" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
      " \ pumvisible() ? "\<C-n>" :
      " \ <SID>check_back_space() ? "\<TAB>" :
      " \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
  " let col = col('.') - 1
  " return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><noait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>w
