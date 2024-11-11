on *:signal:baud_unload: {
  Pync_set_app
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
alias baud_load_all {
  Pync_set_app
  signal -n baud_unload
  load -rs $qt($scriptdirScripts\bauderr\Pync_history.mrc)
  load -rs $qt($scriptdirScripts\bauderr\Pync_menus.mrc)
  load -rs $qt($scriptdirScripts\bauderr\Pync_no-category.mrc)
  load -ps $qt($scriptdirScripts\bauderr\Pync_popups.ini)
  load -pc $qt($scriptdirScripts\bauderr\Pync_popups.ini)
  load -pq $qt($scriptdirScripts\bauderr\Pync_popups.ini)
  load -pn $qt($scriptdirScripts\bauderr\Pync_popups.ini)
  load -pm $qt($scriptdirScripts\bauderr\Pync_popups.ini)
  var %fn = Pync_Users-for- $+ %Pync_app $+ .mrc
  var %fn = Pync_Vars-for- $+ %Pync_app $+ .mrc
  if (%Pync_app == adiirc) {
    /load -ru $qt($scriptdirScripts\bauderr\adiirc\ $+ %fn)
    /load -rv $qt($scriptdirScripts\bauderr\adiirc\ $+ %fn)
  }
  else {
    /load -ru $qt($scriptdirScripts\bauderr\ $+ %fn)
    /load -rv $qt($scriptdirScripts\bauderr\ $+ %fn)  
  }
}
alias -l Pync_set_app {
  if (adiirc isin $mircexe) { set %Pync_app Adiirc }
  if (mirc isin $mircexe) { set %Pync_app mIRC }
  if ($version < 6.0) { set %Pync_app Adiirc }
  if ($version > 7.4) { set %Pync_app mIRC }
}
