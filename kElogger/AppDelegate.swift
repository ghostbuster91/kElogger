import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var githubTokenInput: NSTextField!
    @IBOutlet weak var window: NSWindow!
    
    private var backendRef:Firebase?

    @IBAction func helpAction(sender: AnyObject) {
        let urlString = NSURL(string: "https://github.com/settings/tokens")
        
        NSWorkspace.sharedWorkspace().openURL(urlString!)
    }

    @IBAction func loginAction(sender: AnyObject) {
        loginUser(githubTokenInput.stringValue)
    }
    
    private func loginUser(githubToken: String){
        let ref = Firebase(url: "https://luminous-heat-7872.firebaseio.com")
        ref.authWithOAuthProvider("github", token:githubToken,
                                  withCompletionBlock: { error, authData in
                                    if error != nil {
                                        // There was an error during log in
                                        print("error during log in")
                                    } else {
                                        self.window.close()
                                        let githubUsername = authData.providerData["username"]
                                        let userStorage = ref.childByAppendingPath("users").childByAppendingPath(authData.uid)
                                        self.onLoginSucced(userStorage, githubUsername: githubUsername as! String)
                                    }
        })
    }
    
    private func onLoginSucced(firebase: Firebase, githubUsername: String){
        firebase.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let shouldCreateUser = (snapshot.value.objectForKey("full_name") as? String) == nil
            var keystrokes = 0
            var mouseClicks = 0
            var mouseMoves = 0
            var mouseMovesDistance:Double = 0
            if shouldCreateUser {
                print("creating user...")
                let userData = ["full_name": githubUsername, "keystrokes": 0, "mouseClicks": 0, "mouseMoves": 0, "mouseMovesDistance": Double(0)]
                firebase.setValue(userData)
            }else{
                keystrokes = snapshot.value.objectForKey("keystrokes") as! Int!
                mouseClicks = snapshot.value.objectForKey("mouseClicks") as! Int!
                mouseMoves = snapshot.value.objectForKey("mouseMoves") as! Int!
                mouseMovesDistance = snapshot.value.objectForKey("mouseMovesDistance") as! Double!
            }
            KeyListener(firebase: firebase, keystrokes: keystrokes,mouseClicks: mouseClicks, mouseMooved:mouseMoves,mouseMoovedDistance: mouseMovesDistance).start()
        })
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

