import Foundation
import AppKit

class KeyListener {
    
    private var firebase: Firebase
    private var keystrokes : Int
    private var mouseClicks : Int
    private var mouseMoves : Int
    private var mouseMoovedDistance : Double
    
    init(firebase: Firebase, keystrokes: Int, mouseClicks : Int,mouseMooved : Int, mouseMoovedDistance : Double){
        self.firebase = firebase
        self.keystrokes = keystrokes
        self.mouseClicks = mouseClicks
        self.mouseMoves = mouseMooved
        self.mouseMoovedDistance = mouseMoovedDistance
    }
    
    func start(){
        if(acquirePrivileges()){
            registerKeyboardListener()
            registerMouseClickedListener()
            registerMouseMovedListner()
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
            [.LeftMouseDownMask, .RightMouseDownMask, .OtherMouseDownMask], handler: {(event: NSEvent) in
                self.mouseClicks += 1
        })
    }
    
    private func registerMouseMovedListner(){
        NSEvent.addGlobalMonitorForEventsMatchingMask(
            [.MouseMovedMask], handler: {(event: NSEvent) in
                self.mouseMoves += 1
                self.mouseMoovedDistance += Double(sqrt(pow(Double(event.deltaX), 2) + pow(Double(event.deltaY),2)))
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
        let newData = ["keystrokes": keystrokes, "mouseClicks": mouseClicks, "mouseMoves": mouseMoves, "mouseMovesDistance": mouseMoovedDistance]
        firebase.updateChildValues(newData as [NSObject : AnyObject])
    }
}