//
//  SettingView.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/28.
//

import UIKit
import MobileCoreServices

class SettingView: UIView, NibLoadable {
    
    var backHandle: (()->Void)? = nil

    @IBAction func newAction() {
        self.removeFromSuperview()
        BrowserUtil.shared.add()
        backHandle?()
        FirebaseUtil.log(event: .tabNew, params: ["lig": "setting"])
    }
    
    @IBAction func shareAction() {
        self.removeFromSuperview()
        var url = "https://itunes.apple.com/cn/app/id"
        if !BrowserUtil.shared.item.isNavigation, let text = BrowserUtil.shared.item.webView.url?.absoluteString {
            url = text
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        AppUtil.shared.window?.rootViewController?.present(vc, animated: true)
        FirebaseUtil.log(event: .shareClick)
    }
    
    @IBAction func copyAction() {
        self.removeFromSuperview()
        if !BrowserUtil.shared.item.isNavigation, let text = BrowserUtil.shared.item.webView.url?.absoluteString {
            UIPasteboard.general.setValue(text, forPasteboardType: kUTTypePlainText as String)
            AppUtil.shared.window?.rootViewController?.alert("Copy successed.")
        } else {
            UIPasteboard.general.setValue("", forPasteboardType: kUTTypePlainText as String)
            AppUtil.shared.window?.rootViewController?.alert("Copy successed.")
        }
        FirebaseUtil.log(event: .copyClick)
    }
    
    @IBAction func rateAction() {
        self.removeFromSuperview()
        if let url = URL(string: "https://itunes.apple.com/cn/app/id") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func termsAction() {
        self.removeFromSuperview()
        let vc = TermsVC.loadStoryBoard()
        AppUtil.shared.window?.rootViewController?.present(vc, animated: true)
    }
    
    @IBAction func privacyAction() {
        self.removeFromSuperview()
        let vc = PrivacyVC.loadStoryBoard()
        AppUtil.shared.window?.rootViewController?.present(vc, animated: true)
    }
    
    @IBAction func dismissAction() {
        self.removeFromSuperview()
    }
    
}
