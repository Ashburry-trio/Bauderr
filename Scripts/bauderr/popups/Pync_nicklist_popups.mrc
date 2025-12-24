Info:/uwho $1
Whois:/whois $$1
Query:/query $$1
-
blackball *!*@address:/proxy-blackball $$1
Control
.Ignore:/ignore $$1 1
.Unignore:/ignore -r $$1 1
.Op:/mode # +ooo $$1 $2 $3
.Deop:/mode # -ooo $$1 $2 $3
.Voice:/mode # +vvv $$1 $2 $3
.Devoice:/mode # -vvv $$1 $2 $3
.Kick:/kick # $$1
.Kick (why):/kick # $$1 $$?="Reason:"
.Ban:/ban $$1 2
.Ban, Kick:/ban $$1 2 | /timer 1 3 /kick # $$1
.Ban, Kick (why):/ban $$1 2 | /timer 1 3 /kick # $$1 $$?="Reason:"
CTCP
.Ping:/ctcp $$1 ping
.Time:/ctcp $$1 time
.Version:/ctcp $$1 version
DCC
.Send:/dcc send $$1
.Chat:/dcc chat $$1
-
Slap!:/me slaps $$1 around a bit with a large trout
