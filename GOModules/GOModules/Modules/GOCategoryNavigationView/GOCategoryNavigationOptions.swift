//
//  GOCategoryNavigationOptions.swift
//  GOCategoryNavigationView
//
//  Created by 高文立 on 2021/7/29.
//

import UIKit

@objc public enum GOCategoryNavigationType: Int {
    case image
    case text
}

@objcMembers public class GOCategoryNavigationOptions: NSObject {
    
    /// text or image
    public var type: GOCategoryNavigationType = .image
    /// 列数。
    public var columnCount: NSInteger = 2
    /// 间距
    public var columnMargin: CGFloat = 10.0
    /// 间距
    public var rowMargin: CGFloat = 10.0
    /// 左右边距
    public var insetsLeftRight: CGFloat = 15.0
    /// 上边距
    public var insetsTop: CGFloat = 10.0
    /// 下边距
    public var insetsBottom: CGFloat = 10.0
    /// item的大小
    public var itemSize: CGSize {
        get {
            let w = (UIScreen.main.bounds.width - insetsLeftRight * 2 - (CGFloat(columnCount) - 1) * columnMargin) / CGFloat(columnCount)
            let h = itemScale * w
            return CGSize(width: w, height: h)
        }
    }
    
    /// 背景图片
    public var contentImage: String = ""
    /// 背景颜色
    public var contentColor: UIColor = .clear
    /// item颜色
    public var itemColor: UIColor = .clear
    /// item占位图片。image模式下
    public var placeholder: String = ""
    /// 是否隐藏分页指示器
    public var isHiddenPageControl: Bool = false
    /// item高宽比 
    public var itemScale: CGFloat = 45.0 / 168.0
    
    /// item圆角大小
    public var radius: CGFloat = 0.0
    /// item边框颜色
    public var borderColor: UIColor = .clear
    /// item边框宽度
    public var borderWidth: CGFloat = 0.0
    
    
    // MARK: - text
    public var numberOfLines: Int = 0
    public var textColor: UIColor = .black
    public var font: UIFont = .systemFont(ofSize: 15)
    public var textAlignment: NSTextAlignment = .center
}
