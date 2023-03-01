//
//  CleanView.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/28.
//

import UIKit

class CleanView: UIView, NibLoadable {
    
    var confirmHandle: (()->Void)? = nil
    @IBAction func confirmAction() {
        self.removeFromSuperview()
        confirmHandle?()
    }
    
    @IBAction func dismissAction() {
        self.removeFromSuperview()
    }

}
