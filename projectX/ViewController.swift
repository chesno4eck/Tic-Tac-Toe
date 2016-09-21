//
//  ViewController.swift
//  projectX
//
//  Created by Дмитрий Алиев on 20/09/16.
//  Copyright © 2016 Дмитрий Алиев. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var inputTextField: UITextField!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataBaseRefs.ref = FIRDatabase.database().reference()
        let messages = DataBaseRefs.ref.child("messages")

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
    
    
    @IBAction func button(_ sender: AnyObject) {
        MessageSender.sendMessage(inputTextField.text!, name: nameTextField.text)
        
    }
    
    @IBAction func clearButton(_ sender: AnyObject) {
        DataBaseRefs.ref.child("messages").removeValue { (Error, FIRDatabaseReference) in
            self.chatTextView.text = ""
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        MessageSender.sendMessage(inputTextField.text!, name: nameTextField.text)
        return true
    }

}

@IBDesignable
class MyCustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
