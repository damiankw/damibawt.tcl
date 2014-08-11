bind pubm n *,* pub:cmd

proc pub:cmd {nick uhost handle chan text} {
  # <botnick>, <command> <args>
  # bots, <command> <args>
  global botnick
  if {([string tolower [lindex $text 0]] == "bots,") || ([string tolower [lindex $text 0]] == "$botnick,")} {
    switch [lindex $text 1] {
      "rehash" {
        if {[catch {rehash} output]} {
          notice $nick "An error occurred while rehashing:"
          foreach line [split $ouptput \r\n] {
            notice $nick $line
          }
        } else {
          notice $nick "Successfully rehashed."
        }
      }
      "status" {
        notice $nick ".. a status?"
      }
      "load" {
        if {[catch {rehash} output]} {
          notice $nick "An error occurred while rehashing:"
          foreach line [split $ouptput \r\n] {
            notice $nick $line
          }
        } else {
          notice $nick "Successfully rehashed."
        }
      }
      "raw" {
        putquick [lrange $text 2 end]
        notice $nick "Put to server: [lrange $text 2 end]"
      }
      default {
        catch {eval [lrange $text 1 end]} output
        foreach line [split $output \r\n] {
          notice $nick "Tcl: $line"
        }
        notice $nick "End."
      }
    }
  }
}

proc notice {nick text} {
  puthelp "NOTICE $nick :$text"
}
