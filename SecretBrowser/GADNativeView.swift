//
//  GADNativeView.swift
//  SecretBrowser
//
//  Created by yangjian on 2023/3/1.
//

import Foundation

import Foundation
import GoogleMobileAds

class GADNativeView: GADNativeAdView {
    
    @IBOutlet var placeholder: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var install: UIButton!
    @IBOutlet weak var adTag: UIImageView!

    override var nativeAd: GADNativeAd? {
        didSet {
            if let nativeAd = nativeAd {
                
                self.icon.isHidden = false
                self.title.isHidden = false
                self.subTitle.isHidden = false
                self.install.isHidden = false
                self.adTag.isHidden = false
                self.placeholder.isHidden = true
                
                if let image = nativeAd.images?.first?.image {
                    self.icon.image =  image
                }
                self.title.text = nativeAd.headline
                self.subTitle.text = nativeAd.body
                self.install.setTitle(nativeAd.callToAction, for: .normal)
                self.install.setTitleColor(.white, for: .normal)
            } else {
                self.icon.isHidden = true
                self.title.isHidden = true
                self.subTitle.isHidden = true
                self.install.isHidden = true
                self.adTag.isHidden = true
                self.placeholder.isHidden = false
            }
            
            callToActionView = install
            headlineView = title
            bodyView = subTitle
            advertiserView = adTag
            iconView = icon
        }
    }
    
}
