//
//  GOImageListView.swift
//  GOImageListView
//
//  Created by gaookey on 2021/5/17.
//

import UIKit
import SnapKit
import SDWebImage
import SDWebImageWebPCoder

/// 图片列表，单纯显示图片。
@objcMembers public class GOImageListView: UIView {
    
    public var didSelectItemHandler: ((_ index: NSInteger, _ parameter: Any) -> ())?
    
    /// 点击事件需要传出去的参数。个数需要和图片数组相等
    public var parameter = [Any]()
    
    /// 图片数组，最大显示9张图片。
    public var imageUrls = [String]() {
        didSet {
            guard imageUrls.count > 9 else {
                self.updateImages()
                return
            }
            imageUrls.removeSubrange(9...)
            self.updateImages()
        }
    }
    
    /// 占位图
    public var placeholder = UIImage()
    /// 外间距。默认zero
    public var margins: UIEdgeInsets = .zero
    /// 左右图片间距。默认0
    public var xSpacing: CGFloat = 0
    /// 上下图片间距。默认0
    public var ySpacing: CGFloat = 0
    /// 图片显示mode。默认 scaleAspectFit
    public var imageContentMode: ContentMode = .scaleAspectFill
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
        clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GOImageListView {
    
    private func updateImages() {
        subviews.forEach{ $0.removeFromSuperview() }
        
        var rows: CGFloat = 1.0
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        
        if imageUrls.count == 6 { // 3列 ：6
            rows = 3
            width = (bounds.width - 2 * xSpacing - margins.left - margins.right) / 3.0
            height = (bounds.height - margins.top - margins.bottom - ySpacing) * 0.5
        } else if imageUrls.count == 8 { // 4列 ：8
            rows = 4
            width = (bounds.width - 3.0 * xSpacing - margins.left - margins.right) / 4.0
            height = (bounds.height - margins.top - margins.bottom - ySpacing) * 0.5
        } else if imageUrls.count == 9 { // 3列 ：9
            rows = 3
            width = (bounds.width - 2.0 * xSpacing - margins.left - margins.right) / 3.0
            height = (bounds.height - margins.top - margins.bottom - ySpacing * 2) / 3.0
        } else { // 水平单行 1 2 3 4 5 7
            rows = CGFloat(imageUrls.count)
            width = (bounds.width - (CGFloat(imageUrls.count) - 1) * xSpacing - margins.left - margins.right) / CGFloat(imageUrls.count)
            height = bounds.height - margins.top - margins.bottom
        }
        
        for i in 0..<imageUrls.count {
            let x = xSpacing + (CGFloat(i).truncatingRemainder(dividingBy: rows)) * (xSpacing + width)
            let y = margins.top + CGFloat(i / Int(rows)) * (ySpacing + height)
            
            let image = UIImageView()
            image.frame = CGRect(x: x, y: y, width: ceil(width), height: ceil(height))
            image.contentMode = imageContentMode
            image.clipsToBounds = true
            image.sd_setImage(with: URL(string: imageUrls[i]), placeholderImage: placeholder)
            image.tag = 3000 + i
            image.isUserInteractionEnabled = true
            addSubview(image)
            
            image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageAction(_:))))
        }
    }
    
    @objc private func imageAction(_ tap: UITapGestureRecognizer) {
        guard let tag: Int = tap.view?.tag,
              tag - 3000 >= 0,
              tag - 3000 < parameter.count else { return }
        didSelectItemHandler?(tag - 3000, parameter[tag - 3000])
    }
}

