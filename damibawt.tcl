bind pubm n *,* pub:cmd

proc pub:cmd {nick uhost handle chan text} {
  # <botnick>, <command> <args>
  # bots, <command> <args>
  global botnick
  if {([string tolower [lindex $text 0]] == "bots,") || ([string tolower [lindex $text 0]] == [string tolower "$botnick,"])} {
    switch [lindex $text 1] {
      "rehash" {
        if {[catch {rehash} output]} {
          bnotice $nick "An error occurred while rehashing:"
          foreach line [split $ouptput \r\n] {
            bnotice $nick $line
          }
        } else {
          bnotice $nick "Successfully rehashed."
        }
      }
      "status" {
      }
      "load" {
        if {[catch {rehash} output]} {
          bnotice $nick "An error occurred while rehashing:"
          foreach line [split $ouptput \r\n] {
            bnotice $nick $line
          }
        } else {
          bnotice $nick "Successfully rehashed."
        }
      }
      "raw" {
        putquick [lrange $text 2 end]
        bnotice $nick "Put to server: [lrange $text 2 end]"
      }
      default {
        catch {eval [lrange $text 1 end]} output
        foreach line [split $output \r\n] {
          bnotice $nick "Tcl: $line"
        }
        bnotice $nick "End."
      }
    }
  }
}

proc bnotice {nick text} {
  puthelp "NOTICE $nick :$text"
}

putlog "% Loaded damibawt.tcl"
