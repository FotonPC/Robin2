# if { [catch {package require tile 0.8 }] != 0 } { return }

if {[file isdirectory [file join $dir red]]} {
    package ifneeded ttk::theme::red 0.0.1 \
        [list source [file join $dir red.tcl]]
}
