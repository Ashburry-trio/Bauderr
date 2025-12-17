on *:start: {
  bde_start
}
alias bde_start {
  # create_shortcuts_both
  !.bigfloat off
  :adiirc
  !.switchbar off
  !.sound on
  !.menubar on
  !.treebar on
  !.dcc packetsize 65535
  !.pdcc on
  !.dcc maxcps $calc(1024 * 1024 * 12)
  .speak -lu Greetings
  unset %bde_cid_*
  unset %bde_net_*
  return
  :error
  goto adiirc
}
on *:connect: {
  .localinfo $iif($varname_global(localinfo,blank).value,$ifmatch,-u)
  autojoin
}
alias bool {
  if ($1 == enabled) || ($1 == enable) || (($1 isnum) && ($1 > 0)) || ($1 == true) || ($1 == $true) || ($1 == on) { return $true }
  else { return $false }
}
on *:quit: {
  if ($nick != $me) { return }
  ; DO all the code below in Python and just report in
  var %i = 1
  while $chan(%i) {
    if ($chan(%i).status != joined) { inc %i | continue }
    if ($allowcid_check_chans($chan(%i)) {
      .timerallowcid $+ $network $+ $chan(%i) $+ ?blank off
      return
    }
    .timerallowcid $+ $network $+ $chan(%i) -oi 1 25 /unset $allow_unset_var($chan(%i))
    inc %i
  }
}
alias -l allow_unset {
  return %bde_*allow* [ $+ [ $$network $+ $1 $+ $chr(35) $+ blank ] ]
}
on *:text:$chr(58) $+ trio-ircproxy isactive:$chr(42) $+ status: {
  set -e $varname_cid(trio-ircproxy.py,active) $true
  msg $nick mg-script active
}
alias allowcid_check_chans {
  if ($fromeditbox) || (!$isid) { return $false }
  var %i = 1
  while ($scid(%i)) {
    if ($nextchan_allowcid(%i,$1)) {
      return $true
    }
    inc %i
  }
  ; Continue
  return $false
}
alias nextchan_allowcid {
  if ($fromeditbox) || ($isid == $false) { return $false }
  if ($scid($1) == $cid) { return $false }
  if ($scid($1).$network != $network) { return $false }
  nextchan_reset
  while ($scid($1).$nextchan) {
    if ($v1 == $2) { /nextchan_reset | return $true }
  }
  return $false
}
alias nextchan {
  set $varname_global(allowcid_nextchan) $calc($varname_global(allowcid_nextchan).value + 1)
  if ($chan($varname_global(allowcid_nextchan).value).status) {
    if ($v1` == joined) { return $chan($varname_global(allowcid_nextchan)) }
  }
  else { nextchan_reset | return $false }
}
alias nextchan_reset {
  if ($fromeditbox) || ($isid) { return }
  unset $varname_global(allowcid_nextchan)
}
alias ialupdated {
  if ($1 == $null) || ($fromeditbox) || (!$isid) { return }
  return $iif(($chan($1).ial == $true), - complete, - update ial)
}
on *:part:#: {
  if ($nick != $me) { return }
  if ($allowcid_check_chans($chan)) { .timerallowcid $+ $network $+ $chan -io 1 25 /unset $allow_unset_var($chan) }

}
on *:kick:#: {
  if ($nick != $me) { return }
  if ($allowcid_check_chans($chan)) { .timerallowcid $+ $network $+ $chan -io 1 25 /unset $allow_unset_var($chan) }
}
on *:join:#: {
  if ($nick != $me) { return }
  .timerallowcid $+ $network $+ $chan off
}
alias qw {
  ; Is an identifier which takes one string item to quote. Must be an $id.
  ; First removes all quotes from start and end of string
  ; Then quotes the string
  if (!$siid) { return }
  var %text = $strip($1)
  var %comp = '"` $crlf $+ $chr(9)
  while ($left(%text,1) isin %comp) { %text = $right(%text,-1) }
  while ($right(%text,1) isin %comp) { %text = $left(%text,-1) }
  return $qt(%text)
}
on *:exit: {
  unset %bde_cid_*
  unset %bde_net_*
  unset %bde_*allow*
}
alias eecho {
  var %msg
  if ($1 == -sep) { %msg = $2- | linesep -s }
  else { %msg = $1- }
  echo -s 65,92Bauderr : %msg
  if ($active == Status Window) { return }
  if (@* iswm $active) { return }
  linesep -a
  echo -a 65,92Bauderr : %msg
}
alias strip-space-regx { 
  ; set to a variable to strip $crlf
  var %v = $regsubex($1-,/^\s+|\s+$/g,) | return %v 
}
alias strip-space-var {
  var %v = $crlf $+ $chr(32) $+ $chr(9)
  while ($left($1,1) isin %v) {
    tokenize 32 $left($1-,-1)
  }
  while ($right($1,1) isin %v) {
    tokenize 32 $right($1-,-1)
  }
}
alias varname_cid {
  if (!$0) || (!$isid) || ($fromeditbox) { return }
  ; to the connection id only
  var %varname = $+(%,bde_cid_,$1,!,$iif(($2 == $null),blank,$2),$chr(35),$activecid)
  if ($prop == value) { return [ [ %varname ] ] }
  return %varname
}
alias varname_network {
  if (!$0) || (!$isid) || ($fromeditbox) { return }
  var %varname = $+(%,bde_net_,$1,!,$iif(($2 == $null),blank,$2),$chr(35),$network)
  if ($prop == value) { return [ [ %varname) ] ] }
  return %varname
}
alias varname_global {
  if (!$0) || (!$isid) || ($fromeditbox) { return }
  var %varname = $+(%,bde_glob_,$1,$chr(35),$iif(($2 == $null),blank,$2))
  if ($prop == value) { return [ [ %varname ] ] }
  return %varname
}
alias varname_glob {
  if (!$0) || (!$isid) || ($fromeditbox) { return }
  var %varname = $+(%,bde_glob_,$1,$chr(35),$iif(($2 == $null),blank,$2))
  if ($prop == value) { return [ [ %varname ] ] }
  return %varname
}
alias varname_temp {
  if (!$0) || (!$isid) || ($fromeditbox) { return }
  var %varname = $+(%,bde_temp_,$1,$chr(35),$iif(($2 == $null),blank,$2))
  if ($prop == value) { return [ [ %varname ] ] }
  return %varname
}
alias script_info {
  tokenize 32 $strip($1-)
  if (!$0) { return }
  window -c @script_info
  /window -aCDe0g0k0rw2dDo +tf @Script_Info -1 -1 630 300 
  /titlebar @script_info

  if ($1 == -chan_link) {
    titlebar @script_info - Network / to / Network -- Channel Link
    aline @script_info 54,93Channel Link
    aline 52 @script_info -
    aline -p @script_info - The channel link script will relay what people say in the same channel names to different networks.
    aline -p @script_info So while you are in #allnitecafe on Undernet and you turn on channel link and join #allnitecafe (same channel) on network Freenode; chat messages will be relayed back and forth.
    aline -p @script_info - 
  }
  elseif ($1 == -urls) {
    titlebar @script_info - describe URLs
    aline @script_info 54,93describe URLs
    aline 52 @script_info -
    aline -p @script_info - When someone speeks a web-site address such as .url www.myproxyip.com or .url https://website.com the web-page will be crawled.
    aline -p @script_info Information such as the title and description of the web-page will be printed in to the channel.
  }
  elseif ($1 == -flood) {
    titlebar @script_info - flood protection information
    aline @script_info 54,93Flood Protection
    aline 52 @script_info -
    aline -p @script_info - Some people on IRC take pleasure in attacking other people by means of flood bots. These flood bots are used to send hundereds of ctcps, ctcp replies, messages, notices, actions, DCC chat/sends, join/part (cycle flood), nick changing (nick flood; makes it difficult to kick the bot out) and topic flood (if channel mode is -t); with the purpose of causing an disconnection of the victim IRC connections; or just to trouble other IRC users.
    aline -p @script_info Channel flood protection protects the channel from people who are sending too many messages too quickly; by banning (+b) and kicking the flood bots out of the channel. Trio-ircproxy.py will not relay flooding messages, so there is no need to /ignore the flood bots while flood protection is turned ON, although it does not hurt. There is also an /silence command you may employ if you want to ignore all messages (only on supported networks, amke sure you get to know this command for each network). Ctcp Ping replies are adjusted for a delayed reply, since Trio-ircproxy.py may delay the reply; to wait for a possible flood attempt.
    aline -p @script_info Personal flood protection protects just yourself, by ignoring any floods to your personal nickname. Changing your nickname does not solve the problem but rather opens you up to another attack called a nick collision. Trio-ircproxy.py is careful to not block legit activity even after the person has flooded. Flood bots are added to an seperate akick/ignore/notify list from the normal control lists.  Network-services and channel modes must be skillfully employed to stop channel floods, this must be set by your channel founder.
    aline -p @script_info Trio-ircproxxy.py keeps an history of people who have flooded you or your channels, even while flood protection is off. This way, you will be notified when an abuser joins a channel or sends you a message. In order for a flood to be determined as a flood in history there must be more than one nickname involved.  Trio-ircproxy.py is very quick to receive IRC messages and will log all flood & takeover activity, so reports can be quickly made to interested irc opers.
    aline -p @script_info -
    sline @script_info 4
  }

}
alias errecho {
  if ($active == Status Window) { echo -a 4Error: $1- }
  else { echo -as 4Error: $1- }
}
alias showtags {
  if ($1- == $null) { echo 2 -e * /showtags: please specify filename, eg. /showtags file.mp3 | return }
  if (!$exists($1-)) { echo 1 -e * /showtags: the filename you specified does not exist | return }
  echo 1 id3: $sound($1-).id3
  echo 1 tags: $sound($1-).tags
  var %n = $sound($1-,0).tag
  while (%n > 0) {
    echo 1 tag: $sound($1-,%n).tag
    dec %n
  }
}
alias build_mode {
  if (!$siid) || ($fromeditbox) || ($len($1) != 1) || ($2 != $null && $2 !isnum || $2 < 1) { return }
  var %i = 1
  var %mode = $1
  var %max = $iif(($modespl) || $2 || 4),$ifmatch)
  while (%i < %max) {
    %mode = %mode $+ $1
    inc %i
  }
  return %mode
}

alias /j {
  if (($active ischan) && ($1 !ischan) || (((part isin $chan($chan).status) || (kick isin $chan($chan).status))) { join $active $1- }
  else { /join #$$1- }
}
alias /p if ($left($1,1) isin $chantypes) { /part $$1- | return } | if ($active ischan) { /part # $1- }
alias /n if ($left($1,1) isin $chantypes) { /names $$1 | return } | if ($active ischan) { /names # }
alias /w /whois $$1
alias /k if ($left($1,1) isin $chantypes) && ($2 != $null) { kick $1 $$2- | return } | if ($active ischan) { /kick # $$1 $2- }
alias /q /query $$1-
alias /op if ($left($$1,1) isin $chantypes) && ($2 != $null) { mode $1 $+(+,$build_mode(o,$calc($0 - 1)) $$2- | return } | if ($active ischan) { mode # $+(+,$build_mode(o,$0)) $$1- }
alias /dop if ($left($$1,1) isin $chantypes) && ($2 != $null) { mode $1 $+(-,$build_mode(o,$calc($0 - 1)) $$2- | return } | if ($active ischan) { mode # $+(-,$build_mode(o,$0)) $$1- }
alias deop dop $$1-
alias /send /dcc send $1 $$2-
alias /chat /dcc chat $$1-
alias /ping /ctcp $$1 ping
alias /s /server $1-
