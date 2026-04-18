if status is-interactive
  fish_vi_key_bindings
  set -g fish_greeting
end

# peon-ping quick controls
function peon; bash /home/samflores/.claude/hooks/peon-ping/peon.sh $argv; end
