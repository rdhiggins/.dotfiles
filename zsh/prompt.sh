#!/bin/zsh

autoload -U colors
colors
setopt PROMPT_SUBST ; PS1='[%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%m%{$reset_color%} %{$fg[cyan]%}%c$(__git_ps1 " (%s)")%{$reset_color%}]\$ ' 
