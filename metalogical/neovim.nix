{pkgs, ...}:
{
  programs.fzf.enable = true;
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    configure = {
      packages.metalogical = with pkgs.vimPlugins; {
        start = [
          vim-airline
          fzfWrapper fzf-vim
          deoplete-nvim LanguageClient-neovim
          vim-nix # vim-addon-nix?
          vim-go # TODO move to go-dev.nix
        ];
        opt = [ ];
      };
      customRC = ''
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" *** buffer management
set hidden  " allow switching away from unsaved buffers
nnoremap <silent> <Leader>bo :Files<CR>
nnoremap <silent> <Leader>be :Explore<CR>
nnoremap <silent> <Leader>bb :Buffers<CR>
nnoremap <silent> <Leader>bw :bw<CR>
nnoremap <silent> <Leader>bl :set buflisted<CR>

" *** UI
set background=dark
" add the byte offset to the end
let g:airline_section_z = '%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v:%o'
set number
set rnu
" display tabs & trailing spaces
set list
set listchars=tab:\|·,trail:·

" *** 4-space tabs
function SetTabs(spaces)
    set expandtab
    let &tabstop=a:spaces
    let &shiftwidth=a:spaces
    let &softtabstop=a:spaces
    set autoindent
endfunction
call SetTabs(4)
set backspace=2

" *** sanity
syntax on
filetype on
filetype plugin indent on

" *** mouse events
set ttyfast
set mouse=a

" *** save cursor location on exit
set viminfo='10,\"100,n~/.config/nvim/.viminfo
function! ResCur()
  " '" = last position in file, check that it's within range, and jump
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
augroup resCur
  " remove all autocmds for this group (idempotence)
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" *** completions/LSP
let g:deoplete#enable_at_startup = 1
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'lean': ['node', '/usr/local/lib/node_modules/lean-language-server/lib/index.js', '--stdio'],
    \ 'go': ['go-langserver'],
    \ 'python': ['pyls'],
    \ 'haskell': ['hie', '--lsp'],
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ }
nnoremap <silent> <Leader>gi :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> <Leader>gr :call LanguageClient_textDocument_references()<CR>
nnoremap <silent> <Leader>gd :call LanguageClient_textDocument_definition()<CR>

" TODO move to go-dev.nix
let g:go_fmt_command = "goimports"
      '';
    };
  };
}
