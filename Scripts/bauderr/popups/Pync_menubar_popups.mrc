&Bauderr System
$iif((!$var(%bde_glob_*history*,0)),$style(2)) erase history : unset %bde_glob_*history* | eecho you have erased your history.
$iif(($os isin 7,10,11),&set client faster (High)) : eecho changed priority of all running $nopath($mircexe) and Python apps to 'High' | run -hn wmic process where name=" $+ $nopath($mircexe) $+ " CALL setpriority 128 | run -hn wmic process where name="python.exe" CALL setpriority 128 | run -hn wmic process where name="py.exe" CALL setpriority 128 | run -hn wmic process where name="python3.exe" CALL setpriority 128
-
unstick folders
.info : eecho Unstick folders you do not have access to and cannot access nor delete.
.-
..folder ? : unstick
..$submenu($unstick_folders($1))
-
create shortcuts
.this user desktop : create_shortcuts_desktop 
.mirc.ini directory : create_shortcuts_mirc
.-
.desktop and mirc dir : create_shortcuts_both
