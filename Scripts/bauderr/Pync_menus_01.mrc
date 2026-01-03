
alias joinall {
  var %i = 1, %chan_c = 0
  while ($chan(%i)) {
    if (join* iswm $chan(%i).status) { inc %i | continue }
    else { inc %chan_c | inc %i }
  }
  if (%chan_c < 1) { echo $color(info) -ae * no channels to rejoin. | return }
  echo $color(info) -ae * rejoining %chan_c channels...
  var %i = 1 | unset %chan_c
  while ($chan(%i)) {
    if (join* !iswm $chan(%i).status) { join $chan(%i) }
    inc %i
  }
}
alias rejoin /joinall

alias style_joinall {
  var %i = 1
  while ($chan(%i)) {
    if (join* iswm $chan(%i).status) { inc %i | continue }
    else { return }
  }
  return $style(3)
}
alias style_show_away {
  if ($bool($varname_cid(show_away,enabled).value) == $true) { return $style(1) }
}
alias style_auto_join {
  if ($varname_cid(auto_join,on).value == $true) { return $style(1) }
}
on *:text:*:*Status: {
  tokenize 32 $strip($1-)
  if ($1- iswm auto-join ?*) && ($43== $null) {
    set $varname_cid(auto_join,on) $bool($3)
  }
  if ($1- == auto-join #?* ?*) {
    set $varname_cid(auto_join,$2) $bool($3)
  }
  if ($1- iswm auto-identify-room #?*) {
    set $varname_cid(auto-identify-room,$$2) $bool($$4)
  }
  if ($1- iswm anti-idle ?*) {
    set $varname_cid(anti-idle,enabled) $bool($2)
  }
  if ($1- iswm show-away ?*) {
    set $varname_cid(show_away,enabled) $3s $bool($4)
  }
}
alias star return *
alias toggle_auto_join {
  if ($varname_cid(auto_join,on).value == $true) { unset $varname_cid(auto_join,on) }
  else { set $varname_cid(auto_join,on) $true }
}
alias set_show_away {
  if ($1 <= 2) && ($1 >= 0)  { setvar $varname_global(show_away,enabled $iif(($1 == 0),$false,$iif(($1 == 1),notice,privmsg)} }
}
alias advertise-chan {
  if ($status != connected) { return }
  if ($chan != $null) { return this channel }
}
alias advertise-in-channel {
  if ($status != connected) { return }
  if ($chan(0) > 0) { return in channel }
}
alias advertise-chan-00 {
  if ($status != connected) { return }
  if ($chan(1) != $null) { return $chan(1) }
}
alias advertise-chan-01 {
  if ($status != connected) { return }
  if ($chan(2) != $null) { return $chan(2) }
}
alias advertise-chan-02 {
  if ($status != connected) { return }
  if ($chan(3) != $null) { return $chan(3) }
}
alias advertise-chan-03 {
  if ($status != connected) { return }
  if ($chan(4) != $null) { return $chan(4) }
}
alias advertise-chan-04 {
  if ($status != connected) { return }
  if ($chan(5) != $null) { return $chan(5) }
}
alias advertise-chan-05 {
  if ($status != connected) { return }
  if ($chan(6) != $null) { return $chan(6) }
}
alias advertise-chan-06 {
  if ($status != connected) { return }
  if ($chan(7) != $null) { return $chan(7) }
}
alias advertise-chan-07 {
  if ($status != connected) { return }
  if ($chan(8) != $null) { return $chan(8) }
}
alias advertise-chan-08 {
  if ($status != connected) { return }
  if ($chan(9) != $null) { return $chan(9) }
}
alias advertise-chan-09 {
  if ($status != connected) { return }
  if ($chan(10) != $null) { return $chan(10) }
}
alias advertise-this-connection {
  if ($status != connected) { return }
  if ($chan(0) == 0) { return }
  return all chans on this connection
}
alias advertise-network {
  if ($network == $null) { return }
  return chans on network $network
}
alias advertise-this-client {
  return everywhere on this client
}
alias advertise-user {
  return all proxy user $varname_cid(trio-ircproxy.py, is_user).value
}
alias block {
  if (strip($1) == $null) { return }
  return $chr(91) $+ $1- $+ $chr(93)
}
alias style_net_chan_link {
  if (!$chan) { return }
  if ($varname_global(network-link,$chan).value) { return $style(1) }
}
alias dq {
  echo State: $iif($dqwindow & 1,enabled,not enabled)
  echo State: $iif($dqwindow & 2,open,not open)
  echo State: $iif($dqwindow & 4,opening,not opening)
  echo State: $iif($dqwindow & 8,writing,not writing)
  echo State: $iif($dqwindow & 16,written,not written)
}
alias chan_identify {
  if ($1 !isnum) || ($1 < 1) { return }
  var %room = $varname_network(room_with_login,$1).value
  if (%room == $null) && ($1 == 1) { return $style(2) No such rooms }
  return %room
}
menu menubar {



}
menu Status,Channel {
  $chr(46) $chr(58) PyNet Converge $str($chr(58),2) $chr(58)
  .$style_proxy $chr(46) $chr(58) describe pync $str($chr(58),2) $chr(58)
  ..$advertise-chan : /describe $chan is using PyNet Converge mSL script named Bauderr. use ctcp version/script/proxy/source for more info.
  ..$advertise-in-channel
  ...$advertise-chan-00 : /bauderr-advertise --chan $chan(1)
  ...$advertise-chan-01 : /bauderr-advertise --chan $chan(2)
  ...$advertise-chan-02 : /bauderr-advertise --chan $chan(3)
  ...$advertise-chan-03 : /bauderr-advertise --chan $chan(4)
  ...$advertise-chan-04 : /bauderr-advertise --chan $chan(5)
  ...$advertise-chan-05 : /bauderr-advertise --chan $chan(6)
  ...$advertise-chan-06 : /bauderr-advertise --chan $chan(7)
  ...$advertise-chan-07 : /bauderr-advertise --chan $chan(8)
  ...$advertise-chan-08 : /bauderr-advertise --chan $chan(9)
  ...$advertise-chan-09 : /bauderr-advertise --chan $chan(10)
  ..$advertise-this-connection : /bnc_msg advertise-connection
  ..$advertise-network : bnc_msg --advertise-network-with-bauderr
  ..$advertise-this-client : /scon -a /ame is using PyNet Converge mSL script named Bauderr. use ctcp version/script/source for more info.
  ..$advertise-user : bnc_msg advertise-username-with-bauderr
  ..everywhere possible : bnc_msg --advertise-everywhere-with-bauderr
  -
  &client cmnds
  .open &downloads folder : run $getdir
  .-
  .[&auto-join invite]
  ..o&ff : ajinvite off
  ..[&on] : ajinvite on
  .-
  .&a/q/op-message
  ..&amsg : amsg $$input(Speak your message to all channels:,eygbqk60,type your message to all channels,I hear'd everyone is welcome to room 5ioE on Undernet.)
  ..&ame : ame $$input(Describe your action to all channels:,eygbqk60,describe your action to all channel,wonders who is in room 5ioE on Undernet)
  ..-
  ..&qmsg : qmsg $$input(Speak your message to all query windows:,eygbqk60,speak your message to all query windows,anyone know what /amsg does?)
  ..&qme : qme $$input(Describe your action to all query windows:,eygbqk60,describe your action to all query windows,wonders what /qme will do...)
  ..-
  ..&op notice : onotice-script
  ..&op message : omsg-script
  ..-
  ..&info : eecho amsg/ame: message/action to all channels. qmsg/qme: message/action to all open query windows. op-notice/op-message: message/notice to all ops in a channel.
  .-
  .un/ban
  ..remove ban : ban -r $iif($chan,$ifmatch,$gettok($$?="enter room name:",1,32)) $$?="enter nick and type or ban mask:"
  ..add ban : ban -bu700 $iif($chan,$ifmatch,$gettok($$?="enter room name:",1,32)) $$?="enter ban mask or nick and type:"
  ..ban kick : ban -ku700 $iif($chan,$ifmatch,$gettok($$?="enter room name:",1,32)) $$?="enter nickname and ban type [sum1znick 2] and kick message:"
  ..quiet ban : ban -q $iif($chan,$ifmatch,$gettok($$?="enter room name:",1,32)) $$?="enter nick and type:"
  ..-
  ..invite : ban -I $iif($chan,$ifmatch,$gettok($$?="enter room name:",1,32)) $$?="enter nick mask"
  ..ban except : ban -e $iif($chan,$ifmatch,$gettok($$?="enter room name:",1,32)) $$?="enter nick mask:"
  .[channnel dialog] : channel $iif($chan,$ifmatch,$gettok($$?="enter room name:",1,32))
  .-
  .clear status : clear -s
  .clear active : clear -a
  .[clear all]
  ..status : clearall -s
  ..channels : clearall -c
  ..querys : clearall -q
  ..chat : clearall -t
  ..messages : clearall -m
  ..-
  .[close dcc]
  ..gets : close -g
  ..sends : close -s
  ..fserve : close -f
  ..chats : close -c
  ..-
  ..[inactive] : close -i
  .-
  .chat request $block($iif($creq == auto,auto-accept $varname_global(creq).value,$creq))
  ..$iif(($creq $varname_global(creq).value == auto +m),$style(1)) auto-accept minimize : creq +m auto
  ..$iif(($creq == auto && $varname_global(creq).value != +m),$style(1)) [auto-accept active] : creq -m auto
  ..-
  ..$iif($creq == ask,$style(1)) ask : creq ask
  ..$iif($creq == ignore,$style(1)) ignore : creq ignore
  .send request $block($iif($sreq == auto,auto-accept $varname_global(sreq).value,$sreq))
  ..$iif(($sreq $varname_global(sreq).value == auto +m),$style(1)) [auto-accept minimize] : sreq +m auto
  ..$iif(($sreq == auto && $varname_global(sreq).value != +m),$style(1)) auto-accept active : sreq -m auto
  ..-
  ..$iif($sreq == ask,$style(1)) ask : sreq ask
  ..$iif($sreq == ignore,$style(1)) ignore : sreq ignore
  .-
  .dns
  ..nick : dns -46 $$?="enter nickname:"
  ..host : dns -h46 $$?="enter hostname:"
  .-
  .$iif(($donotdisturb == $true),$style(1)) do not disturb : /donotdisturb $iif(($donotdisturb == $true),off,on)
  .[color Bauderr-theme] : color -s bauderr
  .-
  .nickname
  ..previous nicknames
  ...$oldnick_menu(1)
  ....&current nick : nick $oldnick_menu(1)
  ....&temporary nickname : tnick $oldnick_menu(1)
  ....-
  ....&main nickname : mnick $oldnick_menu(1)
  ....&alternate nickname : anick $oldnick_menu(1)
  ...$oldnick_menu(2)
  ....&current nick : nick $oldnick_menu(1)
  ....&temporary nickname : tnick $oldnick_menu(1)
  ....-
  ....&main nickname : mnick $oldnick_menu(2)
  ....&alternate nickname : anick $oldnick_menu(2)
  ...$oldnick_menu(3)
  ....&current nick : nick $oldnick_menu(1)
  ....&temporary nickname : tnick $oldnick_menu(1)
  ....-
  ....&main nickname : mnick $oldnick_menu(3)
  ....&alternate nickname : anick $oldnick_menu(3)
  ...$oldnick_menu(4)
  ....&current nick : nick $oldnick_menu(1)
  ....&temporary nickname : tnick $oldnick_menu(1)
  ....-
  ....&main nickname : mnick $oldnick_menu(4)
  ....&alternate nickname : anick $oldnick_menu(4)
  ...$oldnick_menu(5)
  ....&current nick : nick $oldnick_menu(1)
  ....&temporary nickname : tnick $oldnick_menu(1)
  ....-
  ....&main nickname : mnick $oldnick_menu(5)
  ....&alternate nickname : anick $oldnick_menu(5)
  ...$oldnick_menu(6)
  ....&current nick : nick $oldnick_menu(1)
  ....&temporary nickname : tnick $oldnick_menu(1)
  ....-
  ....&main nickname : mnick $oldnick_menu(6)
  ....&alternate nickname : anick $oldnick_menu(6)
  ...$oldnick_menu(7)
  ....&current nick : nick $oldnick_menu(1)
  ....&temporary nickname : tnick $oldnick_menu(1)
  ....-
  ....&main nickname : mnick $oldnick_menu(7)
  ....&alternate nickname : anick $oldnick_menu(7)
  ...$oldnick_menu(8)
  ....&current nick : nick $oldnick_menu(1)
  ....&temporary nickname : tnick $oldnick_menu(1)
  ....-
  ....&main nickname : mnick $oldnick_menu(8)
  ....&alternate nickname : anick $oldnick_menu(8)
  ...$oldnick_menu(9)
  ....&current nick : nick $oldnick_menu(1)
  ....&temporary nickname : tnick $oldnick_menu(1)
  ....-
  ....&main nickname : mnick $oldnick_menu(9)
  ....&alternate nickname : anick $oldnick_menu(9)
  ...$oldnick_menu(10)
  ....&current nick : nick $oldnick_menu(1)
  ....&temporary nickname : tnick $oldnick_menu(1)
  ....-
  ....&main nickname : mnick $oldnick_menu(10)
  ....&alternate nickname : anick $oldnick_menu(10)
  ..-
  ..current nick ? : nick $$?="Enter your main nickname:"
  ..&temporary nick ? : tnick $$?="enter your temporary nickname:"  
  ..&main nick ? : mnick $$?="enter your main nickname:"
  ..&alternate nick ? : anick $$?="enter your alternate nickname:"
  .[&set email && name]
  ..&email addr : /emailaddr bauderr-script
  ..&fullname : /fullname .: bauderr-script :: : @ www.MyProxyIP.com
  ..-
  ..[&set both] : /emailaddr bauderr-script | /fullname .: bauderr-script :: : @ www.MyProxyIP.com
  .-
  .&reset idle $block($duration($idle)) : /resetidle $?="enter number of seconds:"
  .-
  .&exit %pync_app
  ..exit : exit -n
  ..restart : exit -nr

  &server cmnds
  .&basic
  ..[help] 
  ...[help] : raw help
  ...help help : raw help help
  ...help helpop : raw helpop
  ..[info] : raw info
  ..-
  ..[user modes] : raw help umode
  ..[room modes] : raw help cmode
  ..-
  ..time : raw time
  ..-
  ..users : raw users
  ..long users : raw lusers
  .
  .&status
  .uptime : stats u
  .operator : stats o
  .admins : stats p
  .userload stats : stats w

  .&silence : var %y = $iif($$?!="Yes = silence $+ $crlf No = un-silence $+ $crlf $+ Yes/No = for the list",+,-) | var %n = $input(Enter a nick or nickmask to silence $+ $crlf $+ or leave blank for list:,eoygbq,Enter a nick or nickmask,nick*!user*@host.???) | silence $iif(%n,%y $+ %n)
  .-
  .user-modes
  ..&set mode
  ...$submenu($usermodes-menu($1,unet,+))
  ...-
  ...$submenu($usermodes-menu($1,onet,+))
  ..&unset mode
  ...$submenu($usermodes-menu($1,unet,-))
  ...-
  ...$submenu($usermodes-menu($1,onet,-))
  .-
  .part room
  ..$submenu($menu_parted($1))
  ..-
  ..$style_parted_rooms close parted rooms : close_parted
  ..$style_part_all_rooms part all rooms : !partall .: PyNet Converge script named Bauderr :: :
  .[join room] 
  ..$submenu($parted_rooms($1))
  ..-
  ..$style_joinall rejoin all rooms : joinall
  ..[new room] : join $$input(Type a room name to join:,eoygbqk60,Type a room name to join,#5ioE)
  .knock room : /raw knock $input(Knock on what room?,egbqd,Enter a room name to knock,$iif($chan,$chan,#5ioE))
  .-
  .$iif(($status != connected),$style(2)) [motd] 
  ..$chr($asc([)) $+ $server $+ $chr($asc(])) : motd
  ..MyProxyIP.com : msg *status show-motd mypyip
  ..-
  ..on connect
  ...$iif($proxy_style,$ifmatch,$iif($varname_global(on-connect,show-motd).value == mypyip,$style(1))) [show MyProxyIP.com] : msg *status on-connect show-motd mypyip
  ...$iif($proxy_style,$ifmatch,$iif($varname_global(on-connect,show-motd).value != mypyip,$style(1))) show irc server : msg *status on-connect show-motd
  ...-
  ...$iif($proxy_style,$ifmatch,$iif(($bool($varname_global(motd_window).value)),$style(1))) show in custom window : setvar $varname_global(motd_window) $iif(($bool($varname_global(motd_window).value)),$false,$true)
  .-
  .whois query
  ..$submenu($query_menu($1))
  .-
  .[list rooms] : list
  .server links : links
  .-
  .accept messages ? : accept [ [ $input(Enter a nickmask $+ $crlf $+ to accept messages from while +g or +G:,egbqd,Enter a nickmask,nick*!*user*@host.???) ] ]
  .-
  .quit : quit : :: Trio-ircproxy.py & PyNet Converge script named Bauderr : .  
  -
  script &functions
  .$iif($bool($varname_cid(anti-idle,enabled).value) == $true,$style(1)) set ant&i-idle : {
    msg *Status anti-idle $iif($bool($varname_cid(anti-idle,$active).value) == $true,off,on)
  }
  .-
  .[set &auto-away]
  .$style_show_away [&show away nicks]
  ..$style_show_away_note [notice] : set_show_away 1
  ..$style_show_away_priv private message : set_show_away 2
  ..-
  ..$style_show_away_not do not show : set_show_away 0
  .-
  .$style_auto_join [auto-join &room]
  ..$iif(!$chan,$style(2)) [&add this room] : msg *Status auto-join add $network $chan $chan($chan).key
  ..$iif(!$chan,$style(2)) &remove this room : msg *Status auto-join remove $network $chan
  ..-
  ..&add a room : {
    var %net = $$input(Enter a network:,eygfqda,Auto-join on what network?,all-networks)
    if (%net == $false) { return }
    var %chan = #$$input(Enter a room:,eygfqda,Auto-join what room?,$iif($active ischan,$active,$chr(35)))
    if (%chan == $false) || (%chan == $chr(35)) { return }
    var %pass = $input(Enter the password if needed:,eygfqda,Does the room need a password?)
    msg *Status autjoin add %net %chan %pass
  }
  ..&remove a room {
    var %net = $$input(Enter a network:,eygfqda,Remove from which network?,all-networks)
    if (%net == $false) { return }
    var %chan = #$$input(Enter a room to remove:,eygfqda,Remove which room?,$iif($active ischan,$active,$chr(35)))
    if (%chan == $false) || (%chan == $chr(35)) { return }
    msg *Status autjoin remove %net %chan
  }
  ..-
  ..$style_auto_join [&switch on] : toggle_auto_join
  .-
  .[&ascii-art]
  ..&stop play
  ..pl&ay here
  ...[select file]
  .[&bin-art]
  ..&stop play
  ..[pl&ay here]
  ...[select file]
  .[&sounds]
  ..stop play : splay stop
  ..[play here]
  ...$submenu($play-sound-history($1))
  ...[select file] : play-sound $iif($active == $chan || $active == $nick,$ifmatch,$gettok($$?="enter a room or nickname to play to:",1,32)) $qw($sfile($sound($INPUT(Select a sound folder source:,ygbqdum,select a sound folder source,$active,mp3,midi,ogg,wma,wave)),*.mp3;*.ogg;*.wma;*.mid;*.wav),Select a sound file:, Play))
  &room functions
  .[&sticky part]
  ..$style_sticky_menu [turn on] : msg *status sticky-part $iif(($bool($varname_cid(sticky-part).value) == $true),off,on)
  ..info : var %msg = * Sticky part means when you part a channel in your client you still remain on the channel however, channel activity is hidden from you | if ($active != Status Window) { echo $color(info) -ae %msg } | echo $color(info) -s %msg
  .[ial-fill]
  ..$submenu($ialupdate_menu($1))
  ..-
  ..$iif((!$ial),$style(2)) room ? : if ($ial) { ialfill -f $$input(Type a room:,eoygbqk60,type a room,#5ioE) }
  ..$iif(($ial),$style(1)) turn on IAL : ial $$iif((!$ial),on,off)
  .-
  .$style_topic_history_on &topi&c history
  ..$iif($is_topic(1),$style(1)) $topic_history_pops(1)
  ...&set this topic : /editbox /topic $chan $topic_history_pops(1).topic
  ...-
  ...&remove from history : topic_history_remove 1
  ..$iif($is_topic(2),$style(1)) $topic_history_pops(2)
  ...&set this topic : /editbox /topic $chan $topic_history_pops(2).topic
  ...-
  ...&remove from history : topic_history_remove 2
  ..$iif($is_topic(3),$style(1)) $topic_history_pops(3)
  ...&set this topic : /editbox /topic $chan $topic_history_pops(3).topic
  ...-
  ...&remove from history : topic_history_remove 3
  ..$iif($is_topic(4),$style(1)) $topic_history_pops(4)
  ...&set this topic : /editbox /topic $chan $topic_history_pops(4).topic
  ...-
  ...&remove from history : topic_history_remove 4
  ..$iif($is_topic(5),$style(1)) $topic_history_pops(5)
  ...&set this topic : /editbox /topic $chan $topic_history_pops(5).topic
  ...-
  ...&remove from history : topic_history_remove 5
  ..$iif($is_topic(6),$style(1)) $topic_history_pops(6)
  ...&set this topic : /editbox /topic $chan $topic_history_pops(6).topic
  ...-
  ...&remove from history : topic_history_remove 6
  ..$iif($is_topic(7),$style(1)) $topic_history_pops(7)
  ...&view this topic : topic $chan
  ...&set this topic : /editbox /topic $chan $topic_history_pops(7).topic
  ...-
  ...&remove from history : topic_history_remove 7
  ..$iif($is_topic(8),$style(1)) $topic_history_pops(8)
  ...&view this topic : topic $chan
  ...&set this topic : /editbox /topic $chan $topic_history_pops(8).topic
  ...-
  ...&remove from history : topic_history_remove 8
  ..$iif($is_topic(9),$style(1)) $topic_history_pops(9)
  ...&view this topic : topic $chan
  ...&set this topic : /editbox /topic $chan $topic_history_pops(9).topic
  ...-
  ...&remove from history : topic_history_remove 9
  ..$iif($is_topic(10),$style(1)) $topic_history_pops(10)
  ...&view this topic : topic $chan
  ...&set this topic : /editbox /topic $chan $topic_history_pops(10).topic
  ...-
  ...&remove from history : topic_history_remove 10
  ..-
  ..$style_add_topic_history &add this topic to history : topic $chan
  ..$iif(!#$chan,$style(2),iif(($chan(#).topic == $null),$style(3))) &unset topic : /raw topic $chan :
  ..-
  ..$iif((!#$chan),$style(2),$iif(($eval($var($varname_global(topics_history_ $+ $chan,*),1),1) == $null),$style(3))) erase topic history for room : unsetvar $varname_global(topics_history_ $+ $chan,*) | eecho -sep topic history cleared for room $chan
  ..$iif(($var($varname_global(topic_history_*,*),0) == 0),$style(3)) erase entire topic history : unsetvar $varname_global(topic_history_*,*) | eecho -sep topic history for ALL channels is cleared
  ..-
  ..$style_topic_history_off switch off topic history : topic_history_switch_on
  .-
  .&room-modes
  ..raw cmode on Rizon | raw help cmode
  ..$style_isop b - ban user : mode $chan $iif($$?!="Yes = set ban $+ $crlf $+ No = unset ban ",+,-) $+ b $input(Enter the nickmask to (un)ban $+ $crlf $+ leave blank to list current hostnames:,egbqd,Nickmask?,*nick*!user??@*host.???)
  ..$style_isop I - invite except : mode $chan $iif($?!="Yes = set invite except $+ $crlf $+ No = unset invite except",+,-) $+ I $input(Enter the nickmask to (un)invite except $+ $crlf $+ leave blank to list current hostnames:,egbqd,Nickmask?,*nick*!user??@*host.???)
  ..$style_isop e - ban except : mode $chan $iif($?!="Yes = set ban except $+ $crlf $+ No = unset ban except",+,-) $+ e $input(Enter the nickmask to (un)ban except $+ $crlf $+ leave blank to list current hostnames:,egbqd,Nickmask?,*nick*!user??@*host.???)

  ..$style_isop m - normal users cannot speak : mode $chan $iif($$?!="Yes = set moderated $+ $crlf $+ No = unset moderated",+,-) $+ m 
  ..$style_isop &M - normal && unidentified users cannot speak : mode $chan $iif($$?!="Yes = set Modreg $+ $crlf $+ No = unset Modreg",+,-) $+ M

  ..$style_isop i - invite only : mode $chan $iif($$?!="Yes = set invite opnly $+ $crlf $+ No = unset invite only",+,-) $+ i
  ..$style_isop R - only registered nicks join : mode $chan +R
  ..$style_isop r - unidentified users may not speak : mode $chan +r
  ..$style_isop N - normal users cannot send notices : mode $chan +N
  ..$style_isop C - normal users cannot send CTCPs : mode $chan +C
  ..$style_isop B - `who idle/away for 20 minutes cannot hear : mode $chan +B
  ..$style_isop S - SSL may only join : mode $chan +S
  ..$style_isop R - registered only may join : mode $chan +R
  ..$style_isop P - paranoia mode : mode $chan +P




  .[&allow prevention]
  ..$style_allow_ascii &allow ascii-art
  ...$style_allow_paste &allow paste 25 lines : set_allow_room_paste
  ...$style_allow_long_word &allow long words : set_allow_room_long_word
  ...$style_allow_line &allow long lines : set_allow_room_long_line
  ...$style_allow_repeat &allow repeat 6x : set_allow_room_repeat
  ...$style_allow_rand_text [&allow random text] : set_allow_room_random_text
  ...-
  ...$style_allow_ascii allow ascii-art (Every Thing) : set_allow_asciiart
  ..$style_bad_script_menu &allow bad scripts
  ...$style_bad_script_ban &do not allow bad scripts : set_allow_bad_scripts
  ...-
  ...open bad script list : open_bad_script
  ..$style_allow_rand_nick &allow random nickname : set_allow_rand_nick
  ..$style_allow_clone &allow clone 10x : set_allow_room_clone
  ..-
  ..$style_allow_nick [allow services held nickname] : set_allow_room_nick
  ..$style_allow_share [&allow file sharing] : set_allow_room_file_share 
  ..$style_allow_idle [&allow idle 25+ minutes] : set_allow_room_idle 
  ..$style_allow_binart [&allow bin-art && non-english] : set_allow_room_binart
  ..$style_allow_bad_word [&allow bad words]
  ...$style_allow_bad_word_off do not allow bad words : set_allow_room_badword
  ...-
  ...open bad word list : open_bad_word
  ..$style_allow_room_name [&allow advertising other rooms]
  ...$style_allow_room_name_on do not allow : set_allow_room_name
  ...-
  ...open allowed list : open_allowed_room
  ..$style_allow_url [&allow speaking $+(https,$chr(58),//URLs,]) 
  ...$style_allow_url_off do not allow : set_allow_room_url
  ...-
  ...open always allowed-url list : open_allowed_url
  ..$style_bad_chan [&allow bad room]
  ...$style_bad_chan_off do not allow : set_allow_room_bad_room
  ...-
  ...open bad room list : open_bad_chan
  ..-
  ..$style_allow_non_default set non-defaults to allow : set_allow_room_non_default
  ..$style_allow_default [set defaults to allow] : set_allow_room_default
  .[ir&c oper scan]
  ..-
  ..$iif(($chan != $null),$style_proxy,$style(2)) &scan here : /operscan $chan
  ..$iif(($chan(0) > 0),$style_proxy,$style(2)) &scan all rooms : /operscan
  ..-
  ..$iif($menu_disable_oper_scan != $style(3),$style(1)) &scan on join
  ...$menu_disable_oper_scan switch &OFF scanning : disable_oper_scan
  ...-  
  ...$style_oper_scan_net switch ON for this &network : toggle_oper_scan_net
  ...$style_oper_scan_cid switch ON for this &connection (temporary) : toggle_oper_scan_cid
  ...-
  ...$style_oper_scan_client [switch ON for this @&client_id] : toggle_oper_scan_client
  .-
  .$style_net_chan_link network channel link 
  ..$style_link_on turn on here : {
    if ($varname_global(network-link,$chan).value > 0) { setvar $varname_global(network-link,$chan) 0 | status_msg set channel-link $chan off }
    else { setvar $varname_global(network-link,$chan) $cid | status_msg set channel-link $chan $cid }
  }
  ..-
  ..in&fo : /script_info -chan_link
  .$style_annc_urls_on describe .url
  ..$style_secure_url enforce secure connections : urlcrawl_secure_toggle
  ..$style_annc_urls_off turn off url crawl : urlcrawl_toggle
  .-
  .$style_auto_ial [&auto update IAL] : toggle_auto_ial
  -
  $style_proxy &network services
  .$iif($style_proxy,$ifmatch,$iif($bool($varname_network(auto-identify-room,$active).value) == $true,$style(1),$iif($active !ischan,$style(2)))) [&auto-identify room] : msg *Status auto-identify-room $iif($bool($varname_cid(auto-identify-room,$active).value) == $true,remove,add) $active
  .$iif($bool($varname_network(auto-identify-nick,$me).value) == $true,$style(1),$style_proxy) [&auto-identify nick] : msg *status auto-identify-nick $iif($bool($varname_cid(auto-identify-nick,$me).value) == $true,remove,add) $me
  .-
  .$style_proxy identify room
  ..$submenu($identify_chans_popup($1))
  ..-
  ..$iif(($style(2) isin $chan_identify(1)),$style(2)) all rooms : msg *status identify-rooms 
  ..$style_proxy room? : msg *Status identify $$input(Enter a room name and optonal password:,egqd,identify to room?)
  .forget room
  ..$submenu($identify_chans_popup($1))
  .-
  .nickserv help : nickserv help
  .chanserv help : chanserv help
  .X showcommands : msg x showcommands
  .-
  .$style_proxy identify nick/login : msg *status identify
  .$iif($active !ischan,$style(2),$style_proxy) identify room : msg *status identify $active
  -
  &trio-ircproxy.py
  .&visit your home-page : run https://www.MyProxyIP.com/user/find.html?nick= $+ $me
  .&visit proxy list : run https://www.MyProxyIP.com/proxy.html
  -
  &connect irc
  .last used : /server
  .-
  .with proxy 
  ..192.168.0.17 4321 : /proxy -mp on 192.168.0.17 4321 $$?="enter your proxy username and optional @client_name and the proxy password:" | /server $$server(1, $$?="enter network name:") $+ : $+ $remove($remove($server(1, $!).port,+),*)
  .with vhost
  ..38.242.206.227 7000 : /proxy off | /server 38.242.206.227:7000 $$?="enter your proxy username and optional @client_name:" $+ / $+ $$?="enter network name to connect to:") $+ : $+ $$?="enter your proxy password:"
  ..192.168.0.17 +6697 : /proxy off | /server 192.168.0.17:+6697 $$?="enter your proxy username and optional @client_name:" $+ / $+ $$?="enter network name to connect to:") $+ : $+ $$?="enter your proxy password:"
  .-
  .without proxy or vhost : /proxy off | /server $server(1, $iif(($network),$network,$$?="enter network name:"))
}
alias style_isop {
  return $iif($chan && ($me !isop $chan),$style(1))
}
alias -l onotice-script {
  var %room = #$$input(Enter a room name to send op-notice to:,eygbqk60m,enter a room name to send op-notice to,select a room,$chan(1),$chan(2),$chan(3),$chan(4),$chan(5),$chan(6),$chan(7),$chan(8),$chan(9),$chan(10),$chan(11),$chan(12),$chan(13),$chan(14),$chan(15))
  if (%room == #select a room) { return }
  %room = #$gettok(%room,1,32)
  var %msg = $$input(Speak your notice to all chan-ops in %room $+ :,eygbqk60,Speak your notice to all chan-ops in %room, .: Pync script :: :)
  !onotice %room %msg
}
alias -l omsg-script {
  var %room = #$$input(Enter a room name to send op-msg to:,eygbqk60m,enter a room name to send op-msg to,select a room,$chan(1),$chan(2),$chan(3),$chan(4),$chan(5),$chan(6),$chan(7),$chan(8),$chan(9),$chan(10),$chan(11),$chan(12),$chan(13),$chan(14),$chan(15))
  if (%room == #select a room) { return }
  %room = $gettok(%room,1,32)
  var %msg = $$input(Enter your message to all chan-ops in %room $+ :,eygbqk60,Enter your message to all chan-ops in %room,:: : Pync script : .)
  !omsg %room %msg
}
alias -l open_bad_word {
  var %fn = $qw($scriptdirprevention\bad-word-list.txt)
  if ($exists(%fn) == $false) { write -c %fn }
  run %fn
}
alias -l open_bad_script {
  var %fn = $qw($scriptdirprevention\bad-scripts.txt)
  if ($exists(%fn) == $false) { write -c %fn }
  run %fn
}
alias -l open_bad_chan {
  var %fn = $qw($scriptdirprevention\bad-chan-list.txt)
  if ($exists(%fn) == $false) { write -c %fn }
  run %fn
}
alias -l open_allowed_room {
  var %fn = $qw($scriptdirprevention\allowed-room-names.txt)
  if ($exists(%fn) == $false) { write -c %fn }
  run %fn
}
