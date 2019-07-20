//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit



class WelcomeViewController: UIViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
}
