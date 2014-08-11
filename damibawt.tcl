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
        if {[catch {
          # get ip info
          set ifconfig [exec /sbin/ifconfig]

          foreach line [split $ifconfig \r\n] {
            set line [string trim $line]
            if {[lindex $line 0] == "inet"} {
              set ip([lindex [split [lindex $line 1] :] 1]) [lindex [split [lindex $line 1] :] 1]
            }
          }

          notice $nick "IP Address: [array names ip]"
          notice $nick "    Uptime: [exec uptime]"
          notice $nick ""
        } output]} {
          notice $nick "had an error... $output"
        }
      }
      "load" {
        if {[catch {source [lrange $text 2 end]} output]} {
          notice $nick "An error occurred:"
          foreach line [split $output \r\n] {
            notice $nick $line
          }
        } else {
          notice $nick "Successfully loaded '[lrange $text 2 end]'"
        }
      }
      "raw" {
        putquick [lrange $text 2 end]
        notice $nick "Put to server: [lrange $text 2 end]"
      }
      "project" {
        switch [string tolower [lindex $text 2]] {
          "add" {
            # project add <type> <folder> <description>
          }
          "list" {
            # project list <wildcard>
          }
          "del" {
            # project del <id>
          }
        }
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
  putquick "NOTICE $nick :$text"
}
