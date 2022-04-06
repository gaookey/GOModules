//
//  GOSafeAreaInsets.swift
//  GOSafeAreaInsets
//
//  Created by gaookey on 2021/5/13.
//

import UIKit


public let SafeAreaInsets: UIEdgeInsets = {
    guard #available(iOS 11.0, *), let insets = UIApplication.shared.windows.first?.safeAreaInsets else {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    return insets
}()

public let IsIphoneX: Bool = {
    return SafeAreaInsets.bottom > 0
}()

public let SafeAreaInsetsTop: CGFloat = {
    guard IsIphoneX else { return 20 }
    return SafeAreaInsets.top
}()

public let SafeAreaInsetsBottom: CGFloat = {
    return SafeAreaInsets.bottom
}()

public let SafeAreaInsetsLeft: CGFloat = {
    return SafeAreaInsets.left
}()

public let SafeAreaInsetsRight: CGFloat = {
    return SafeAreaInsets.right
}()


// MARK: - OC 专供
@objcMembers public class SafeAreaInsetsOC: NSObject {
    
    static public func isIphoneX() -> Bool {
        return IsIphoneX
    }
    
    static public func safeAreaInsets() -> UIEdgeInsets {
        return SafeAreaInsets
    }
    
    static public func safeAreaInsetsTop() -> CGFloat {
        return SafeAreaInsetsTop
    }
    
    static public func safeAreaInsetsBottom() -> CGFloat {
        return SafeAreaInsetsBottom
    }
    
    static public func safeAreaInsetsLeft() -> CGFloat {
        return SafeAreaInsetsLeft
    }
    
    static public func safeAreaInsetsRight() -> CGFloat {
        return SafeAreaInsetsRight
    }
}
