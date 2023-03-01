//
//  ViewController.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/27.
//

import UIKit

class LaunchVC: UIViewController {
    
    let duration = 2.5
    
    var progress:Float = 0.0 {
        didSet {
            progressView.progress = progress
        }
    }
    
    var progressTimer: Timer?
    
    @IBOutlet weak var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        launching()
        
        FirebaseUtil.log(property: .local)
        FirebaseUtil.log(event: .open)
        FirebaseUtil.log(event: .openCold)
    }

}

extension LaunchVC {
    
    func launching() {
        if progressTimer != nil {
            progressTimer?.invalidate()
            progressTimer = nil
        }
        progress = 0.0
        progressTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(launchProgress), userInfo: nil, repeats: true)
    }
    
    @objc func launchProgress() {
        progress += Float(0.01 / duration)
        if progress >= 1.0 {
            progressTimer?.invalidate()
            progressTimer = nil
            AppUtil.shared.delegate?.launched()
        }
    }
    
}

