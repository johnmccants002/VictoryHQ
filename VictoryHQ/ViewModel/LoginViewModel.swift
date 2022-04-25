//
//  LoginViewModel.swift
//  VictoryHQ
//
//  Created by John McCants on 1/8/22.
//

import Foundation
import UIKit

struct LoginViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
