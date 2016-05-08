import Foundation
import AppKit

class KeyListener {
    
    private var firebase: Firebase
    private var keystrokes : Int
    private var mouseEvents : Int
    
    init(firebase: Firebase, keystrokes: Int, mouseEvents: Int){
        self.firebase = firebase
        self.keystrokes = keystrokes
        self.mouseEvents = mouseEvents
    }
    
    func start(){
        if(acquirePrivileges()){
            registerKeyboardListener()
            registerMouseClickedListener()
            scheduleDataUploads()
        }
    }
    
    private func registerKeyboardListener(){
        NSEvent.addGlobalMonitorForEventsMatchingMask(
            .KeyDownMask, handler: {(event: NSEvent) in
                self.keystrokes += 1
        })
    }
    
    private func registerMouseClickedListener(){
        NSEvent.addGlobalMonitorForEventsMatchingMask(
            [.LeftMouseDownMask, .RightMouseDownMask], handler: {(event: NSEvent) in
                self.mouseEvents += 1
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
    
    private func scheduleDataUploads() -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(20.0,
                                                      target:   self,
                                                      selector: #selector(uploadData),
                                                      userInfo: nil,
                                                      repeats:  true)
    }
    
    @objc private func uploadData(){
        print("uploading data")
        let newData = ["keystrokes": keystrokes, "mouse": mouseEvents]
        firebase.updateChildValues(newData)
    }
}