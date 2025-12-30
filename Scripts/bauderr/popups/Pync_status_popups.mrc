$chr(46) $chr(58) PyNet Converge $str($chr(58),2) $chr(58)
-
&flood protection
-
&client cmnds
&server cmnds
-
script &functions
&room functions

-
$style_proxy &network services
-
&trio-ircproxy.py
&xdcc search
&translate text
.default language : setvar $varname(global(translate,default) $$?="enter your default language:"
.$style_proxy list languages : msg *status tr-list
&Spelling Correction
.info : eecho Use the command /sp-check [words...] for correct spelling of the words
-
$iif(($status != connected), $style(2)) &quit irc : quit 71,92.: PyNet Converge script named Bauderr :: :
&connect irc
