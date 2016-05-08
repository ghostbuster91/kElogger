import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var githubTokenInput: NSTextField!
    @IBOutlet weak var window: NSWindow!
    
    private var backendRef:Firebase?
    private var keystrokes: Int = 0
    private var mouseEvents: Int = 0

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
            let usernameFromApi = snapshot.value.objectForKey("full_name") as? String
            if usernameFromApi == nil {
                print("username is nil")
                let userData = ["full_name": githubUsername, "keystrokes": "0", "mouse" : "0"]
                firebase.setValue(userData)
            }else{
                self.keystrokes = Int(snapshot.value.objectForKey("keystrokes") as! String)!
                self.mouseEvents = Int(snapshot.value.objectForKey("mouse") as! String)!
            }
            self.backendRef = firebase
            self.initListeners()
        })
    }
    
    private func initListeners(){
        KeyListener().start()
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

