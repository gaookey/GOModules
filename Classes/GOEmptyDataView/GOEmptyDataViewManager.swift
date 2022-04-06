//
//  GOEmptyDataViewManager.swift
//  GOEmptyDataViewManager
//
//  Created by gaookey on 2021/5/6.
//

import UIKit
import SnapKit

class GOEmptyDataViewManager {
    
    static let shared = GOEmptyDataViewManager()
    
    private init() { }

    private var emptyDataViews = [String : GOEmptyDataView]()
    
    func showView(_ key: String, _ inView: UIView, _ options: GOEmptyDataViewOptions, _ buttonHandler: (() -> ())?) {
        hiddenView(key)
        
        let view = GOEmptyDataView(options: options)
        view.viewButtonClickHandler = buttonHandler
        inView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(options.viewInsets)
        }
        
        emptyDataViews[key] = view
    }
    
    func hiddenView(_ key: String) {
        guard let view = emptyDataViews[key] else { return }
        view.isHidden = true
        view.removeFromSuperview()
        emptyDataViews.removeValue(forKey: key)
    }
}
 
