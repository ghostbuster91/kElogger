import Foundation
import AppKit

class KeyListener {
    
    private var firebase: Firebase
    private var keystrokes : Int
    private var mouseClicks : Int
    private var mouseMoves : Int
    private var mouseMoovedDistance : Double
    
    private var keyboardMonitor : AnyObject?
    private var mouseMonitor: AnyObject?
    private var mouseMoveMonitor: AnyObject?
    private var timer: NSTimer?
    
    init(firebase: Firebase, keystrokes: Int, mouseClicks : Int,mouseMooved : Int, mouseMoovedDistance : Double){
        self.firebase = firebase
        self.keystrokes = keystrokes
        self.mouseClicks = mouseClicks
        self.mouseMoves = mouseMooved
        self.mouseMoovedDistance = mouseMoovedDistance
    }
    
    deinit{
        if (keyboardMonitor != nil) { NSEvent.removeMonitor(keyboardMonitor!)}
        if (mouseMonitor != nil) { NSEvent.removeMonitor(mouseMonitor!) }
        if (mouseMoveMonitor != nil ) { NSEvent.removeMonitor(mouseMoveMonitor!) }
        if (timer != nil) {timer!.invalidate()}
    }
    
    func start(){
        if(acquirePrivileges()){
            registerKeyboardListener()
            registerMouseClickedListener()
            registerMouseMovedListner()
            timer = scheduleDataUploads()
        }
    }
    
    private func registerKeyboardListener(){
        keyboardMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask(
            .KeyDownMask, handler: { [weak self] (event: NSEvent) in
                self?.keystrokes += 1
        })
    }
    
    private func registerMouseClickedListener(){
        mouseMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask(
            [.LeftMouseDownMask, .RightMouseDownMask, .OtherMouseDownMask], handler: { [weak self] (event: NSEvent) in
                self?.mouseClicks += 1
        })
    }
    
    private func registerMouseMovedListner(){
        mouseMoveMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask(
            [.MouseMovedMask], handler: {[weak self] (event: NSEvent) in
                self?.mouseMoves += 1
                self?.mouseMoovedDistance += Double(sqrt(pow(Double(event.deltaX), 2) + pow(Double(event.deltaY),2)))
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
        weak var welf = self
        return NSTimer.scheduledTimerWithTimeInterval(20.0,
                                                      target:   welf!,
                                                      selector: #selector(uploadData),
                                                      userInfo: nil,
                                                      repeats:  true)
    }
    
    @objc private func uploadData(){
        print("uploading data")
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        let newData = ["keystrokes": keystrokes,
                       "mouseClicks": mouseClicks,
                       "mouseMoves": mouseMoves,
                       "mouseMovesDistance": mouseMoovedDistance,
                       "lastUpdate": timestamp]
        firebase.updateChildValues(newData as [NSObject : AnyObject])
    }
}