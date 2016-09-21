//
//  Authorization.swift
//  projectX
//
//  Created by Дмитрий Алиев on 21/09/16.
//  Copyright © 2016 Дмитрий Алиев. All rights reserved.
//

import Foundation
import Firebase

class Authorization {
    

    class func auth(){
        let email = "testuser@gm.ru"
        let password = "123456"

        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            print(error ?? "auth success")
        }
    }
    
}
