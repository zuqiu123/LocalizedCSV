//
//  AppDelegate.swift
//  LocalizedCSV
//
//  Created by 张行 on 2017/8/17.
//  Copyright © 2017年 张行. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func exportCSV(_ sender: Any) {
        let openPannel = NSOpenPanel()
        openPannel.canChooseFiles = false
        openPannel.canChooseDirectories = true
        guard openPannel.runModal() == NSFileHandlingPanelOKButton else {
            return
        }
        guard let path = openPannel.urls.first?.absoluteString.replacingOccurrences(of: "file://", with: "") else {
            return
        }
        var content = ""
        var languages:[String] = []
        for l in CSVParseKit.shareManager().items {
            languages.append(l.name)
        }
        content += "\(languages.joined(separator: ","))\n"
        for c in LocalizeStringKit.shareManager().localizeDictionary {
            var needAdd = false
            for l in languages {
                var con = findValue(language: l, key: c.key)
                if l == languages[0] {
                    con.0 = c.key
                }
                if !con.1 {
                    needAdd = true
                }
            }
            if needAdd {
                content += "\([c.key.replacingOccurrences(of: ",", with: "{R}"),"",""].joined(separator: ","))\n"
            }
        }
        print(content)
        try? content.write(toFile: "\(path)/Localizable.csv", atomically: true, encoding: String.Encoding.utf8)
    }
    
    func findValue(language:String, key:String) -> (String,Bool) {
        var value:String?
        for item in CSVParseKit.shareManager().items {
            if item.name == language {
                value = item.list[key]
                break
            }
        }
        guard let v = value else {
            return ("",false)
        }
        guard v.characters.count > 0 else {
            return ("",false)
        }
        return (v,true)
    }

}
