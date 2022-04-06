//
//  GOTagsListLayout.swift
//  GOTagsListLayout
//
//  Created by gaookey on 2021/5/22.
//

import UIKit

@objc public protocol GOTagsListLayoutDelegate: NSObjectProtocol {
    func tagsListLayout(view: GOTagsListLayout, widthForItemAtIndex: IndexPath, itemHeight: CGFloat) -> CGFloat
    func tagsListLayout(view: GOTagsListLayout, maxHeight: CGFloat)
}

@objcMembers public class GOTagsListLayout: UICollectionViewFlowLayout {
    
    weak open var delegate: GOTagsListLayoutDelegate?
    
    public var itemHeight: CGFloat = 25.0
    public var columnMargin: CGFloat = 10.0
    public var rowMargin: CGFloat = 10.0
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    private var attrsArray = [UICollectionViewLayoutAttributes]()
    private var preAttrs = [String : UICollectionViewLayoutAttributes]()
    private var maxY: CGFloat = 0.0
}

extension GOTagsListLayout {
    
    public override func prepare() {
        super.prepare()
        
        attrsArray.removeAll()
        guard let sections = collectionView?.numberOfSections else { return }
        for section in 0..<sections {
            guard let count = collectionView?.numberOfItems(inSection: section) else { return }
            for i in 0..<count {
                if let attrs = layoutAttributesForItem(at: IndexPath(item: i, section: section)) {
                    attrsArray.append(attrs)
                }
            }
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        guard let collectionViewWidth = collectionView?.frame.width,
              var currentWidth = delegate?.tagsListLayout(view: self, widthForItemAtIndex: indexPath, itemHeight: itemHeight) else { return attrs }
        currentWidth = min(currentWidth, collectionViewWidth - edgeInsets.left - edgeInsets.right)
        
        let key = "preAttrs_key_\(indexPath.section)_\(indexPath.row)"
        var x: CGFloat = edgeInsets.left
        var y: CGFloat = edgeInsets.top
        
        if indexPath.row - 1 >= 0 {
            let preKey = "preAttrs_key_\(indexPath.section)_\(indexPath.row - 1)"
            if let preAttr = preAttrs[preKey] {
                y = preAttr.frame.origin.y
                x = (preAttr.frame.maxX + columnMargin)
            }
        }
        
        if x + currentWidth > collectionViewWidth - edgeInsets.right {
            x = edgeInsets.left
            y += (rowMargin + itemHeight)
        }
        
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.frame = CGRect(x: x, y: y, width: currentWidth, height: itemHeight)
        
        preAttrs[key] = attr
        maxY = attr.frame.maxY
        
        return attr
    }
    
    public override var collectionViewContentSize: CGSize {
        delegate?.tagsListLayout(view: self, maxHeight: maxY + edgeInsets.bottom)
        return CGSize(width: 0.0, height: maxY + edgeInsets.bottom)
    }
}
