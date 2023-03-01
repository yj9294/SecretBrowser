//
//  CleanVC.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/28.
//

import UIKit

class CleanVC: UIViewController {
    
    var duration = 2.5 / 0.6
    
    var showAD = false
    
    var progress:Float = 0.0
    
    var progressTimer: Timer?
    
    @IBOutlet weak var animationView: UIImageView!
    
    var backHandle: (()->Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        starAnimation()
        startLoadingAD()
    }
    
    func startLoadingAD() {
        if progressTimer != nil {
            progressTimer?.invalidate()
            progressTimer = nil
        }
        progress = 0.0
        duration = 2.5 / 0.6
        progressTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(loadingAD), userInfo: nil, repeats: true)
        
        perform(#selector(beginShowAD), with: self, afterDelay: 2.5)
        
        GADUtil.share.load(.interstitial)
        GADUtil.share.load(.native)
    }
    
    @objc func loadingAD() {
        progress += Float(0.01 / duration)
        if progress >= 1.0 {
            progressTimer?.invalidate()
            progressTimer = nil
            if AppUtil.shared.delegate?.isLaunch == true{
                return
            }
            if AppUtil.shared.appEnterbackground  {
                return
            }
            GADUtil.share.show(.interstitial, from: self) { _ in
                self.perform(#selector(self.backAction), with: nil, afterDelay: 0.2)
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

    
    func starAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 设置动画属性
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 1
        anim.isRemovedOnCompletion = false
        // 将动画添加到图层上
        animationView.layer.add(anim, forKey: "rot")
    }
    
    func stopAnimation() {
        animationView.layer.removeAllAnimations()
    }
    
    @objc func backAction() {
        self.dismiss(animated: true) { [weak self] in
            self?.backHandle?()
        }
    }
    
}
