
on *:signal:baud_unload: {
  Pync_set_app
  var %i = 1
  while ($script(%i)) {
    var %script = $ifmatch
    if (!$exists(%script)) || (($nofile(%script) != $scriptdirbauderr\) && (Pync_ isin %script)) {
      unload -nrs %script
      continue
    }
    inc %i
  }
}
on *:load: {
  baud_load_all
}
on *:start: {
  Pync_set_app
}
on *:unload: {
  Pync_set_app
}
alias test {
  echo >> $scriptdir
}
alias baud_load_all {
  signal -n baud_unload
  load -rs $qt($scriptdirbauderr\Pync_history.mrc)
  load -rs $qt($scriptdirbauderr\Pync_menus.mrc)
  load -rs $qt($scriptdirbauderr\Pync_no-category.mrc)
  load -ps $qt($scriptdirbauderr\popups\Pync_status_popups.mrc)
  load -pc $qt($scriptdirbauderr\popups\Pync_channel_popups.mrc)
  load -pq $qt($scriptdirbauderr\popups\Pync_query_popups.mrc)
  load -pn $qt($scriptdirbauderr\popups\Pync_nicklist_popups.mrc)
  load -pm $qt($scriptdirbauderr\popups\Pync_menubar_popups.mrc)
  var %fn = Pync_Users-for- $+ %Pync_app $+ .mrc
  var %fn = Pync_Vars-for- $+ %Pync_app $+ .mrc
  if (%Pync_app == adiirc) {
    /load -ru $qt($scriptdirbauderr\users_vars\Adiirc\ $+ %fn)
    /load -rv $qt($scriptdirbauderr\users_vars\Adiirc\ $+ %fn)
  }
  else {
    /load -ru $qt($scriptdirbauderr\users_vars\mIRC\ $+ %fn)
    /load -rv $qt($scriptdirbauderr\users_vars\mIRC\ $+ %fn)  
  }
  Pync_set_app
  if (!%sreq ) {
    sreq +m
  }
  if (!%creq ) {
    creq -m
  }
}
alias creq {
  if ($1 == +m) { /set -n $varname_global(creq) +m }
  elseif ($1 == -m) { /set -n $varname_global(creq) -m }
  creq $1-
}
alias sreq {
  if ($1 == +m) { /set -n $varname_global(sreq) +m }
  elseif ($1 == -m) { /set -n $varname_global(sreq) -m }
  sreq $1-
}
alias -l Pync_set_app {
  if ($version < 7.50) { set %Pync_app Adiirc }
  if ($version > 7.50) { set %Pync_app mIRC }
  if (adiirc isin $mircexe) { set %Pync_app Adiirc }
  if (mirc isin $mircexe) { set %Pync_app mIRC }
  background -mf $qt($scriptdirBauderr\images\background.jpg)
  font -z 10 japaneze text
}
