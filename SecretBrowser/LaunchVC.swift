//
//  ViewController.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/27.
//

import UIKit

class LaunchVC: UIViewController {
    
    var duration = 2.5 / 0.6
    
    var showAD = false
    
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
        duration = 2.5 / 0.6
        showAD = false
        progressTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(launchProgress), userInfo: nil, repeats: true)
        
        perform(#selector(beginShowAD), with: self, afterDelay: 2.5)
        
        GADUtil.share.load(.interstitial)
        GADUtil.share.load(.native)
    }
    
    @objc func launchProgress() {
        progress += Float(0.01 / duration)
        if progress >= 1.0 {
            progressTimer?.invalidate()
            progressTimer = nil
            GADUtil.share.show(.interstitial) { _ in
                AppUtil.shared.delegate?.launched()
                GADUtil.share.load(.interstitial)
                GADUtil.share.load(.native)
            }
        }
        
        if showAD, GADUtil.share.isLoaded(.interstitial) {
            duration = 0.2
        }
    }
    
    @objc func beginShowAD() {
        showAD = true
        duration = 16.0
    }
}

