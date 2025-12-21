
on *:signal:baud_unload: {
  Pync_set_app
  var %i = 1
  while ($script(%i)) {
    var %script = $ifmatch
    if (%script != $script) && (($qt($nofile(%script)) != $qt($scriptdirbauderr\)) && (baFESTuderr isin %script)) || (!$exists(%script)) {
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
  load -ps $qt($scriptdirbauderr\Pync_popups.ini)
  load -pc $qt($scriptdirbauderr\Pync_popups.ini)
  load -pq $qt($scriptdirbauderr\Pync_popups.ini)
  load -pn $qt($scriptdirbauderr\Pync_popups.ini)
  load -pm $qt($scriptdirbauderr\Pync_popups.ini)
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
  if ($2 == auto) {
    if ($1 == +m) { /set -n %creq +m }
    elseif ($1 == -m) { /set -n %creq -m }
  }
  creq $1-
}
alias sreq {
  if ($2 == auto) {
    if ($1 == +m) { /set -n %sreq +m }
    elseif ($1 == -m) { /set -n %sreq -m }
  }
  sreq $1-
}
alias -l Pync_set_app {
  if (adiirc isin $mircexe) { set %Pync_app Adiirc }
  if (mirc isin $mircexe) { set %Pync_app mIRC }
  if ($version < 7.0) { set %Pync_app Adiirc }
  if ($version > 7.0) { set %Pync_app mIRC }
  background -mf $scriptdirBauderr\images\background.jpg
}
