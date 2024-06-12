ON *:SOCKlisten:test*:{
  if $sockerr > 0 { echo socklisten sockerr $sockname | return }
  var %sa = test $+ $r(a,z)
  sockaccept %sa
  echo sock accepted %sa
}
on *:sockopen:test*: {
  if ($sockerr > 0) { echo -a sock $sockname failed to connect. | return }
  else { echo -a sock $sockname connected. | return }
}
on *:sockread:test*: {
  if ($sockerr > 0) { echo sock read error for $sockname | return }
  else {
    var %myvar
    :loop
    sockread %myvar
    if ($sockbr == 0) return
    echo read $sockname : %myvar
    goto loop
  }
}
on *:sockclose:test*: {
  echo -a sock $sockname closed.
}
