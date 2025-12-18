#!/usr/bin/env swift
import Cocoa

// Get on-screen windows and print "window_id:app_name" for each
let options = CGWindowListOption(arrayLiteral: .optionOnScreenOnly, .excludeDesktopElements)
guard let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
    exit(1)
}

for window in windowList {
    guard let windowID = window[kCGWindowNumber as String] as? Int,
          let ownerName = window[kCGWindowOwnerName as String] as? String,
          let layer = window[kCGWindowLayer as String] as? Int,
          layer == 0 else {
        continue
    }
    print("\(windowID):\(ownerName)")
}
