Add scripts in Python:
Announce URL title to user or to channel.
prevent password from being sent to network or dcc
auto-authenticate when changing nick.
Displays network interface bandwidth on a bar.
Forward DCC SEND requests to a different client.
Shorten URLs with is.gd or tinyurl
Display who is affected when a mode with a hostmask argument is set.
Sends machine uptime to current channel.
Automatically attempts to regain IRC primary nick.
Recover channel operator in empty channel.
List multiple occurences of the same nick(s) in a set of channels
Changing the password does not take affect until the new password has been used,
Force nick for spcific networks, on start
Self Collide Prevention : Prevent using the same nick on the same network throughout all client connections.
: also changing to a nick that is in a common channel on any given network.
: nick collide bots will not work with this proxy as best as can be avoided.
alias done_url {
  echo -ae You have logged in! I think $urlget($1).reply
  echo >> $bvar(&test,1,$bvar(&test,0).text).text
}
alias testurl {
  bset -t &w -1 username=Ashburrry&password=baudsmoke
  bset -z &headers
  %n = $urlget(https://www.mslscript.com/login.html,bg,&test,/done_url)
  ; %n = $urlget(https://www.mslscript.com/login.html,bp,&test,/done_url,&headers,&w)
  if (!%n) { echo -ea Check your internet connection and... try again. }
}
