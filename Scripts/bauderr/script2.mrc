ON *:SOCKlisten:test*:{
  if $sockerr > 0 { echo socklisten sockerr $sockname | return }
  var %sa = test_accept_ $+ $r(A,Z) $+ $r(A,Z) $+ $r(A,Z) $+ $r(A,Z) $+ $r(A,Z)
  sockaccept %sa
  echo sock accepted as %sa
}
on *:sockopen:test*: {
  if ($sockerr > 0) { echo -a sock $sockname failed to connect. | return }
  else { echo -a sock $sockname connected to $sock($sockname).ip on port $sock($sockname).port | return }
}
on *:sockread:test*: {
  if ($sockerr > 0) { echo -a sock read error for $sockname | return }
  var %myvar
  :loop
  sockread -n %myvar
  if ($sockbr == 0) { return }
  if (%myvar == $null) { return }
  echo >> 56read $sockname : %myvar
  goto loop
}
on *:sockclose:test*: {
  echo -a sock $sockname closed.
}

; Gemini.Man.2019.TrueHD.Atmos.AC3.MULTISUBS.2160p.UHD.HDR.BluRay.x265.HQ-TUSAHD
