//
//  HomeVC.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/27.
//

import Foundation
import UIKit
import WebKit
import AppTrackingTransparency

class HomeVC: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tabButton: UIButton!
    @IBOutlet weak var contentVie: UIView!
    
    var startLoadDate: Date? = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavgationBar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization { _ in
            }
        }
    }
    
    func initNavgationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        BrowserUtil.shared.frame = contentVie.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        BrowserUtil.shared.addedWebView(from: view)
        refreshStatus()
        FirebaseUtil.log(event: .homeShow)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        BrowserUtil.shared.removeWebView()
    }
    
}

extension HomeVC {
    
    @IBAction func searchAction() {
        view.endEditing(true)
        if let text = textField.text, text.count > 0 {
            BrowserUtil.shared.loadUrl(text, from: self)
            FirebaseUtil.log(event: .navigaSearch, params: ["lig": text])
        } else {
            alert("Please enter your search content.")
        }
    }
    
    @IBAction func stopSearchAction() {
        view.endEditing(true)
        BrowserUtil.shared.stopLoad()
    }
    
    @IBAction func centerSearchAction(sender: UIButton) {
        view.endEditing(true)
        if HomeItem.allCases.count > sender.tag {
            let text = HomeItem.allCases[sender.tag].url
            BrowserUtil.shared.loadUrl(text, from: self)
            FirebaseUtil.log(event: .navigaClick, params: ["lig": text])
        }
    }
    
    @IBAction func lastAction() {
        BrowserUtil.shared.goBack()
    }
    
    @IBAction func nextAction() {
        BrowserUtil.shared.goForword()
    }
    
    @IBAction func cleanAction() {
        let view = CleanView.loadFromNib()
        view.frame = self.view.bounds
        self.view.addSubview(view)
        view.confirmHandle = {
            let vc = CleanVC.loadStoryBoard()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            vc.backHandle = {
                FirebaseUtil.log(event: .cleanSuccess)
                self.alert("Cleaned Successfully.")
                FirebaseUtil.log(event: .cleanAlert)
            }
        }
        FirebaseUtil.log(event: .cleanClick)
    }
    
    @IBAction func tabAction() {
        let vc = TabVC.loadStoryBoard()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func settingAction() {
        let view = SettingView.loadFromNib()
        view.frame = self.view.bounds
        self.view.addSubview(view)
        view.backHandle = {
            self.refreshStatus()
        }
    }
    
    func refreshStatus() {
        stopButton.isHidden = !BrowserUtil.shared.isLoading
        searchButton.isHidden = BrowserUtil.shared.isLoading
        tabButton.setTitle("\(BrowserUtil.shared.count)", for: .normal)
        tabButton.titleEdgeInsets = UIEdgeInsets(top: 16, left: -20, bottom: 0, right: 0)
        textField.text = BrowserUtil.shared.url
        progressView.progress = Float(BrowserUtil.shared.progrss)
        nextButton.isEnabled = BrowserUtil.shared.canGoForword
        lastButton.isEnabled = BrowserUtil.shared.canGoBack
        BrowserUtil.shared.delegate = self
        BrowserUtil.shared.uiDelegate = self
        if BrowserUtil.shared.progrss == 1.0 || BrowserUtil.shared.progrss == 0.0 {
            progressView.isHidden = true
        } else {
            progressView.isHidden = false
        }
        if BrowserUtil.shared.url == nil  {
            BrowserUtil.shared.removeWebView()
        }
        if BrowserUtil.shared.progrss == 0.1 {
            startLoadDate = Date()
            FirebaseUtil.log(event: .webStart)
        }
        
        if BrowserUtil.shared.progrss == 1.0 {
            let time = Date().timeIntervalSince1970 - (startLoadDate ?? Date()).timeIntervalSince1970
            if startLoadDate != nil {
                FirebaseUtil.log(event: .webSuccess, params: ["lig": "\(ceil(time))"])
            }
            startLoadDate = nil
            stopButton.isHidden = true
            searchButton.isHidden = false
        }
    }
    
}

extension HomeVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {
            self.refreshStatus()
        }
    }
    
}

extension HomeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAction()
        return true
    }
}

extension HomeVC: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return .allow
    }
    
    /// 响应后是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return .allow
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        /// 打开新的窗口
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward

        webView.load(navigationAction.request)
        
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return nil
    }
    
}

enum HomeItem: String, CaseIterable{
    case google, facebook, twitter, youtube, instagram, amazon, gmail, yahoo
    var url: String {
        return "https://www.\(self.rawValue).com"
    }
}
