on *:start: {
  bde_start
}
alias bde_start {
  !.bigfloat off
  !.switchbar off
  !.sound on
  !.menubar on
  !.treebar on
  !.dcc maxcps $calc(1024 * 1024 * 12)
  .speak -lu Greetings
  unset %bde_cid_*
  unset %bde_net_*
}
on *:connect: {
  .localinfo $iif($varname_global(localinfo,blank).value,$ifmatch,-u)
}

on *:text:*:$chr(42) $+ status: {
  if ($1- == :trio-ircproxy active) {
    set -e $varname_cid(trio-ircproxy.py,active) $true
    msg $nick mg-script active
  }
}

; Create on quit for $me /scid -a /set variable value $+ $$network $status to see 
; if any connections remain on the quit network befre unsetting %bde_*allow* $+ $network $+ *
; do not unset %*allow* if it is still in use by another connection. Same with channels.
; this must be done through Python

alias ialupdated {
  if ($1 == $null) { return }
  return $iif(($chan($1).ial == $true), - updated, - false)
}
on *:part:#: {
  if ($nick == $me) { .timerallow $+ $$network $+ $chan 1 10 /unset %bde_*allow* $+ $$network $+ $chan $+ * }
}
on *:kick:#: {
  if ($knick == $me) { .timerallow $+ $cid $+ $chan 1 10 /unset %bde_*allow* [ $+ [ $$network $+ $chan $+ * ] ] }
}
on *:join:#: {
  if ($nick == $me) { .timerallow $+ $cid $+ $chan off | return }
  status_msg get chan_allow $chan
}
alias qw {
  var %text = $1
  while ($left(%text,1) isin '"`) { %text = $right(%text,-1) }
  while ($right(%text,1) isin '"`) { %text = $left(%text,-1) }
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
  echo -s 54,93Bauderr : %msg
  if ($active == Status Window) { return }
  if (@* iswm $active) { return }
  linesep -a
  echo -a 54,93Bauderr : %msg
}
alias strip-space-regx { 
  ; set to a variable to strip $crlf
  var %v = $regsubex($1-,/^\s+|\s+$/g,) | return %v 
}
alias strip-space-var {
  var %v = $1-
  while ($left($1,1) isin $crlf $+ $chr(32)
}
alias varname_cid {
  if ($1 == $null) { return }
  ; to the connection id only
  var %varname = $+(%,bde_cid_,$1,!,$iif(($2 == $null),blank,$2),$chr(35),$activecid)
  if ($prop == value) { return [ [ %varname ] ] }
  return %varname
}
alias varname_network {
  if ($1 == $null) { return }
  var %varname = $+(%,bde_net_,$1,!,$iif(($2 == $null),blank,$2),$chr(35),$network)
  if ($prop == value) { return [ [ %varname) ] ] }
  return %varname
}
alias varname_global {
  if ($1 == $null) { return }
  var %varname = $+(%,bde_glob_,$1,$chr(35),$iif(($2 == $null),blank,$2))
  if ($prop == value) { return [ [ %varname ] ] }
  return %varname
}
alias varname_glob {
  if ($1 == $null) { return }
  var %varname = $+(%,bde_glob_,$1,$chr(35),$iif(($2 == $null),blank,$2))
  if ($prop == value) { return [ [ %varname ] ] }
  return %varname
}
alias varname_temp {
  if ($1 == $null) { return }
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
    aline -p @script_info - When someone speeks a web-site address such as .url www.mslscript.com or .url https://website.com the web-page will be crawled.
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
alias /op /mode # +ooo $$1 $2 $3
alias /dop /mode # -ooo $$1 $2 $3
alias /j /join #$$1 $2-
alias /p {
  if ($left($1,1) == $chr(35)) { /part $1- }
  else { /part # $1- }
}
alias /n /names #$$1
alias /w /whois $$1
alias /k /kick # $$1 $2-
alias /q /query $$1
alias /send /dcc send $1 $$2-
alias /chat /dcc chat $1
alias  /ping /ctcp $$1 ping
alias /s /server $$1-
