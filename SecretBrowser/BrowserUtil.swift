//
//  BrowserUtil.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/28.
//

import Foundation
import WebKit

class BrowserUtil: NSObject {
    
    static let shared = BrowserUtil()
    
    var items: [BrowserItem] = [.navgationItem]
    
    private var webView: WKWebView {
        return item.webView
    }
    
    var item: BrowserItem {
        items.filter {
            $0.isSelect == true
        }.first ?? .navgationItem
    }
    
    var isLoading: Bool {
        webView.isLoading
    }
    
    var count: Int {
        items.count
    }
    
    var url: String? {
        webView.url?.absoluteString
    }
    
    var progrss: Double {
        webView.estimatedProgress
    }
    
    var frame: CGRect = .zero {
        didSet {
            webView.frame = frame
        }
    }
    
    var canGoForword: Bool {
        webView.canGoForward
    }
    
    var canGoBack: Bool {
        webView.canGoBack
    }
    
    var delegate: WKNavigationDelegate? = nil {
        didSet {
            webView.navigationDelegate = delegate
        }
    }
    
    var uiDelegate: WKUIDelegate? = nil {
        didSet {
            webView.uiDelegate = uiDelegate
        }
    }
    
    fileprivate func removeAllWebView(from vc: UIViewController) {
        items.filter({
            !$0.isNavigation
        }).compactMap({
            $0.webView
        }).forEach {
            $0.removeFromSuperview()
            if $0.observationInfo != nil {
                $0.removeObserver(vc, forKeyPath: #keyPath(WKWebView.estimatedProgress))
                $0.removeObserver(vc, forKeyPath: #keyPath(WKWebView.url))
            }
        }
    }
    
}

extension BrowserUtil {
    
    func remove(_ item: BrowserItem) {
        if item.isSelect {
            if let i = items.firstIndex(of: item) {
                items.remove(at: i )
            }
            items.first?.isSelect = true
        } else {
            if let i = items.firstIndex(of: item) {
                items.remove(at: i )
            }
        }
    }
    
    func add(_ item: BrowserItem = .navgationItem) {
        items.forEach {
            $0.isSelect = false
        }
        items.insert(item, at: 0)
    }
    
    func select(_ item: BrowserItem) {
        if !items.contains(item) {
            return
        }
        items.forEach {
            $0.isSelect = false
        }
        item.isSelect = true
    }
    
    func clean(from vc: UIViewController) {
        items.filter {
            !$0.isNavigation
        }.compactMap {
            $0.webView
        }.forEach {
            $0.removeFromSuperview()
        }
        items = [.navgationItem]
    }
    
    func goBack() {
        item.webView.goBack()
    }
    
    func goForword() {
        item.webView.goForward()
    }
    
    func loadUrl(_ url: String, from vc: UIViewController) {
        item.loadUrl(url, from: vc)
    }
    
    func stopLoad() {
        item.stopLoad()
    }
    
    func addedWebView(from view: UIView) {
        if webView.url != nil  {
            view.addSubview(webView)
        }
    }
    
    func removeWebView() {
        webView.removeFromSuperview()
    }
    
}


class BrowserItem: NSObject {
    
    init(webView: WKWebView, isSelect: Bool) {
        self.webView = webView
        self.isSelect = isSelect
    }
    
    var webView: WKWebView
    
    var isNavigation: Bool {
        webView.url == nil
    }
    
    var isSelect: Bool
    
    func loadUrl(_ url: String, from vc: UIViewController) {
        if url.isUrl, let Url = URL(string: url) {
            // 移出 view
            BrowserUtil.shared.removeAllWebView(from: vc)
            // 添加 view
            vc.view.addSubview(webView)
            webView.addObserver(vc, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
            webView.addObserver(vc, forKeyPath: #keyPath(WKWebView.url), context: nil)
            let request = URLRequest(url: Url)
            webView.load(request)
        } else {
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let reqString = "https://www.google.com/search?q=" + urlString
            self.loadUrl(reqString, from: vc)
        }
    }
    
    func stopLoad() {
        webView.stopLoading()
    }
    
    static var navgationItem: BrowserItem {
        let webView = WKWebView()
        webView.backgroundColor = .black
        webView.isOpaque = false
        webView.clipsToBounds = true
        return BrowserItem(webView: webView, isSelect: true)
    }
}
