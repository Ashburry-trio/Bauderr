alias testpost {
  ; bset -tc &h -1 Set-Cookie: session=daa00a67-ddc6-4c16-815c-ed10021d788a
  bset -tc &h -1 Date: Fri, 11 Aug 2023 11:10:55 GMT
  bset -tc &post -1 username=ashburry&password=Baudsmoke5
  write -c getURL.txt
  echo ID: $urlget(https://www.mslscript.com/login.html,pf,getURL.txt,/testurl, &h, &post)
}
alias testurl {
  unset %target
  echo >> $read(getURL.txt,1-)
  echo >> $urlget($1).rcvd
  echo >> $urlget($1).reply
}
