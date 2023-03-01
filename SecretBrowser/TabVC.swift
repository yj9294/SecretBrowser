//
//  TabVC.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/28.
//

import UIKit

class TabVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func newAction() {
        BrowserUtil.shared.add()
        self.dismiss(animated: true)
        FirebaseUtil.log(event: .tabNew, params: ["lig": "tab"])
    }
    
    @IBAction func backAction() {
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseUtil.log(event: .tabShow)
    }
}

extension TabVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        BrowserUtil.shared.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath)
        if let cell = cell as? TabCell {
            cell.item = BrowserUtil.shared.items[indexPath.row]
            cell.deleteHandle = { [weak cell] in
                if let item = cell?.item {
                    BrowserUtil.shared.remove(item)
                }
                collectionView.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = BrowserUtil.shared.items[indexPath.row]
        BrowserUtil.shared.select(item)
        self.dismiss(animated: true)
    }
    
}

class  TabCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIButton!
    var deleteHandle: (()->Void)? = nil
    
    var item: BrowserItem? = nil {
        didSet {
            title.text = item?.webView.url?.absoluteString
            icon.isHidden = BrowserUtil.shared.count == 1
            if item == BrowserUtil.shared.item {
                self.borderWidth = 2
            } else {
                self.borderWidth = 0
            }
        }
    }
    
    @IBAction func deleteAction() {
        deleteHandle?()
    }
    
}
