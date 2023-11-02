on *:start:exp_topics
on *:exit:exp_topics
on *:load:exp_topics
on *:connect:exp_topics
alias style_add_topic_history {
  if ($chan($chan).topic == $null) { return $style(2) }
  var %topic = $eval($var($varname_global(topic_history_ $+ $chan,*),1),2)
  var %i = 1
  while %topic {
    if (%topic == $chan($chan).topic) { return $style(3) }
    inc %i
    %topic = $eval($var($varname_global(topic_history_ $+ $chan,*),%i),2)
  }
}

alias is_topic {
  if ($topic_history_pops($$1).topic == $chan($chan).topic) { return $true }
  else { return $false }
}

alias style_topic_history_on {
  if ($varname_global(topic_history_switch,on).value != $false) { return $style(1) }
}
alias topic_history_switch_on {
  if ($varname_global(topic_history_switch,on).value != $false) { set $varname_global(topic_history_switch,on) $false | eecho topic history switched [OFF] }
  else { set $varname_global(topic_history_switch,on) $true | eecho topic history switched [ON] }

}
alias exp_topics {
  var %check = $varname_global(topic_history_*,*)
  var %i = 0
  :loop
  inc %i
  set -ln %check2 $var($eval(%check,1),%i)
  if (%check2 == $null) { return }
  if ($calc($ctime - $gettok(%check2,-1,35)) > $calc(60 * 60 * 24 * 21)) { unset $eval(%check2,1) | dec %i }
  goto loop
}
on *:topic:#: {
  if ($1 == $null) { return }
  var %i = 0
  var %check = $varname_global(topic_history_ $+ #,*)
  var %varname
  :loop
  inc %i
  if (%i > 10) { return }
  %varname = $var($eval(%check,1),%i)
  if (!%varname) { goto end }
  if ([ [ %varname ] ] === $1-) { return }
  goto loop
  :end
  var %t = $+(topic_add-,$network,-,$chan)
  if ($chan($chan).topic == $null) { .timer $+ %t off | return }
  else { .timer $+ %t -o 1 35 /topic_history_add $chan $1- }
}
raw 332:*: {
  var %t = $+(topic_add-,$network,-,$chan)
  .timer $+ %t -o 1 35 /topic_history_add $2 $3-
}
alias topic_history_remove {
  unset $var($varname_global(topic_history_ $+ $$chan,*),$$1)
}
alias topic_history_add {
  if ($varname_global(topic_history_switch,on).value == $false) { return }
  exp_topics
  var %chan = $1
  if ($len(%chan) < 2) || ($left(%chan,1) != $chr(35)) { return }
  if ($var($varname_global(topic_history_ $+ %chan,*),0) >= 10) { remove_oldest_topic %chan }
  set -ln %topic $strip($2-)
  set -ln %topic_32 $remove(%topic,$chr(32))
  if (%topic_32 == $null) { return }
  var %i = 0
  var %check = $varname_global(topic_history_ $+ %chan,*)
  var %varname
  :loop
  inc %i
  if (%i > 10) { return }
  %varname = $var($eval(%check,1),%i)
  if (!%varname) { goto end }
  if ([ [ %varname ] ] === $2-) { return }
  goto loop
  :end
  set -n $varname_global(topic_history_ $+ %chan,$ctime) $2-
}
alias remove_oldest_topic {
  var %chan = #$$1
  var %i = 0
  var %oldctime = 0
  var %newtime = 0
  :loop
  inc %i
  %newctime = $gettok($var($varname_global(topic_history_ $+ %chan,*),%i),-1,35)
  if (%newctime == $null) { goto end }
  if (%newctime >= %oldctime) { %oldctime = %newctime }
  goto loop
  :end
  if (%oldctime) { unset $varname_global(topic_history_ $+ %chan,%oldctime)  }
}
alias topic_history_pops {
  if ($var($varname_global(topic_history_ $+ $$chan,*),$1) == $null) { halt }
  var %pop = $var($varname_global(topic_history_ $+ $active,*),$1).value
  if (!%pop) { return }
  if ($prop == topic) { return %pop }
  var %pop = $strip(%pop)
  if ($len(%pop) > 60) { return $left(%pop, 58) $+ ... }
  else { return %pop }
}
