on *:start: {
  unset %bde_cid_*
  unset %bde_temp_*
}
on *:exit: {
  unset %bde_cid_*
  unset %bde_temp_*
}
on *:quit: {
  if ($nick != $me) { return }
  unset $varname_cid(*,*)
}
on *:connect: {
  pass
}
on *:text:*status:?: {
  if ($1 == trio-ircproxy) { 
    set -e $varname_cid(trio-ircproxy.py,active) $bool($2) 
    if ($2 == $true) { msg *status Platform: Pync: Bauderr %pync_vesion Client: %pync_app $version }
  }

  if ($bool($varname_network(sticky-part).value) && ($varname_network(sticky_chans).value) { return }
  if ($1-2 == sticky-part $network) { set $varname_network(sticky-part) $true | set varname_network(sticky_chans) $3- }
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
  if ($bool($varname_network(sticky-part).value)) && ($varname_network(sticky_chans).value) { return }
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
alias oldnick_menu {
  if ($varname_global(old_nick,$$1).value != $null) { return $ifmatch }
}
alias old_nick_islisted {
  var %i = 1
  :loop
  if ($varname_global(old_nick,%i).value == $$1) { setvar $varname_global(old_nick,%i) $1 | return $true }
  if (%i == 10) { return $false }
  inc %i
  goto loop
}
alias old_nick_add {
  if (Guest isin $1) && ($right($1,1) isnum) { return }
  if ($old_nick_islisted($1) == $true) { return }
  setvar $varname_global(old_nick,next) $iif(($varname_global(old_nick,next).value),$ifmatch,1)
  var %i = $varname_global(old_nick,next).value
  setvar $varname_global(old_nick,%i) $1
  if (%i == 10) { setvar $varname_global(old_nick,next) 1 }
  else { setvar $varname_global(old_nick,next) %i + 1 }
}

on *:nick: {
  if ($nick == $me) { 
    if ($nick == $newnick) { old_nick_add $newnick }
    else { old_nick_add $me | old_nick_add $newnick  }
  }
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
alias parted_rooms {
  if ($1 isin beginend) { return }
  if ($1 > $chan(0)) { return }
  if ($chan($1).status == kicked) { return $chan($1) $block(kicked) : join $chan($1) }
  elseif ($chan($1).status == parted) { return $chan($1) $block(parted) : join $chan($1) }
  else { return - }
}
menu @motd_?* {
  close window : window -c $active
  -
  [motd] 
  .$iif(($status != connected),$style(2)) $chr($asc([)) $+ $server $+ $chr($asc(])) : motd
  .$style_proxy MyProxyIP.com : msg *status show-motd mypyip
  .-
  .on connect
  ..$iif($proxy_style,$ifmatch,$iif($varname_global(on-connect,show-motd).value == mypyip,$style(1))) [show MyProxyIP.com] : msg *status on-connect show-motd mypyip
  ..$iif($proxy_style,$ifmatch,$iif($varname_global(on-connect,show-motd).value != mypyip,$style(1))) show irc server : msg *status on-connect show-motd
  ..-
  ..$iif($proxy_style,$ifmatch,$iif(($bool($varname_global(motd_window).value)),$style(1))) show in custom window : setvar $varname_global(motd_window) $iif(($bool($varname_global(motd_window).value)),$false,$true)

}
alias style_sticky_menu {
  return $iif($style_proxy,$iif(($bool($varname_network(sticky-part).value) == $true),$style(3),$style(2)),$iif(($bool($varname_network(sticky-part).value) == $true),$style(2)))
}
alias style_link_on {
  if (!$chan) { return $style(2) }
  if ($varname_global(network-link,$chan).value == 1) { return $style(1) }

}
alias usermodes-menu {
  if (!$3) { return }
  if ($1 isin beginend) { return }
  if ($2 == unet) && ($ini($scriptdirumodes.ini,$network $+ -normal,0) > 0) { %net = $network $+ -normal }
  if ($2 == onet) && ($ini($scriptdirumodes.ini,$network $+ -oper,0) > 0) { %net = $network $+ -oper }
  if (!%net) { return }
  if ($ini($scriptdirumodes.ini,%net,0) == 0) { return }
  if ($ini($scriptdirumodes.ini,%net,$1) == $null) { return }
  return $3 $+ & $+ $ini($scriptdirumodes.ini,%net,$1) - $readini($scriptdirumodes.ini,%net,$ini($scriptdirumodes.ini,%net,$1)) : mode $me $3 $+ $ini($scriptdirumodes.ini,%net,$1)

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
  setvar $varname_global(auto_ia1,blank) $iif($1 != $null,$1,$iif(($varname_global(auto_ia1,blank).value == $true || $varname_global(auto_ia1,blank).value == $null),$false,$true))
}
alias style_annc_urls_on {
  return $iif(($varname_cid(urlcrawl,enabled).value),$style(1))
}
alias style_annc_urls_off {
  return $iif((!$varname_cid(urlcrawl,enabled).value),$style(1))
}
alias style_secure_url {
  if ($varname_global(urlcrawl,secure).value == $null) || ($bool($varname_global(urlcrawl,secure).value) == $true) { return $style(1) }
}
alias urlcrawl_secure_toggle {
  setvar $varname_global(urlcrawl,secure) $iif($style_secure_url,$false,$true)

}
alias urlcrawl_toggle {
  set $varname_cid(urlcrawl,enabled) $iif(($varname_cid(urlcrawl,enabled).value),$false,$true)
}
alias query_menu {
  if ($1 isin beginend) { return }
  if ($query($1)) { return $query($1) : whois $query($1) }
}
alias unstick_folders {
  if ($1 isin beginend) { return }
  var %dir = $finddir($getdir,*,$$1,2)
  return $remove(%dir,$getdir) : unstick $qt(%dir)
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

alias play-sound {
  var %file = $qw($2-), %fn
  if (!$exists(%file)) { return }
  var %n = 1, %empty
  while (%n < 16) {
    %fn = $varname_global(sound-history,%n).value
    if (%fn) && ($exists(%fn) == $false) { var %fn | unsetvar $varname_global(sound-history,%n) }
    elseif (%fn == %file) { %empty = skip | break }
    if (!%fn) && (!%empty) { %empty = %n }
    inc %n
  }
  if (%empty == $null) {
    if ($varname_global(sound-history,last-n).value == $null) { setvar $varname_global(sound-history,last-n) 1 }
    setvar $varname_global(sound-history,last-n) $calc($varname_global(sound-history,last-n).value + 1)
    if ($varname_global(sound-history,last-n).value > 15) { setvar $varname_global(sound-history,last-n) 1 }
    setvar $varname_global(sound-history,$varname_global(sound-history,last-n).value) %file
  }
  else { if (%empty != skip) { setvar $varname_global(sound-history,%empty) %file } }
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

alias style_bad_chan_off {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_bad_chan,$network $+ $chan).value) { return $style(1) }
}
alias style_bad_chan {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_bad_chan,$network $+ $chan).value) { return $style(1) }
}

alias style_allow_repeat {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_room_repeat,$network $+ $chan).value) { return $style(1) }
}
alias style_bad_script_menu {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_bad_scripts,$network  $+ $chan).value) { return $style(1) }
}
alias style_bad_script_ban {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_bad_scripts,$network  $+ $chan).value == $true) { return $style(1) }
}
alias style_bad_chan {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_bad_chan,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_url {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_room_url,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_url_off {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_room_url,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_room_name {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_room_name,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_nick {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_room_nick,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_room_name_on {
  if (!$network) || (!$chan) { return $style(2) }
  if (!$varname_global(allow_room_name,$network $+ $chan).value) { return $style(1) }
}

alias style_allow_binart {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_room_binart,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_bad_word {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_bad_word,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_bad_word_off {
  if (!$network) || (!$chan) { return }
  if (!$varname_global(allow_bad_word,$network $+ $chan).value) { return $style(1) }

}
alias style_allow_idle {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_room_idle,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_share {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_room_sharing,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_clone {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_room_clone,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_rand_nick {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_rand_nick,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_long_word {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_long_word,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_line {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_long_line,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_paste {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_room_paste,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_non_default {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_room_non_default,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_rand_text {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_rand_text,$network $+ $chan).value) { return $style(1) }
}
alias style_allow_ascii {
  if (!$network) || (!$chan) { return $style(2) }
  if ($varname_global(allow_rand_text,$network $+ $chan).value) && $&
    ($varname_global(allow_room_paste,$network $+ $chan).value) && $&
    ($varname_global(allow_long_line,$network $+ $chan).value) && $&
    ($varname_global(allow_long_word,$network $+ $chan).value) && $&
    ($varname_global(allow_room_repeat,$network $+ $chan).value) { return $style(1) }
}

alias set_allow_bad_scripts {
  if (!$varname_global(allow_bad_scripts,$$network  $+ $$chan).value) { setvar $varname_global(allow_bad_scripts,$network  $+ $chan) $true }
  else { unsetvar $varname_global(allow_bad_scripts,$network  $+ $chan) | unsetvar $varname_global(allow_room_non_default,$network $+ $chan) }
}

alias set_allow_room_binart {
  if (!$varname_global(allow_room_binart,$$network $+ $$chan).value) { setvar $varname_global(allow_room_binart,$network $+ $chan) $true }
  else { unsetvar $varname_global(allow_room_binart,$network $+ $chan) | unsetvar $varname_global(allow_room_default,$network $+ $chan) }


}
alias set_allow_rand_nick {
  if (!$varname_global(allow_rand_nick,$$network $+ $$chan).value) { setvar $varname_global(allow_rand_nick,$network $+ $chan) $true }
  else { unsetvar $varname_global(allow_rand_nick,$network $+ $chan) | unsetvar $varname_global(allow_room_non_default,$network $+ $chan) }
}
alias set_allow_room_clone {
  if (!$varname_global(allow_room_clone,$$network $+ $$chan).value) { setvar $varname_global(allow_room_clone,$network $+ $chan)} $true }
  else { unsetvar $varname_global(allow_room_clone,$network $+ $chan) | unsetvar $varname_global(allow_room_non_default,$network $+ $chan) }

}
alias set_allow_room_nick {
  if (!$varname_global(allow_room_nick,$$network $+ $$chan).value) { setvar $varname_global(allow_room_nick,$network $+ $chan)} $true }
  else { unsetvar $varname_global(allow_room_nick,$network $+ $chan) | unsetvar $varname_global(allow_room_non_default,$network $+ $chan) }
}


alias set_allow_room_badword {
  if (!$varname_global(allow_bad_word,$$network $+ $$chan).value) { setvar $varname_global(allow_bad_word,$network $+ $chan) $true }
  else { unsetvar $varname_global(allow_bad_word,$network $+ $chan) | unsetvar $varname_global(allow_room_default,$network $+ $chan) }
}
alias set_allow_room_non_default {
  if (!$varname_global(allow_room_non_default,$$network $+ $$chan).value) {
    setvar $varname_global(allow_room_non_default,$$network $+ $chan) $true
    set_allow_asciiart_non_default_true
    setvar $varname_global(allow_bad_scripts,$network $+ $chan) $true
    setvar $varname_global(allow_bad_scripts_menu,$network  $+ $chan) $true
    setvar $varname_global(allow_rand_nick,$network $+ $chan) $true
    setvar $varname_global(allow_room_clone,$network $+ $chan) $true
    setvar $varname_global(allow_room_non_default,$network $+ $chan) $true
  }
  else { 
    unsetvar $varname_global(allow_room_non_default,$network $+ $chan)
    unsetvar $varname_global(allow_bad_scripts,$network $+ $chan)
    unsetvar $varname_global(allow_rand_nick,$network $+ $chan)
    unsetvar $varname_global(allow_room_clone,$network $+ $chan)
    set_allow_asciiart_non_default_false
  }
}
alias set_allow_room_default {
  if (!$varname_global(allow_room_default,$$network $+ $$chan).value) {
    setvar $varname_global(allow_room_default,$network $+ $chan) $true
  }
  else { unsetvar $varname_global(allow_room_default,$network $+ $chan) }
  setvar $varname_global(allow_room_sharing,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  setvar $varname_global(allow_room_idle,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  setvar $varname_global(allow_bad_word,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  setvar $varname_global(allow_room_binart,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  setvar $varname_global(allow_room_name,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  setvar $varname_global(allow_room_url,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  setvar $varname_global(allow_bad_chan,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
  setvar $varname_global(allow_rand_text,$network $+ $chan) $varname_global(allow_room_default,$network $+ $chan).value
}
alias style_allow_default {
  if ($varname_global(allow_room_sharing,$$network $+ $$chan).value && $&
    $varname_global(allow_room_idle,$network $+ $chan).value && $& 
    $varname_global(allow_room_idle,$network $+ $chan).value && $& 
    $varname_global(allow_bad_word,$network $+ $chan).value && $& 
    $varname_global(allow_room_binart,$network $+ $chan).value && $& 
    $varname_global(allow_room_name,$network $+ $chan).value && $& 
    $varname_global(allow_room_url,$network $+ $chan).value && $& 
    $varname_global(allow_bad_chan,$network $+ $chan).value) { return $style(1) }
}
alias set_allow_room_bad_room {
  if (!$varname_global(allow_bad_chan,$network $+ $chan).value) { setvar $varname_global(allow_bad_chan,$network $+ $chan) $true }
  else { unsetvar $varname_global(allow_bad_chan,$network $+ $chan) | unsetvar $varname_global(allow_room_default,$network $+ $chan) }
}
alias set_allow_room_repeat {
  if (!$varname_global(allow_room_repeat,$network $+ $chan).value) { setvar $varname_global(allow_room_repeat,$network $+ $chan) $true }
  else { unsetvar $varname_global(allow_room_repeat,$network $+ $chan) | unsetvar $varname_global(allow_room_non_default,$network $+ $chan) }

}
alias set_allow_room_paste {
  if (!$varname_global(allow_room_paste,$network $+ $chan).value) { setvar $varname_global(allow_room_paste,$network $+ $chan) $false }
  else { unsetvar $varname_global(allow_room_paste,$network $+ $chan) | unsetvar $varname_global(allow_room_non_default,$network $+ $chan) }
}
alias set_allow_room_long_word {
  if ($varname_global(allow_long_word,$network $+ $chan).value == $null) { setvar $varname_global(allow_long_word,$network $+ $chan) $false }
  else { unsetvar $varname_global(allow_long_word,$network $+ $chan) | unsetvar $varname_global(allow_room_non_default,$network $+ $chan) }

}
alias set_allow_room_long_line {
  if (!$varname_global(allow_long_line,$network $+ $chan).valuel) { setvar $varname_global(allow_long_line,$network $+ $chan) $false }
  else { unsetvar $varname_global(allow_long_line,$network $+ $chan | unsetvar $varname_global(allow_room_non_default,$network $+ $chan) }
}
alias set_allow_room_random_text {
  if (!$varname_global(allow_rand_text,$network $+ $chan).value) { setvar $varname_global(allow_rand_text,$network $+ $chan) $true }
  else { unsetvar $varname_global(allow_rand_text,$network $+ $chan) | unsetvar $varname_global(allow_room_default,$network $+ $chan) }
}
alias set_allow_asciiart {

  setvar $varname_global(allow_asciiart,$network $+ $chan) $iif((!$varname_global(allow_asciiart,$network $+ $chan).value), $true, $false)
  setvar $varname_global(allow_rand_text,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  setvar $varname_global(allow_room_paste,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  setvar $varname_global(allow_long_line,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  setvar $varname_global(allow_long_word,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  setvar $varname_global(allow_room_repeat,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
  setvar $varname_global(allow_room_non_default,$network $+ $chan) $varname_global(allow_asciiart,$network $+ $chan).value
}

alias set_allow_asciiart_non_default_true {
  setvar $varname_global(allow_asciiart,$network $+ $chan) $true
  setvar $varname_global(allow_rand_text,$network $+ $chan) $true
  setvar $varname_global(allow_room_paste,$network $+ $chan) $true
  setvar $varname_global(allow_long_line,$network $+ $chan) $true
  setvar $varname_global(allow_long_word,$network $+ $chan) $true
  setvar $varname_global(allow_room_repeat,$network $+ $chan) $true
}
alias set_allow_asciiart_non_default_false {
  setvar $varname_global(allow_asciiart,$network $+ $chan) $false
  setvar $varname_global(allow_rand_text,$network $+ $chan) $false
  setvar $varname_global(allow_room_paste,$network $+ $chan) $false
  setvar $varname_global(allow_long_line,$network $+ $chan) $false
  setvar $varname_global(allow_long_word,$network $+ $chan) $false
  setvar $varname_global(allow_room_repeat,$network $+ $chan) $false
  unsetvar $varname_global(allow_room_non_default,$network $+ $chan) 

}
alias SET_ALLOW_ROOM_FILE_SHARE {
  if (!$varname_global(allow_room_sharing,$network $+ $chan).value) { setvar $varname_global(allow_room_sharing,$network $+ $chan) $true }
  else { unsetvar $varname_global(allow_room_sharing,$network $+ $chan) }
  if ($varname_global(allow_room_sharing,$network $+ $chan).value) { setvar $varname_global(allow_room_default,$network $+ $chan) $true }

}
alias set_allow_room_idle {
  if ($varname_global(allow_room_idle,$network $+ $chan).value == $null) { setvar $varname_global(allow_room_idle,$network $+ $chan) $true }
  else { unsetvar $varname_global(allow_room_idle,$network $+ $chan) }
  if ($varname_global(allow_room_idle,$network $+ $chan).value) { setvar $varname_global(allow_room_default,$network $+ $chan) $true }


}
alias set_allow_room_url {
  if (!$varname_global(allow_room_url,$network $+ $chan).value) { setvar $varname_global(allow_room_url,$network $+ $chan) $true }
  else { unsetvar $varname_global(allow_room_url,$network $+ $chan) }
  if ($varname_global(allow_room_url,$network $+ $chan).value) { setvar $varname_global(allow_room_default,$network $+ $chan) $true }
}
alias set_allow_room_name {
  if (!$varname_global(allow_room_name,$network $+ $chan).value) { setvar $varname_global(allow_room_name,$network $+ $chan) $true }
  else { unsetvar $varname_global(allow_room_name,$network $+ $chan) }
  if ($varname_global(allow_room_name,$network $+ $chan).value) { setvar $varname_global(allow_room_default,$network $+ $chan) $true }
}
alias menu_disable_oper_scan {
  if (!$bool($varname_cid(oper-scan-cid).value)) && (!$bool($varname_network(oper-scan-net).value)) && (!$bool($varname_global(oper-scan-client).value)) { return $style(3) }

}
alias style_oper_scan_client {
  if ($varname_global(oper-scan-client,blank).value == $true) { return $style(3) }
}
alias toggle_oper_scan_client {
  setvar $varname_global(oper-scan-client,blank) $true
  unset $varname_network(oper-scan-net)
  unset $varname_cid(oper-scan-cid)
}
alias disable_oper_scan {
  unset $varname_cid(oper-scan-cid)
  unset $varname_network(oper-scan-net)
  unsetvar $varname_global(oper-scan-client,blank)
}
alias style_oper_scan_cid {
  if ($bool($varname_cid(oper-scan-cid).value)) { return $style(3) }
}
alias toggle_oper_scan_cid {
  set $varname_cid(oper-scan-cid) $true
  unset $varname_network(oper-scan-net)
  unsetvar $varname_global(oper-scan-client,blank)
}

alias style_oper_scan_net {
  if ($network == $null) { return $style(2) }
  if ($bool($varname_network(oper-scan-net).value)) { return $style(3) }
}
alias toggle_oper_scan_net {
  if ($network == $null) { return }
  set $varname_network(oper-scan-net) $true
  unset $varname_cid(oper-scan-cid)
  unsetvar $varname_global(oper-scan-client,blank)
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
  if ($bool($varname_cid(trio-ircproxy.py,active).value) == $true) { return $true }
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
alias create_shortcuts_mirc {
  var %ini = $qt($scriptdir..\..\mirc.ini)
  run -hnp python $qt($scriptdir..\create_shortcut.py) $qt($mircexe) b -i $qt($%ini)
  echo $color(info) -s *** Created shortcut in folder $qt($nofile(%ini))
}
alias create_shortcuts_desktop {
  var %ini = $qt($scriptdir..\..\mirc.ini)
  run -hnp $qt(python $scriptdir..\create_shortcut.py) $qt($mircexe) d -i $qt(%ini)
  echo $color(info) -s *** Creating shortcut on the Desktop
}
alias create_shortcuts_both {
  var %ini = $qt($scriptdir..\..\mirc.ini)
  run -hnp python $qt($scriptdir..\create_shortcut.py) $qt($mircexe) bd -i $qt(%ini)
  echo $color(info) -s *** Creating shortcut on Desktop and in folder $qt($nofile($mircini))
}
