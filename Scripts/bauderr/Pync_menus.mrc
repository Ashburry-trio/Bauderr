on *:start: {
  unset %bde_cid_*
  unset %bde_temp_*
  unset %bde_global_*
}
on *:exit: {
  unset %bde_cid_*
  unset %bde_temp_*
  unset %bde_global_*
}
on *:quit: {
  if ($nick != $me) { return }
  unset %bde_cid_*
}
on *:connect: {
  pass
}
alias ascii-art-select {
  var %fn = $scriptdirart\ascii-art\
  if ($left($active,1) != $chr(35)) && (!$nick) {
    var %sendto = Type a nick or chan
    while (%sendto == Type a nick or chan) {
      %sendto = $$input(Which nickname or room would you like to play the ascii-art file to:,eyfgqbdxm,What nickname or room do you want to play to:,Type a nick or chan,$chat(1),$chat(2),$chat(3),$chat(4),$chat(5),$query(1),$query(2),$query(3),$query(4),$query(5),$query(6),$query(7),$query(8),$query(9),$query(10),$chan(1),$chan(2),$chan(3),$chan(4),$chan(5),$chan(6),$chan(7),$chan(8),$chan(9),$chan(10))
    }
    if (%sendto == $false) { return }
  }
  else {
    if ($nick) { %sendto = $nick }
    if ($chan) { %sendto = $chan }
  }
  %fn = $sfile(%fn $+ *.txt,Select a ascii-art file:, Play))
  /play -m5 %sendto $qt(%fn) 620
}
alias menu_parted {
  if ($1 isin endbegin) { return }
  if (!$chan($1)) { return - }
  if ($chan($1).status) { return $chan($1) $block($chan($1).status) : part $chan($1) }
}
alias style_part_all_rooms {
  var %i = 1
  var %chan = $chan(%i)
  while (%chan) {
    if (join isin $chan(%i).status) { return }
    inc %i
    %chan = $chan(%i)
  }
  return $style(3)
}
alias close_parted {
  var %i = 1
  var %last
  while ($chan(%i)) {
    if (join* !iswm $chan(%i).status) { 
      %last = $chan(%i)
      part $chan(%i)
    }
    if ($chan(%i) == %last) { inc %i }
    continue 
  }
}
alias oldnick {
  if ($varname_global(old_nick,$$1).value != $null) { return $ifmatch }
}
alias old_nick_islisted {
  var %i = 0
  :loop
  if (%i == 10) { return $false }
  inc %i
  if ($varname_global(old_nick,%i).value == $$1) { return $true }
  goto loop
}
alias old_nick_add {
  if ($old_nick_islisted($1) == $true) { return }
  var %i = 0
  :loop
  if (%i == 10) { set $varname_global(old_nick,$rands(1,10)) $1 | return }
  inc %i
  if ($varname_global(old_nick,%i).value == $null) { set $varname_global(old_nick,%i) $1 | return }
  goto loop
}
on *:nick: {
  if ($nick == $me) { old_nick_add $me | old_nick_add $newnick }
}
alias style_parted_rooms {
  var %i = 1
  var %parted = $false
  while ($chan(%i)) {
    if ($chan(%i).status != parted) { inc %i | continue }
    var %parted = $true
    break
  }
  if (!%parted) { return $style(3) }
}
raw 18:*: {
  if (www.myproxyip.com isin $1-) { set $varname_cid(trio-ircproxy.py,active) $true }
}
alias join_parms {
  ; Identifier which Joins all given parameters and removes
  ; their spaces, this is useful if you need to pass unique lines of text
  if (!$isid) { return }
  tokenize 32 $$1-
  var %parsed, %i = 1
  while ($ [ $+ [ %i ] ]) {
    set %parsed %parsed $+ $ifmatch
    inc %i    
  }
  unset %i
  return %parsed
}
alias -l onotice-script {
  var %room = #$$input(Enter a room name to send op-notice to:,eygbqk60m,enter a room name to send op-notice to,select a room,$chan(1),$chan(2),$chan(3),$chan(4),$chan(5),$chan(6),$chan(7),$chan(8),$chan(9),$chan(10),$chan(11),$chan(12),$chan(13),$chan(14),$chan(15))
  if (%room == #select a room) { return }
  %room = $gettok(%room,1,32)
  var %msg = $$input(Speak your notice to all chan-ops in %room $+ :,eygbqk60,Speak your notice to all chan-ops in %room, .: Pync script :: :)
  !onotice %room %msg
  unset %room, %msg
}
alias -l omsg-script {
  var %room = #$$input(Enter a room name to send op-msg to:,eygbqk60m,enter a room name to send op-msg to,select a room,$chan(1),$chan(2),$chan(3),$chan(4),$chan(5),$chan(6),$chan(7),$chan(8),$chan(9),$chan(10),$chan(11),$chan(12),$chan(13),$chan(14),$chan(15))
  if (%room == #select a room) { return }
  %room = $gettok(%room,1,32)
  var %msg = $$input(Enter your message to all chan-ops in %room $+ :,eygbqk60,Enter your message to all chan-ops in %room,:: : Pync script : .)
  !omsg %room %msg
  unset %room, %msg
}

alias parted_rooms {
  if ($1 isin begin end) { return }
  if ($1 > $chan(0)) { return }
  if ($chan($1).status == kicked) { return $chan($1) $block(kicked) : join $chan($1) }
  elseif ($chan($1).status == parted) { return $chan($1) $block(parted) : join $chan($1) }
  else { return - }
}

alias joinall {
  var %i = 1, %chan_c = 0
  while ($chan(%i)) {
    if (join* iswm $chan(%i).status) { inc %i | continue }
    else { inc %chan_c | inc %i }
  }
  if (%chan_c < 1) { echo $color(info) -ae * No channels to rejoin. | return }
  echo $color(info) -ae * ReJoining %chan_c channels...
  var %i = 1 | unset %chan_c
  while ($chan(%i)) {
    if (join* !iswm $chan(%i).status) { join $chan(%i) }
    inc %i
  }
}
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
  if ($1- iswm $star auto-join ?*) && ($4 == $null) {
    set $varname_cid(auto_join,on) $bool($3)
  }
  if ($1- == $star auto-join #?* ?*) {
    set $varname_cid(auto_join,$3) $bool($$4)
  }
  if ($1- iswm $star auto-identify-room #?*) {
    set $varname_cid(auto-identify-room,$$3) $bool($$4)
  }
  if ($1 iswm $star anti-idle ?*) {
    set $varname_cid(anti-idle,enabled) $bool($3)
  }
  if ($1 iswm $star show-away ?*) {
    set $varname_cid(show_away,enabled) $bool($3)
  }
}
alias star return *
alias toggle_auto_join {
  if ($varname_cid(auto_join,on).value == $true) { unset $varname_cid(auto_join,on) }
  else { set $varname_cid(auto_join,on) $true }
}
alias set_show_away {
  if ($1 <= 2) && ($1 >= 0)  { set $varname_global(show_away,blank) $1 }
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
  if (%room == $null) && ($1 < 2) { return $style(2) No such rooms }
  return %room
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
  &client commands
  .[auto-join invite]
  ..off : ajinvite off
  ..[on] : ajinvite on
  .-
  .a/q/op-message
  ..amsg : amsg $$input(Speak your message to all channels:,eygbqk60,type your message to all channels,I hear'd everyone is welcome to room 5ioE on Undernet.)
  ..ame : ame $$input(Describe your action to all channels:,eygbqk60,describe your action to all channel,wonders who is in room 5ioE on Undernet)
  ..-
  ..qmsg : qmsg $$input(Speak your message to all query windows:,eygbqk60,speak your message to all query windows,anyone know what /amsg does?)
  ..qme : qme $$input(Describe your action to all query windows:,eygbqk60,describe your action to all query windows,wonders what /qme will do...)
  ..-
  ..op notice : onotice-script
  ..op message : omsg-script
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
  .[clear all]
  ..status : clearall -s
  ..channels : clearall -c
  ..querys : clearall -q
  ..chat : clearall -t
  ..messages : clearall -m
  ..-
  ..[windows] : clearall -tmqcs
  .[close dcc]
  ..gets : close -g
  ..sends : close -s
  ..fserve : close -f
  ..chats : close -c
  ..-
  ..[inactive] : close -i
  .-
  .chat request $block($iif($creq == auto,auto-accept %creq,$creq))
  ..$iif(($creq %creq == auto +m),$style(1)) auto-accept minimize : creq +m auto
  ..$iif(($creq == auto && %creq != +m),$style(1)) [auto-accept active] : creq -m auto
  ..-
  ..$iif($creq == ask,$style(1)) ask : creq ask
  ..$iif($creq == ignore,$style(1)) ignore : creq ignore
  .send request $block($iif($sreq == auto,auto-accept %sreq,$sreq))
  ..$iif(($sreq %sreq == auto +m),$style(1)) [auto-accept minimize] : sreq +m auto
  ..$iif(($sreq == auto && %sreq != +m),$style(1)) auto-accept active : sreq -m auto
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
  ...$oldnick(1)
  ....main nickname : mnick $oldnick(1)
  ....alternate nickname : anick $oldnick(1)
  ....temporary nickname : tnick $oldnick(1)
  ...$oldnick(2)
  ....main nickname : mnick $oldnick(2)
  ....alternate nickname : anick $oldnick(2)
  ....temporary nickname : tnick $oldnick(2)
  ...$oldnick(3)
  ....main nickname : mnick $oldnick(3)
  ....alternate nickname : anick $oldnick(3)
  ....temporary nickname : tnick $oldnick(3)
  ...$oldnick(4)
  ....main nickname : mnick $oldnick(4)
  ....alternate nickname : anick $oldnick(4)
  ....temporary nickname : tnick $oldnick(4)
  ...$oldnick(5)
  ....main nickname : mnick $oldnick(5)
  ....alternate nickname : anick $oldnick(5)
  ....temporary nickname : tnick $oldnick(5)
  ...$oldnick(6)
  ....main nickname : mnick $oldnick(6)
  ....alternate nickname : anick $oldnick(6)
  ....temporary nickname : tnick $oldnick(6)
  ...$oldnick(7)
  ....main nickname : mnick $oldnick(7)
  ....alternate nickname : anick $oldnick(7)
  ....temporary nickname : tnick $oldnick(7)
  ...$oldnick(8)
  ....main nickname : mnick $oldnick(8)
  ....alternate nickname : anick $oldnick(8)
  ....temporary nickname : tnick $oldnick(8)
  ...$oldnick(9)
  ....main nickname : mnick $oldnick(9)
  ....alternate nickname : anick $oldnick(9)
  ....temporary nickname : tnick $oldnick(9)
  ...$oldnick(10)
  ....main nickname : mnick $oldnick(10)
  ....alternate nickname : anick $oldnick(10)
  ....temporary nickname : tnick $oldnick(10)
  ..-
  ..main nick ? : mnick $$?="enter your main nickname:"
  ..alternate nick ? : anick $$?="enter your alternate nickname:"
  ..temporary nick ? : tnick $$?="enter your temporary nickname:"
  .[spoof email && name]
  ..[emailaddr] : /emailaddr bauderr-script
  ..[fullname] : /fullname .: bauderr-script :: : @ https://www.MyProxyIP.com/
  ..-
  ..[set both] : /emailaddr bauderr-script | /fullname .: bauderr-script :: : @ https://www.MyProxyIP.com/
  .-
  .exit : exit
  .-
  .reset idle $block($duration($idle)) : /resetidle $?="enter number of seconds:"
  &server commands
  .part room
  ..$submenu($menu_parted($1))
  ..-
  ..$style_parted_rooms close parted rooms : close_parted
  ..$style_part_all_rooms part all rooms : !partall .: PyNet Converge script named Bauderr :: :
  .[join room] 
  ..$submenu($parted_rooms($1))
  ..-
  ..$style_joinall rejoin all rooms : joinall
  ..[new room] : join $$input(Type a room name to join:,eoygbqk60,type a room name to join,#5ioE)
  .-
  .$iif(($status != connected),$style(2)) [motd] 
  ..$chr($asc([)) $+ $server $+ $chr($asc(])) : motd
  ..www.myProxyIP.com : msl_motd
  ..-
  ..on connect
  ...show www.myproxyip.com : msl show-motd www.MyProxyIP.com.com
  ...show irc server : msl show-motd
  .-
  .whois query
  ..$submenu($query_menu($1))
  .[ial-fill]
  ..$submenu($ialupdate_menu($1))
  ..-
  ..room : if ($ial) { ialfill -f $$input(Type a room:,eoygbqk60,type a room,#5ioE) }
  ..$iif((!$ial),$style(1)) turn OFF ial : ial $$iif((!$ial),on,off)
  .-
  .lusers : lusers
  .links : links
  .[list room] : list
  .-
  .quit : quit * Trio-ircproxy.py & MG script named Bauderr *
  -
  script &functions
  .$iif($bool($varname_cid(anti-idle,enabled).value) == $true,$style(1)) set ant&i-idle : {
    msg *Status anti-idle $iif($bool($varname_cid(anti-idle,$active).value) == $true,off,on)
  }
  .-
  .[set &auto-away]
  .$style_show_away [&show away nicks]
  ..$style_show_away_note notice : set_show_away 1
  ..$style_show_away_priv [private message] : set_show_away 2
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
  .$iif(($active == Status Window),$style(2)) topi&c history
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
  ..$iif(($chan(#).topic == $null),$style(3)) &unset topic : /raw topic $chan :
  ..-
  ..$iif(($eval($var($varname_global(topic_history_ $+ $chan,*),1),1) == $null || (!$chan)),$style(3)) erase topic history for room : unset $varname_global(topic_history_ $+ $chan,*) | eecho -sep topic history cleared for room $chan
  ..$iif(($var($varname_global(topic_history_*,*),0) == 0),$style(3)) erase entire topic history : unset $varname_global(topic_history_*,*) | eecho -sep topic history for ALL channels is cleared
  ..-
  ..$style_topic_history_on switch ON topic history : topic_history_switch_on
  .-
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
  ..$style_allow_share [&allow file sharing] : set_allow_room_file_share 
  ..$style_allow_idle [&allow idle 25+ minutes] : set_allow_room_idle 
  ..$style_allow_binart [&allow bin-art && non-english] : set_allow_room_binart
  ..$style_allow_bad_word [&allow bad words]
  ...$style_allow_bad_word_off do not allow bad words : set_allow_room_badword
  ...-
  ...open bad word list : open_bad_word
  ..$style_allow_room_name [&allow advertising other #room-names]
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
  ..$iif(($chan != $null),$style_proxy,$style(2)) scan here : /operscan $chan
  ..$iif(($chan(0) > 0),$style_proxy,$style(2)) scan all rooms : /operscan
  ..-
  ..$iif($menu_disable_oper_scan != $style(3),$style(1)) s&can on join
  ...$menu_disable_oper_scan switch OFF scanning : disable_oper_scan
  ...-  
  ...$oper_scan_net switch ON for this network : toggle_oper_scan_net
  ...$oper_scan_cid switch ON for this connection (temporary) : toggle_oper_scan_cid
  ...-
  ...$oper_scan_client [switch ON for this @client_id] : toggle_oper_scan_client
  .-
  .$style_net_chan_link network channel link 
  ..$style_link_on turn on here : {
    if ($varname_global(network-link,$chan).value > 0) { set $varname_global(network-link,$chan) 0 | status_msg set channel-link $chan off }
    else { set $varname_global(network-link,$chan) $cid | status_msg set channel-link $chan $cid }
  }
  ..-
  ..in&fo : /script_info -chan_link
  .$style_annc_urls describe .url

  .-
  .$style_auto_ial [&auto update IAL] : toggle_auto_ial
  -
  $style_proxy network services
  .$iif($bool($varname_network(auto-identify-room,$active).value) == $true,$style(1),$iif($active !ischan,$style(2))) [&auto-identify room] : msg *Status auto-identify-room $iif($bool($varname_cid(auto-identify-room,$active).value) == $true,remove,add) $active
  .$iif($bool($varname_network(auto-identify-nick,$me).value) == $true,$style(1),$style_proxy) [&auto-identify nick] : msg *status auto-identify-nick $iif($bool($varname_cid(auto-identify-nick,$me).value) == $true,remove,add) $me
  .-
  .$style_proxy identify room
  ..$submenu($identify_chans_popup($1))
  ..-
  ..$iif(($style(2) isin $chan_identify(1)),$style(2)) all rooms : msg *status identify-rooms 
  ..room? : msg *Status identify $$input(Enter a room name and password:,egqd,identify to room?)
  .forget room
  ..$submenu($identify_chans_popup($1))
  .-
  .nickserv help : nickserv help
  .chanserv help : chanserv help
  .X showcommands : msg x showcommands
  .-
  .identify nick/login : msg *status identify
  .$iif($active !ischan,$style(2)) identify $active : msg *status identify $active
  -
  &trio-ircproxy.py
  .&visit your home-page : proxy_msg visit homepage
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
alias style_link_on {
  if (!$chan) { return $style(2) }
  if ($varname_global(network-link,$chan).value == 1) { return $style(1) }

}
alias BAUDERR-ADVERTISE {
  if ($1 == --chan) {
    describe $$2 is using PyNet Converge mSL script named Bauderr. use ctcp version / script / source for more info.
  }
}
alias style_auto_ial {
  if ($varname_global(auto_ia1,blank).value == $true) || ($varname_global(auto_ia1,blank).value == $null) { return $style(1) }
}
alias toggle_auto_ial {
  set $varname_global(auto_ia1,blank) $iif($1 != $null,$1,$iif(($varname_global(auto_ia1,blank).value == $true || $varname_global(auto_ia1,blank).value == $null),$false,$true))
}
alias style_annc_urls {
  return $iif(($varname_cid(annc_urls,blank).value),$style(1))
}
alias annc_urls_toggle {
  set $varname_cid(annc_urls,blank) $iif(($varname_cid(annc_urls,blank).value),$false,$true)
}
alias query_menu {
  if ($1 isin beginend) { return }
  if ($query($1)) { return $query($1) : whois $query($1) }
}
alias ialupdate_menu {
  if ($1 isin beginend) { return }
  if (!$chan($1)) { return }
  if ($chan($1).status != joined) { return $style(2) $chan($1) - $chan($1).status : return }
  if ($chan($1)) { return $chan($1) $ialupdated($chan($1)) : if ($ial) { //ec -f $chan($1) } }
}
alias play-sound-history {
  if ($1 isin beginend) { return }
  if ($1 == 16) { return }
  var %fn = $var($varname_global(sound-history,*),$1)
  var %fn = [ [ %fn ] ]  
  if (!%fn) { return }
  if (!$exists(%fn)) { unset $var(%fn,1) | continue }
  return $nopath(%fn) : play-sound $eval($iif($active == $chan || $active == $nick,$ifmatch,$gettok($$?="enter a room or nickname to play to:",1,32)) %fn, 0)
}
alias style_annc_urls_secure {
  if ($varname_global(urlcrawl,secure) == $null) || ($varname_global(urlcrawl,secure) == $true) { return $style(1) }
}
alias play-sound {
  var %file = $qw($2-), %fn
  if (!$exists(%file)) { return }
  var %n = 1, %empty
  while (%n < 16) {
    %fn = $varname_global(sound-history,%n).value
    if (%fn) && ($exists(%fn) == $false) { var %fn | unset $varname_global(sound-history,%n) }
    elseif (%fn == %file) { %empty = skip | break }
    if (!%fn) && (!%empty) { %empty = %n }
    inc %n
  }
  if (%empty == $null) {
    if ($varname_global(sound-history,last-n).value == $null) { set $varname_global(sound-history,last-n) 1 }
    set $varname_global(sound-history,last-n) $calc($varname_global(sound-history,last-n).value + 1)
    if ($varname_global(sound-history,last-n).value > 15) { set $varname_global(sound-history,last-n) 1 }
    set $varname_global(sound-history,$varname_global(sound-history,last-n).value) %file
  }
  else { if (%empty != skip) { set $varname_global(sound-history,%empty) %file } }
  var %m = is playing a sound * 76,1 E n j o y!   *
  if (C isin $chan($1).mode) { %m = $strip(%m) }
  .timer -om 1 1 /playsound $replacex($1- %m,$chr(124),$chr(1))
  echo -a (for other ppl to listen to the sound file they MUST paste) ! $+ $me $nopath(%file)  (in channel or private message. you can use /splay stop to end the sound.)
}
alias playsound {
  play $replacex($1-,$chr(1),$chr(124))
}
alias open_allowed_url {
  var %fn = $qw($scriptdirprevention\allowed-url-list.txt)
  if ($exists(%fn) == $false) { write -c %fn }
  run %fn

}
alias -l open_bad_word {
  var %fn = $qw($scriptdirprevention\bad-word-list.txt)
  if ($exists(%fn) == $false) { write -c %fn }
  run %fn
}
alias open_bad_script {
  var %fn = $qw($scriptdirprevention\bad-scripts.txt)
  if ($exists(%fn) == $false) { write -c %fn }
  run %fn
}
alias open_bad_chan {
  var %fn = $qw($scriptdirprevention\bad-chan-list.txt)
  if ($exists(%fn) == $false) { write -c %fn }
  run %fn
}
alias open_allowed_room {
  var %fn = $qw($scriptdirprevention\allowed-room-names.txt)
  if ($exists(%fn) == $false) { write -c %fn }
  run %fn
}
alias style_bad_chan_off {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_bad_chan,$network $+ $chan).value) { return $style(1) }
}
alias style_bad_chan {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_bad_chan,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_default {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_room_default,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_repeat {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_room_repeat,$network $+ $chan).value) { return $style(1) }
}
alias style_bad_script_menu {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_bad_scripts,$network  $+ $chan).value) { return $style(1) }
}
alias style_bad_script_ban {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_bad_scripts,$network  $+ $chan).value == $true) { return $style(1) }
}
alias style_bad_chan {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_bad_chan,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_url {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_room_url,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_url_off {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_room_url,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_room_name {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_room_name,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_room_name_on {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_room_name,$network $+ $chan).value) { return $style(1) }
}

alias style_allow_binart {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_room_binart,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_bad_word {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_bad_word,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_bad_word_off {
  if (!$network) || (!$chan) { return }
  if (!$varname_global(allow_bad_word,$network $+ $chan).value) { return $style(1) }

}
alias style_allow_idle {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_room_idle,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_share {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_room_sharing,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_clone {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_room_clone,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_rand_nick {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_rand_nick,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_long_word {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_long_word,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_line {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_long_line,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_paste {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_room_paste,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_non_default {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_room_non_default,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_rand_text {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_rand_text,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_ascii {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_rand_text,$network $+ $chan).value) && $&
    (!$varname_global(allow_room_paste,$network $+ $chan).value) && $&
    (!$varname_global(allow_long_line,$network $+ $chan).value) && $&
    (!$varname_global(allow_long_word,$network $+ $chan).value) && $&
    (!$varname_global(allow_room_repeat,$network $+ $chan).value) { return $style(1) }
}

alias set_allow_bad_scripts {
  if (!$varname_global(allow_bad_scripts,$network  $+ $chan).value) { set $varname_global(allow_bad_scripts,$network  $+ $chan) $true }
  else { unset $varname_global(allow_bad_scripts,$network  $+ $chan) }
}

alias set_allow_room_binart {
  if (!$varname_global(allow_room_binart,$network $+ $chan).value) { set $varname_global(allow_room_binart,$network $+ $chan) $true }
  if ($varname_global(allow_room_binart,$network $+ $chan).value == $true) { unset $varname_global(allow_room_default,$network $+ $chan) }
  else { set $varname_global(allow_room_binart,$network $+ $chan) $true }

}
alias set_allow_rand_nick {
  if ($varname_global(allow_rand_nick,$network $+ $chan).value == $false) { set $varname_global(allow_room_non_default,$network $+ $chan) $false }
  if ($varname_global(allow_rand_nick,$network $+ $chan).value == $null) { set $varname_global(allow_rand_nick,$network $+ $chan) $false }
  else { unset $varname_global(allow_rand_nick,$network $+ $chan) }


}

alias set_allow_room_clone {
  if ($varname_global(allow_room_clone,$network $+ $chan).value == $false) { set $varname_global(allow_room_non_default,$network $+ $chan) $false }
  if ($varname_global(allow_room_clone,$network $+ $chan).value == $null) { set $varname_global(allow_room_clone,$network $+ $chan) $false }
  else { unset $varname_global(allow_room_clone,$network $+ $chan) }
}


alias set_allow_room_badword {
  if ($varname_global(allow_bad_word,$network $+ $chan).value == $false) { unset $varname_global(allow_room_default,$network $+ $chan) }
  if ($varname_global(allow_bad_word,$network $+ $chan).value == $null) { set $varname_global(allow_bad_word,$network $+ $chan) $false }
  else { unset $varname_global(allow_bad_word,$network $+ $chan) }
}
alias set_allow_room_non_default {
  if ($varname_global(allow_room_non_default,$$network $+ $chan).value == $null) {
    set $varname_global(allow_room_non_default,$$network $+ $chan) $false
    set_allow_asciiart_non_default
    set $varname_global(allow_bad_scripts,$network $+ $chan) $false
    set $varname_global(allow_bad_scripts_menu,$network  $+ $chan) $false
    set $varname_global(allow_rand_nick,$network $+ $chan) $false
    set $varname_global(allow_room_clone,$network $+ $chan) $false
    set_allow_asciiart
  }
  else { 
    unset $varname_global(allow_room_non_default,$network $+ $chan)
    unset $varname_global(allow_bad_scripts,$network $+ $chan)
    unset $varname_global(allow_rand_nick,$network $+ $chan)
    unset $varname_global(allow_room_clone,$network $+ $chan)
    set_allow_asciiart
  }
}
alias set_allow_room_default {
  if (!$varname_global(allow_room_default,$network $+ $chan).value) {
    set $varname_global(allow_room_default,$network $+ $chan) $true
  }
  else { unset $varname_global(allow_room_default,$network $+ $chan) }
  set $varname_global(allow_room_sharing,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  set $varname_global(allow_room_idle,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  set $varname_global(allow_bad_word,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  set $varname_global(allow_room_binart,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  set $varname_global(allow_room_name,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  set $varname_global(allow_room_url,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  set $varname_global(allow_bad_chan,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  unset $varname_global(allow_rand_text,$network $+ $chan)
}
alias set_allow_room_bad_room {
  if (!$varname_global(allow_bad_chan,$network $+ $chan).value) { set $varname_global(allow_bad_chan,$network $+ $chan) $false }
  else { set $varname_global(allow_bad_chan,$network $+ $chan) $true }
  if ($varname_global(allow_bad_chan,$network $+ $chan).value) { set $varname_global(allow_room_default,$network $+ $chan) $true }
}
alias set_allow_room_repeat {
  if (!$varname_global(allow_room_repeat,$network $+ $chan).value) { set $varname_global(allow_room_repeat,$network $+ $chan) $true }
  else { unset $varname_global(allow_room_repeat,$network $+ $chan) }
  if ($varname_global(allow_room_repeat,$network $+ $chan).value) { set $varname_global(allow_room_non_default,$network $+ $chan) $True }

}
alias set_allow_room_paste {
  if ($varname_global(allow_room_paste,$network $+ $chan).value == $null) { set $varname_global(allow_room_paste,$network $+ $chan) $false }
  else { unset $varname_global(allow_room_paste,$network $+ $chan) }
  if ($varname_global(allow_room_paste,$network $+ $chan).value) { set $varname_global(allow_room_non_default,$network $+ $chan) $true }
}
alias set_allow_room_long_word {
  if ($varname_global(allow_long_word,$network $+ $chan).value == $null) { set $varname_global(allow_long_word,$network $+ $chan) $false }
  else { unset $varname_global(allow_long_word,$network $+ $chan) }
  if ($varname_global(allow_long_word,$network $+ $chan).value) { set $varname_global(allow_room_non_default,$network $+ $chan) $true }

}
alias set_allow_room_long_line {
  if ($varname_global(allow_long_line,$network $+ $chan).value == $null) { set $varname_global(allow_long_line,$network $+ $chan) $false }
  else { unset $varname_global(allow_long_line,$network $+ $chan) }
  if ($varname_global(allow_long_line,$network $+ $chan).value == $false) { set $varname_global(allow_room_non_default,$network $+ $chan) $true }
}
alias set_allow_room_random_text {
  if ($varname_global(allow_rand_text,$network $+ $chan).value == $null) { set $varname_global(allow_rand_text,$network $+ $chan) $false }
  else { unset $varname_global(allow_rand_text,$network $+ $chan) }
  if ($varname_global(allow_rand_text,$network $+ $chan).value == $false) { set $varname_global(allow_room_default,$network $+ $chan) $true }
}
alias set_allow_asciiart {
  unset $varname_global(allow_rand_text,$network $+ $chan)
  set $varname_global(allow_asciiart,$network $+ $chan) $iif((!$varname_global(allow_asciiart,$network $+ $chan).value), $true, $null)
  set $varname_global(allow_room_paste,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  set $varname_global(allow_long_line,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  set $varname_global(allow_long_word,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  set $varname_global(allow_room_repeat,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  if (!$varname_global(allow_asciiart,$network $+ $chan).value) { unset $varname_global(allow_room_non_default,$network $+ $chan) }
  else { set $varname_global(allow_room_non_default,$network $+ $chan) $true }

}

alias set_allow_asciiart_non_default {
  set $varname_global(allow_asciiart,$network $+ $chan) $iif(($varname_global(allow_asciiart,$network $+ $chan).value),$null,$true)
  unset $varname_global(allow_rand_text,$network $+ $chan)
  set $varname_global(allow_room_paste,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  set $varname_global(allow_long_line,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  set $varname_global(allow_long_word,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  set $varname_global(allow_room_repeat,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  set $varname_global(allow_room_non_default,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
}
alias SET_ALLOW_ROOM_FILE_SHARE {
  if (!$varname_global(allow_room_sharing,$network $+ $chan).value) { set $varname_global(allow_room_sharing,$network $+ $chan) $true }
  else { unset $varname_global(allow_room_sharing,$network $+ $chan) }
  if ($varname_global(allow_room_sharing,$network $+ $chan).value) { set $varname_global(allow_room_default,$network $+ $chan) $true }

}
alias set_allow_room_idle {
  if ($varname_global(allow_room_idle,$network $+ $chan).value == $null) { set $varname_global(allow_room_idle,$network $+ $chan) $true }
  else { unset $varname_global(allow_room_idle,$network $+ $chan) }
  if ($varname_global(allow_room_idle,$network $+ $chan).value) { set $varname_global(allow_room_default,$network $+ $chan) $true }


}
alias set_allow_room_url {
  if (!$varname_global(allow_room_url,$network $+ $chan).value) { set $varname_global(allow_room_url,$network $+ $chan) $true }
  else { unset $varname_global(allow_room_url,$network $+ $chan) }
  if ($varname_global(allow_room_url,$network $+ $chan).value) { set $varname_global(allow_room_default,$network $+ $chan) $true }
}
alias set_allow_room_name {
  if (!$varname_global(allow_room_name,$network $+ $chan).value) { set $varname_global(allow_room_name,$network $+ $chan) $true }
  else { unset $varname_global(allow_room_name,$network $+ $chan) }
  if ($varname_global(allow_room_name,$network $+ $chan).value) { set $varname_global(allow_room_default,$network $+ $chan) $true }
}
alias menu_disable_oper_scan {
  if (!$bool($varname_cid(oper-scan-cid,$network).value)) && (!$bool($varname_global(oper-scan-net,$$network).value)) && (!$bool($varname_global(oper-scan-client).value)) { return $style(3) }

}
alias oper_scan_client {
  if ($varname_global(oper-scan-client,blank).value == $true) { return $style(3) }
}
alias toggle_oper_scan_client {
  set $varname_global(oper-scan-client,blank) $iif($bool($varname_global(oper-scan-client,blank).value) == $true,$false,$true)
  if ($bool($varname_global(oper-scan-net,$$network).value) == $true) && ($bool($varname_cid(oper-scan-client).value) == $true) {
    toggle_oper_scan_net
  }
  if ($bool($varname_global(oper-scan-client).value) == $true) && ($varname_cid(oper-scan-cid).value == $true) {
    toggle_oper_scan_cid
  }
}
alias disable_oper_scan {
  set $varname_cid(oper-scan-cid) $false
  if ($network) { set $varname_global(oper-scan-net,$$network) $false }
  set $varname_global(oper-scan-client,blank) $false
}
alias oper_scan_cid {
  if ($bool($varname_cid(oper-scan-cid,$$network).value)) { return $style(3) }
}
alias toggle_oper_scan_cid {
  set $varname_cid(oper-scan-cid,$$network) $iif($bool($varname_cid(oper-scan-cid,$$network).value),$false,$true)
  if ($bool($varname_global(oper-scan-net,$$network).value) == $true) && ($bool($varname_cid(oper-scan-cid,$$network).value) == $true) {
    toggle_oper_scan_net
  }
  if ($bool($varname_cid(oper-scan-cid,$$network).value) == $true) && ($bool($varname_global(oper-scan-client).value) == $true) {
    toggle_oper_scan_client
  }
}

alias oper_scan_net {
  if ($network == $null) { return $style(2) }
  if ($bool($varname_global(oper-scan-net,$$network).value)) { return $style(3) }
}
alias toggle_oper_scan_net {
  if ($network == $null) { return }
  /set $varname_global(oper-scan-net,$$network) $iif($bool($varname_global(oper-scan-net,$$network).value),$false,$true)$true
  if ($bool($varname_global(oper-scan-net,$$network).value) == $true) && ($bool($varname_cid(oper-scan-cid,$$network).value) == $true) {
    toggle_oper_scan_cid
  }
  if ($bool($varname_global(oper-scan-net,$$network).value) == $true) && ($varname_global(oper-scan-client,blank).value == $true) {
    toggle_oper_scan_client
  }
}
alias style-proxy-shutdown {
  if ($varname_cid(using-bnc) != $true) { return $style(2) }

}
alias /proxy-shutdown {
  if ($varname_cid(trio-ircproxy.py,active) == $true) {
    /raw proxy-shutdown NOW
  }
}
;-
; chanserv exists:
;-
alias identify_here_popup {
  if ($bool_using_proxy != $true) || (!$chan) { return $style(2) i&dentify here }
  if ($varname_cid(can-identify-chanserv,$+($$chan,-,$$network)).value != $null) { return i&dentify here }
}
;-
alias identify_chans_popup {
  if ($1 == begin) || ($1 == end) { return }
  var %chan = $chan_identify($1)
  if (%chan == $null) && ($1 == 1) { return no channels : eecho -sep You have no channels with logged passwords }
  return %chan : msg *status identify %chan
}
on *:quit: {
  if ($nick == $me) { unset $varname_cid(trio_ircproxy.py,active) }
}

alias bool_using_proxy {
  if ($bool($varname_cid(trio-ircproxy.py,active).value) = $true) { return $true }
  return $false
}
alias style_proxy {
  if (!$bool_using_proxy) { return $style(2) }
}
on *:text:*:$chr(42) $+ status: {
  tokenize 32 $strip($1-)
  if ($1- == Trio-ircproxy.py active for this connection) { set $varname_cid(trio-ircproxy.py, active) $true }
  if ($4 != $null) && (*your username is ???* iswm $1-4) { set $varname_cid(trio-ircproxy.py, is_user) $4 }
  if (say-away == $1) && ($2 isin $true$false) { set $varname_glob(say-away,none) $2 }
  if (operscan-join == $1) && ($2 isin $true$false) { set $varname_cid(operscan-join,none) $2 }
  ; sets below when able to log in, password is on proxy server
  if ($1 == can-identify-chanserv) && (#* iswm $$2) { set $varname_cid(can-identify-chanserv,$+($2,-,$network)) $2 }
  ; sets $varname_cid(isid-identify-chanserv,$+($chan,-,$$network)) $true when logged in
  if ($1 == can-identify-nick) && ($$2) { set $varname_cid(can-identify-nick,$+($2,$$network)) $2 }

}
alias true$false {
  return $true $+ $false
}
alias is_status_nick {
  ;check is active nick is either one of the two status nicks available.
  ;;
  if ($1) { var %nick = $1 }
  elseif ($nick != $null) { var %nick = $nick }
  if ($chr($asc(*)) $+ STATUS != %nick) { return $false }
  return $true
}

on *:input:$chan: {
  if (*?> $chr(35) $+ ?* !iswm $1-) { return }
  tokenize 32 $strip($1-)
  if ($0 < 2) { return }
  var %num = $remove($2,$chr(35))
  if (!$isnum(%num)) { return }
  var %name = $remove($1,<,>,+,@,%,&,!)
  if (!%name) { return }
  msg %name xdcc send $chr(35) $+ %num
}
menu @script_info {
  close window : window -c $active
  -
  flood : /script_info -flood
  channel history : script_info -history
  identity : script_info -identity
}
alias bnc_msg {
  if ($bool_using_proxy != $true) { return }
  if ($silence) { .msg *status $1- }
  else { msg *status $1- }
}
alias status_msg {
  bnc_msg $1-
}
alias create_shortcuts_style {
  ; Use this to check for existence of shortcuts
  if ($varname_cid(trio-ircproxy.py,active).value) { return $style(2) }
}
alias create_shortcuts_mirc {
  run -a python $qt($scriptdir..\create_shortcut.py) $qt($mircexe) b -i $qt($mircini)
  echo $color(status) -s *** Created shortcut in folder $qt($nofile($mircini))
}
alias create_shortcuts_desktop {
  run -a $qt(python $scriptdir..\create_shortcut.py) $qt($mircexe) d -i $qt($mircini)
  echo $color(status) -s *** Creating shortcut on the Desktop
}
alias create_shortcuts_both {
  run -a python $qt($scriptdir..\create_shortcut.py) $qt($mircexe) bd -i $qt($mircini)
  echo $color(status) -s *** Creating shortcut on Desktop and in folder $qt($nofile($mircini))
}
