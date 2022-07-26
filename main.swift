///
///  togglebright
///
///  Send keyboard codes to decrease and then increase screen brightness a few seconds after each system wakeup.
///
///  This is a workaround to the problem of screen brightness being increased after wakeup (seen with an LG Ultrafine monitor
///  with MacOS 12.3, 12.4 on Mac Studio).
///
///  Created by Michael Rourke on 06/05/22.
///

import AppKit
import Foundation

/// install this cmd here
let cmdPath = "/Users/michaelr/bin/togglebright"

let cmdName = "togglebright"
let cmdArg = "background"

class App {
    /// decrease then increase display brightness using keyboard
    let script = """
            tell application "System Events"
                key code 144
                key code 145
            end tell
        """

    init() {
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(workspaceDidWake),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
    }

    func runScript() {
        if let scriptObject = NSAppleScript(source: script) {
            var error: NSDictionary?

            scriptObject.executeAndReturnError(&error)
            if let scripterror = error {
                print("error: ", scripterror)
            }
        }
    }

    @objc func workspaceDidWake() {
        sleep(3)
        runScript()
    }
}

if CommandLine.arguments.count == 1 {
    /// kill any running background procs (by name)
    let ktask = Process()
    ktask.executableURL = URL(fileURLWithPath: "/usr/bin/pkill")
    ktask.arguments = ["-f", cmdName, cmdArg]
    try ktask.run()
    ktask.waitUntilExit()

    /// spawn self with background argument
    let ttask = Process()
    ttask.executableURL = URL(fileURLWithPath: cmdPath)
    ttask.arguments = [cmdArg]
    try ttask.run()
    exit(0)
}

/// run with background argument

signal(SIGHUP, SIG_IGN)
signal(SIGINT, SIG_IGN)
signal(SIGQUIT, SIG_IGN)

let app = App()

/// disable App Nap
ProcessInfo.processInfo.beginActivity(
    options: ProcessInfo.ActivityOptions.userInitiatedAllowingIdleSystemSleep,
    reason: "no napping"
)

RunLoop.main.run()
