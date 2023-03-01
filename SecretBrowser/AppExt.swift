//
//  AppExt.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/27.
//

import Foundation
import UIKit

class AssetorKey {
    static var cornerRadiusKey: String?
    static var borderColorKey: String?
    static var borderWidthKey: String?
    static var placeholderColorKey: String?
}

extension UIView {
    
    @IBInspectable var cornerRadius: Double {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
            objc_setAssociatedObject(self, &AssetorKey.cornerRadiusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &AssetorKey.cornerRadiusKey) as? Double) ?? 0.0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
            objc_setAssociatedObject(self, &AssetorKey.borderColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &AssetorKey.borderColorKey) as? UIColor) ?? .clear
        }
    }
    
    @IBInspectable var borderWidth: Double {
        set {
            self.layer.borderWidth = newValue
            objc_setAssociatedObject(self, &AssetorKey.borderWidthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &AssetorKey.borderWidthKey) as? Double) ?? 0.0
        }
    }
    
}

extension UITextField {
    
    @IBInspectable var placeholderColor: UIColor {
        set {
            if let placeholder = placeholder {
                let attribute = NSMutableAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: newValue])
                self.attributedPlaceholder = attribute
            }
            objc_setAssociatedObject(self, &AssetorKey.placeholderColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &AssetorKey.placeholderColorKey) as? UIColor) ?? UIColor.clear
        }
    }
    
}

protocol NibLoadable {
    
}

extension NibLoadable where Self: UIView {
    static func loadFromNib(_ nibname: String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}

extension UIViewController {
    class func loadStoryBoard() -> Self {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        return sb.instantiateViewController(withIdentifier: "\(self)") as? Self ?? Self()
    }
    
    func alert(_ message: String) {
        let vc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        self.present(vc, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            vc.dismiss(animated: true)
        }
    }
}

extension String {
    var isUrl: Bool {
        let url = "[a-zA-z]+://.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
    }
}

extension UserDefaults {
    func setModel<T: Encodable> (_ object: T?, forKey key: String) {
        let encoder =  JSONEncoder()
        guard let object = object else {
            self.removeObject(forKey: key)
            return
        }
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        
        self.setValue(encoded, forKey: key)
    }
    
    func model<T: Decodable> (_ type: T.Type, forKey key: String) -> T? {
        guard let data = self.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            print("Could'n find key")
            return nil
        }
        
        return object
    }
}
