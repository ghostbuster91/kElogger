import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let baseBackend = Firebase(url: "https://luminous-heat-7872.firebaseio.com")
    private var keyListener : KeyListener?
    
    @IBOutlet weak var githubTokenInput: NSTextField!
    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var emailInput: NSTextField!
    @IBOutlet weak var passwordInput: NSSecureTextField!
    
    @IBAction func helpAction(sender: AnyObject) {
        let urlString = NSURL(string: "https://github.com/settings/tokens")
        
        NSWorkspace.sharedWorkspace().openURL(urlString!)
    }

    @IBAction func loginAction(sender: AnyObject) {
        loginUserWithGithub(githubTokenInput.stringValue)
    }
    
    @IBAction func loginWithEmailAction(sender: AnyObject) {
        loginUserWithPassword(emailInput.stringValue, password: passwordInput.stringValue)
    }
    @IBAction func registerAndLoginAction(sender: AnyObject) {
        registerAndLoginUser(emailInput.stringValue, password: passwordInput.stringValue)
    }
    
    private func loginUserWithGithub(githubToken: String){
        baseBackend.authWithOAuthProvider("github", token:githubToken,
                                  withCompletionBlock: { error, authData in
                                    if error != nil {
                                        // There was an error during log in
                                        print("error during log in")
                                    } else {
                                        let githubUsername = authData.providerData["username"]
                                        self.onLoginSucceed(authData.uid, username: githubUsername as! String)
                                    }
        })
    }
    
    private func registerAndLoginUser(email: String, password: String){
        baseBackend.createUser(email, password: password,
                       withValueCompletionBlock: { error, result in
                        if error != nil {
                            print("error during registering")
                            // There was an error creating the account
                        } else {
                           self.loginUserWithPassword(email, password: password)
                        }
        })
    }
    
    private func loginUserWithPassword(email: String, password: String){
        baseBackend.authUser(email, password: password,
                     withCompletionBlock: { error, authData in
                        if error != nil {
                            print("error during log in")
                            // There was an error logging in to this account
                        } else {
                            self.onLoginSucceed(authData.uid, username: email)
                        }
        })
    }
    
    private func onLoginSucceed(uid: String, username: String){
        self.window.close()
        let userBackend = self.baseBackend.childByAppendingPath("users").childByAppendingPath(uid)
        userBackend.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let shouldCreateUser = snapshot.value is NSNull
            var keystrokes = 0
            var mouseClicks = 0
            var mouseMoves = 0
            var mouseMovesDistance:Double = 0
            if shouldCreateUser {
                print("creating user...")
                let userData = ["full_name": username, "keystrokes": 0, "mouseClicks": 0, "mouseMoves": 0, "mouseMovesDistance": Double(0)]
                userBackend.setValue(userData)
            }else{
                keystrokes = snapshot.value.objectForKey("keystrokes") as! Int!
                mouseClicks = snapshot.value.objectForKey("mouseClicks") as! Int!
                mouseMoves = snapshot.value.objectForKey("mouseMoves") as! Int!
                mouseMovesDistance = snapshot.value.objectForKey("mouseMovesDistance") as! Double!
            }
            self.keyListener = KeyListener(firebase: userBackend, keystrokes: keystrokes,mouseClicks: mouseClicks, mouseMooved:mouseMoves,mouseMoovedDistance: mouseMovesDistance)
            self.keyListener?.start()
        })
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

