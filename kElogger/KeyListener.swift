import Foundation
import AppKit

class KeyListener {
    
    func start(){
        acquirePrivileges();
        
        
        NSEvent.addGlobalMonitorForEventsMatchingMask(
            .KeyDownMask, handler: {(event: NSEvent) in
                print(String(event.characters!))
//                 notifier.showNotification(String(event.characters!))
        })
        NSEvent.addGlobalMonitorForEventsMatchingMask(
            [.LeftMouseDownMask, .RightMouseDownMask], handler: {(event: NSEvent) in
//                notifier.showNotification("mysz")
                print("mysz")
        })
    }
    
    private func acquirePrivileges() -> Bool {
        let accessEnabled = AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true])
        
        if accessEnabled != true {
            print("You need to enable the keylogger in the System Prefrences")
        }
        return accessEnabled == true;
    }
}