#!/usr/bin/env swift
import Cocoa

// Emit one line per on-screen window:
//   window_id<TAB>app_name<TAB>owner_pid<TAB>title
//
// Tab delimiter so app names or window titles containing ":" don't break
// downstream parsing.
//
// `title` (kCGWindowName) is only populated when the calling process has
// Screen Recording permission; otherwise it comes back as the empty string.
// Without Screen Recording, downstream code can still match against the
// owning process's command line via owner_pid.
let options = CGWindowListOption(arrayLiteral: .optionOnScreenOnly, .excludeDesktopElements)
guard let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
    exit(1)
}

// Replace any tab/newline/CR with a space so a user-controllable window
// title can't corrupt the tab-delimited line protocol downstream.
func sanitize(_ s: String) -> String {
    var out = ""
    out.reserveCapacity(s.count)
    for ch in s {
        if ch == "\t" || ch == "\n" || ch == "\r" {
            out.append(" ")
        } else {
            out.append(ch)
        }
    }
    return out
}

for window in windowList {
    guard let windowID = window[kCGWindowNumber as String] as? Int,
          let ownerName = window[kCGWindowOwnerName as String] as? String,
          let ownerPID = window[kCGWindowOwnerPID as String] as? Int,
          let layer = window[kCGWindowLayer as String] as? Int,
          layer == 0 else {
        continue
    }
    let title = (window[kCGWindowName as String] as? String) ?? ""
    print("\(windowID)\t\(sanitize(ownerName))\t\(ownerPID)\t\(sanitize(title))")
}
