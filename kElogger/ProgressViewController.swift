//
//  Created by Mateusz Szklarek on 12/05/16.
//  Copyright © 2016 ghost. All rights reserved.
//

import Cocoa

class ProgressViewController: NSViewController {
    
    @IBOutlet weak var progressBarIndicator: NSProgressIndicator!
    @IBOutlet weak var infoLabel: NSTextField!
    var closeAction: (()->())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.stringValue = "Erasing files from /Users/\(NSUserName())"
    }
    
    override var nibName: String {
        return "ProgressViewController"
    }
    
    func start() {
        increaseBy30()
    }
    
    func increaseBy30() {
        progressBarIndicator.animateToDoubleValue(progressBarIndicator.doubleValue + 30)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [weak self] in
            self?.start()
            self?.dismissWhenIsCompleted()
        }
    }
    
    func dismissWhenIsCompleted() {
        if progressBarIndicator.doubleValue == progressBarIndicator.maxValue {
            dismissController(nil)
            self.closeAction!()
        }
    }

}
