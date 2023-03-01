//
//  FirebaseUtil.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/28.
//

import Foundation
import Firebase

class FirebaseUtil: NSObject {
    static func log(event: AnaEvent, params: [String: Any]? = nil) {
        
        if event.first {
            if UserDefaults.standard.bool(forKey: event.rawValue) == true {
                return
            } else {
                UserDefaults.standard.set(true, forKey: event.rawValue)
            }
        }
        
        #if DEBUG
        #else
        Analytics.logEvent(event.rawValue, parameters: params)
        #endif
        
        NSLog("[Event] \(event.rawValue) \(params ?? [:])")
    }
    
    static func log(property: AnaProperty, value: String? = nil) {
        
        var value = value
        
        if property.first {
            if UserDefaults.standard.string(forKey: property.rawValue) != nil {
                value = UserDefaults.standard.string(forKey: property.rawValue)!
            } else {
                UserDefaults.standard.set(Locale.current.regionCode ?? "us", forKey: property.rawValue)
            }
        }
#if DEBUG
#else
        Analytics.setUserProperty(value, forName: property.rawValue)
#endif
        NSLog("[Property] \(property.rawValue) \(value ?? "")")
    }
}

enum AnaProperty: String {
    /// 設備
    case local = "ay_rr"
    
    var first: Bool {
        switch self {
        case .local:
            return true
        }
    }
}

enum AnaEvent: String {
    
    var first: Bool {
        switch self {
        case .open:
            return true
        default:
            return false
        }
    }
    
    case open = "lun_rr"
    case openCold = "er_rr"
    case openHot = "ew_rr"
    case homeShow = "eq_rr"
    case navigaClick = "ws_rr"
    case navigaSearch = "wa_rr"
    case cleanClick = "bu_rr"
    case cleanSuccess = "xian_rr"
    case cleanAlert = "dd_rr"
    case tabShow = "dl_rr"
    case tabNew = "acv_rr"
    case shareClick = "xmo_rr"
    case copyClick = "qws_rr"
    case webStart = "zxc_rr"
    case webSuccess = "bnm_rr"
}
