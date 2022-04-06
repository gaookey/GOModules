//
//  GOEmptyDataViewOptions.swift
//  GOEmptyDataViewOptions
//
//  Created by gaookey on 2021/5/6.
//

import UIKit

@objcMembers public class GOEmptyDataViewOptions: NSObject {
    
    convenience public init(image: String, text: String = "", buttonText: String = "") {
        self.init()
        self.image = image
        self.text = text
        self.buttonText = buttonText
    }
    
    /// EmptyDataView背景色。默认clear
    public var viewColor: UIColor = .clear;
    /// EmptyDataView 间距。默认zero
    public var viewInsets: UIEdgeInsets = .zero
    
    /// 自定义的view。需要设置view的高度，设置自定义view后，其它属性则无效。
    public var customView: UIView?
    
    /// 图片
    public var image: String = ""
    /// 图片大小。默认170*170
    public var imageSize: CGSize = CGSize(width: 170.0, height: 170.0)
    /// 图片距离顶部距离。默认55
    public var imageTop: CGFloat = 55.0
    
    /// 是否隐藏文字。默认false
    public var textHide: Bool = false
    /// 文字
    public var text: String = ""
    /// 文字颜色。默认black
    public var textColor: UIColor = .black
    /// 文字大小。默认15
    public var textFont: UIFont = .systemFont(ofSize: 15)
    /// 文字对齐样式。默认center
    public var textAlignment: NSTextAlignment = .center
    /// 文字顶部距离图片底部距离。默认35
    public var textTop: CGFloat = 35.0
    /// 文字左右间距。默认37
    public var textMargin: CGFloat = 37.0
    
    /// 是否隐藏button。默认false
    public var buttonHide: Bool = false
    /// 按钮顶部距离文字或图片底部距离。默认20
    public var buttonTop: CGFloat = 20.0
    /// 按钮高度。默认 40
    public var buttonHeight: CGFloat = 40.0
    /// 按钮最小宽度。默认 240
    public var buttonMinWidth: CGFloat = 240.0
    /// 按钮最大宽度。默认 UIScreen.main.bounds.width - 30
    public var buttonMaxWidth: CGFloat = UIScreen.main.bounds.width - 30.0
    /// 按钮文字
    public var buttonText: String = ""
    /// 按钮文字颜色。默认white
    public var buttonTextColor: UIColor = .white
    /// 按钮文字大小。默认15
    public var buttonTextFont: UIFont = .systemFont(ofSize: 15)
    /// 按钮背景色。默认black
    public var buttonColor: UIColor = .black
    /// 按钮圆角大小。默认3
    public var buttonRadius: CGFloat = 3.0
    /// 按钮左右间距。默认10
    public var buttonMargin: CGFloat = 10.0
}
