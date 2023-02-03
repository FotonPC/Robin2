# red.tcl -
#
#   Experimental!
#
#  Copyright (c) 2007-2008 Mats Bengtsson
#
# $Id: red.tcl,v 1.2 2009/10/25 19:21:30 oberdorfer Exp $

package require Tk 8.4;                 # minimum version for Tile
package require tile 0.8;               # depends upon tile


namespace eval ttk {
  namespace eval theme {
    namespace eval red {
      variable version 0.1
    }
  }
}

namespace eval ttk::theme::red {

  #variable imgdir [file join [file dirname [info script]] red]
  #variable I
  #array set I [tile::LoadImages $imgdir *.png]

  variable dir [file dirname [info script]]

  # NB: These colors must be in sync with the ones in red.rdb

  variable colors
  array set colors {
    -disabledfg	"#ffddee"
    -frame  	"#441117"
    -dark	    "#441117"
    -darker 	"#331113"
    -darkest	"#331113"
    -yellowdark "#552239"
    -lighter	"#626262"
    -lightest 	"#626262"
    -selectbg	"#8877aa"
    -selectfg	"#000000"
  }
  if {[info commands ::ttk::style] ne ""} {
    set styleCmd ttk::style
  } else {
    set styleCmd style
  }
  font create myDefaultFont2 -family "Jetbrains Mono" -size 15
    option add *font myDefaultFont2

  $styleCmd theme create red -parent default -settings {

    # -----------------------------------------------------------------
    # Theme defaults
    #
    $styleCmd configure "." \
        -background $colors(-frame) \
        -foreground white \
        -bordercolor $colors(-darkest) \
        -darkcolor $colors(-dark) \
        -lightcolor $colors(-lighter) \
        -troughcolor $colors(-darker) \
        -selectbackground $colors(-selectbg) \
        -selectforeground $colors(-selectfg) \
        -selectborderwidth 0 \
        -font myDefaultFont2 \
        -relief flat\
        ;

    $styleCmd map "." \
        -background [list disabled $colors(-frame) \
        active $colors(-lighter)] \
        -foreground [list disabled $colors(-disabledfg)] \
        -selectbackground [list  !focus $colors(-darkest)] \
        -selectforeground [list  !focus white] \
        ;

    # ttk widgets.
    $styleCmd configure TButton \
        -background $colors(-darker) -width -8 -padding {5 1} -relief flat
    $styleCmd configure TMenubutton \
        -width -11 -padding {5 1} -relief flat
    $styleCmd configure TCheckbutton \
        -indicatorbackground "#ffffff" -indicatormargin {0 0 0 0} -relief flat
    $styleCmd configure TRadiobutton \
        -indicatorbackground "#ffffff" -indicatormargin {0 0 0 0} -relief flat

    $styleCmd configure TEntry \
        -fieldbackground white -foreground black \
        -padding {2 0} -relief flat -disabledbackground $colors(-lighter)
    $styleCmd configure TCombobox \
        -fieldbackground $colors(-yellowdark)  -foreground black \
        -padding {2 0} -relief flat -arrowcolor "#aa8800" -bordercolor $colors(-dark) -foreground "#ffeeaa" -darkcolor $colors(-dark) -focusfill $colors(-dark) -arrowsize 20 -arrowstyle flat7x4


    $styleCmd configure TNotebook.Tab \
        -padding {6 2 6 2} -relief flat -bordercolor $colors(-yellowdark) -foreground "#cceeff"

    $styleCmd configure TNotebook -bordercolor $colors(-dark) -darkcolor $colors(-dark) -background $colors(-dark) -lightcolor $colors(-dark) -padding {5 5} -tabmargins {0 0} -foreground "#0022aa"
    $styleCmd map TNotebook.Tab  -background [list \
        selected $colors(-yellowdark)]


    # tk widgets.
    $styleCmd map Menu \
        -background [list active $colors(-lighter)] \
        -foreground [list disabled $colors(-disabledfg)]

    $styleCmd configure TreeCtrl \
        -background gray30 -itembackground {gray60 gray50} \
        -itemfill white -itemaccentfill yellow -relief flat

    $styleCmd map Treeview \
        -background [list selected $colors(-selectbg)] \
        -foreground [list selected $colors(-selectfg)]

    $styleCmd configure Treeview -fieldbackground $colors(-lighter)
  }
}

# A few tricks for Tablelist.

namespace eval ::tablelist:: {

  proc redTheme {} {
    variable themeDefaults

    array set colors [array get ttk::theme::red::colors]

    array set themeDefaults [list \
      -background	  "Black" \
      -foreground	  "White" \
      -disabledforeground $colors(-disabledfg) \
      -stripebackground	  "#191919" \
      -selectbackground	  "#4a6984" \
      -selectforeground	  "DarkRed" \
      -selectborderwidth 0 \
      -font		myDefaultFont2 \
      -labelbackground	$colors(-frame) \
      -labeldisabledBg	"#dcdad5" \
      -labelactiveBg	"#eeebe7" \
      -labelpressedBg	"#eeebe7" \
      -labelforeground	white \
      -labeldisabledFg	"#999999" \
      -labelactiveFg	white \
      -labelpressedFg	white \
      -labelfont	myDefaultFont2 \
      -labelborderwidth	2 \
      -labelpady	1 \
      -arrowcolor	"" \
      -arrowstyle	flat 7x4 \
      ]
  }
}

package provide ttk::theme::red $::ttk::theme::red::version
