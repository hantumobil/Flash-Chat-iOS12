//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    // Declare instance variables here
    var messages : [Message] = [Message]()

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self

        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
       
        configureTableView()
        retrieveMessage()
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
                
        cell.messageBody.text = messages[indexPath.row].messageBody
        cell.senderUsername.text = messages[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    //TODO: Declare configureTableView here:
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.25) {
            self.heightConstraint.constant = 361
            self.view.layoutIfNeeded()
        }
        
    }
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.25) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }

    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        
        //TODO: Send the message to Firebase and save it in our database
        
        // end textField editing // to bring textfield to the bottom again
        messageTextfield.endEditing(true)
        
        // disable the send btn
        sendButton.isEnabled = false
        
        // disable the textField
        messageTextfield.isEnabled = false
        
        // set reference to db
        let messageDb = Database.database().reference().child("messages")
        
        // create new record and
        let messageDictionary = [
            "Sender": Auth.auth().currentUser?.email,
            "MessageBody": messageTextfield.text
        ]
        
        messageDb.childByAutoId().setValue(messageDictionary) {
            // handle callback
            (error, reference) in
            
            if (error != nil) {
                print(error!)
            } else {
                print("message saved successfully")
                self.sendButton.isEnabled = false
                self.messageTextfield.isEnabled = false
                self.messageTextfield.text = ""
            }
        }
        
        
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    func retrieveMessage() {
        let messageDB = Database.database().reference().child("messages")
        messageDB.observe(.childAdded, with: {
            snapshot in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let newMessage = Message()
            
            newMessage.messageBody = snapshotValue["MessageBody"]!
            newMessage.sender = snapshotValue["Sender"]!
            
            self.messages.append(newMessage)
            self.configureTableView()
            self.messageTableView.reloadData()
        })
    }
    
    

    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("error, there is a problem signing out")
        }
    }

}
