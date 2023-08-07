on *:signal:baud_unload: {
  mg_set_app
}
on *:load: {
  baud_load_all
}
on *:start: {
  mg_set_app
}
on *:unload: {
  mg_set_app
}
alias baud_load_all {
  mg_set_app
  signal -n baud_unload
  load -rs $qt($scriptdirScripts\bauderr\MG_history.mrc)
  load -rs $qt($scriptdirScripts\bauderr\MG_menus.mrc)
  load -rs $qt($scriptdirScripts\bauderr\MG_no-category.mrc)
  load -ps $qt($scriptdirScripts\bauderr\MG_popups.ini)
  load -pc $qt($scriptdirScripts\bauderr\MG_popups.ini)
  load -pq $qt($scriptdirScripts\bauderr\MG_popups.ini)
  load -pn $qt($scriptdirScripts\bauderr\MG_popups.ini)
  load -pm $qt($scriptdirScripts\bauderr\MG_popups.ini)
  var %fn = MG_Users-for- $+ %mg_app $+ .mrc
  /load -ru $qt($scriptdirScripts\bauderr\ $+ %fn)
  var %fn = MG_Vars-for- $+ %mg_app $+ .mrc
  /load -rv $qt($scriptdirScripts\bauderr\ $+ %fn)
}
alias -l mg_set_app {
  if (adiirc isin $mircexe) { set %mg_app Adiirc }
  if (mirc isin $mircexe) { set %mg_app mIRC }
  if ($version < 6.0) { set %mg_app Adiirc }
  if ($version > 7.4) { set %mg_app mIRC }
}
