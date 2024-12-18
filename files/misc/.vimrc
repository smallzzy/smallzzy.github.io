" https://vi.stackexchange.com/questions/25311/how-to-activate-bracketed-paste-mode-in-gnome-terminal-for-vim-inside-tmux
" Activate bracketed paste in tmux
if &term =~ "screen"
  let &t_BE = "\e[?2004h"
  let &t_BD = "\e[?2004l"
  exec "set t_PS=\e[200~"
  exec "set t_PE=\e[201~"
endif