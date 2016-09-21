//
//  MessageSender.swift
//  projectX
//
//  Created by Дмитрий Алиев on 21/09/16.
//  Copyright © 2016 Дмитрий Алиев. All rights reserved.
//

import Foundation

class MessageSender {
    
    
    class func sendMessage(_ text: String, name: String?) {
        
        let key = DataBaseRefs.ref.child("posts").childByAutoId().key
        let post = ["timestamp": Date().timeIntervalSince1970,
                    "name": name ?? "",
                    "text": text] as [String : Any]
        
        DataBaseRefs.ref.child("messages").updateChildValues([key: post])
    }

    
}
