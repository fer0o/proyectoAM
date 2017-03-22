//
//  DataService.swift
//  ProyectoAM
//
//  Created by Fernando Medellin on 22/03/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import KeychainSwift

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    private var _keyChain = KeychainSwift()
    private var _refDatabase = DB_BASE
    
    
    var keyChain: KeychainSwift {
        get {
            return _keyChain
        }
        set{
            _keyChain = newValue
        }
    }
}
