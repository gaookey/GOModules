//
//  UIView+GOEmptyDataView.swift
//  UIView+GOEmptyDataView
//
//  Created by gaookey on 2021/5/6.
//

import UIKit

extension UIView {
    
    @objc public func showEmptyDataView(key: String, isShow: Bool, options: GOEmptyDataViewOptions = GOEmptyDataViewOptions(), buttonHandler: (() -> ())? = nil) {
        if isShow {
            GOEmptyDataViewManager.shared.showView(key, self, options, buttonHandler)
        } else {
            GOEmptyDataViewManager.shared.hiddenView(key)
        }
    }
    
    @objc public func hideEmptyDataView(key: String) {
        GOEmptyDataViewManager.shared.hiddenView(key)
    }
}

