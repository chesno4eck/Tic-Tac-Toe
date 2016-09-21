//
//  ViewController.swift
//  projectX
//
//  Created by Дмитрий Алиев on 20/09/16.
//  Copyright © 2016 Дмитрий Алиев. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var inputTextField: UITextField!
    
    var ref = FIRDatabaseReference()
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let email = "che_d@mail.ru"
        let password = "Asasas"
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            print(error ?? "auth success")
        }
        
        ref = FIRDatabase.database().reference()
        let messages = ref.child("messages")

        messages.observe(FIRDataEventType.value, with: { (snapshot) in
            if let postDict = snapshot.value as? [String : [String: AnyObject]]{
            
                let array = postDict.sorted(by: { (first: (String, [String : AnyObject]), second: (String, [String : AnyObject])) -> Bool in
                    (first.1["timestamp"] as! Double) < (second.1["timestamp"] as! Double)
                })
                
                var str = ""
                for msg in array {
                    str += (msg.1["name"]! as! String) + ": " + (msg.1["text"]! as! String) + "\n"
                }
                self.chatTextView.text = str
            }
        })
    }
    
    func sendMessage(_ text: String) {
        
        let key = ref.child("posts").childByAutoId().key
        let post = ["timestamp": Date().timeIntervalSince1970,
                    "name": nameTextField.text ?? "",
                    "text": text] as [String : Any]
        
        self.ref.child("messages").updateChildValues([key: post])
    }
    
    @IBAction func button(_ sender: AnyObject) {
        sendMessage(inputTextField.text!)
        inputTextField.text = ""
        
    }
    
    @IBAction func clearButton(_ sender: AnyObject) {
        self.ref.child("messages").removeValue { (Error, FIRDatabaseReference) in
            self.chatTextView.text = ""
        }
    }

}

