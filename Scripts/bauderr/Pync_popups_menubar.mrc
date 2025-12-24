&Bauderr System
$iif((!$var(%bde_glob_*history*,0)),$style(2)) erase history : unset %bde_glob_*history* | eecho you have erased your history.
$iif(($os isin 7,10,11),&set client faster (High)) : eecho changed priority of all running $nopath($mircexe) and Python apps to 'High' | run -hn wmic process where name=" $+ $nopath($mircexe) $+ " CALL setpriority 128 | run -hn wmic process where name="python.exe" CALL setpriority 128 | run -hn wmic process where name="py.exe" CALL setpriority 128 | run -hn wmic process where name="python3.exe" CALL setpriority 128
-
server commands
.knock room $chan : /raw knock $$chan
.help 
..help : raw help
..help help : raw help help
..helpop : raw helpop
.-
.info : raw info
.time : raw time
.-
.users : raw users
.long users : raw lusers
.-
.list channels : list
.server links : raw links
-
create shortcuts
.$create_shortcuts_style this user desktop : create_shortcuts_desktop 
.$create_shortcuts_style mirc.ini directory : create_shortcuts_mirc
.-
.$create_shortcuts_style desktop and mirc dir : create_shortcuts_both
