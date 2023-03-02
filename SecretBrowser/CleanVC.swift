//
//  CleanVC.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/28.
//

import UIKit

class CleanVC: UIViewController {
    
    @IBOutlet weak var animationView: UIImageView!
    
    var backHandle: (()->Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        starAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            BrowserUtil.shared.clean(from: self)
            self.dismiss(animated: true) { [weak self] in
                self?.backHandle?()
            }
        }
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
}
