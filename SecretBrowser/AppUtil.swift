//
//  AppUtil.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/27.
//

import Foundation
import UIKit

class AppUtil {
    static let shared = AppUtil()
    
    var delegate: SceneDelegate? = nil
    var appEnterbackground: Bool = false
    var window: UIWindow? {
        delegate?.window
    }
}

