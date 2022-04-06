//
//  GOWaterflowLayout.swift
//  GOWaterflowLayout
//
//  Created by gaookey on 2021/5/22.
//


import UIKit

@objc public protocol GOWaterflowLayoutDelegate: NSObjectProtocol {
    func waterflowLayout(view: GOWaterflowLayout, heightForItemAtIndex: IndexPath, itemWidth: CGFloat) -> CGFloat
}

@objcMembers public class GOWaterflowLayout: UICollectionViewFlowLayout {
    
    weak open var delegate: GOWaterflowLayoutDelegate?
    
    public var columnCount: NSInteger = 2
    public var columnMargin: CGFloat = 10.0
    public var rowMargin: CGFloat = 10.0
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    private var attrsArray = [UICollectionViewLayoutAttributes]()
    private var columnHeights = [CGFloat]()
    private var contentHeight: CGFloat = 0.0
}

extension GOWaterflowLayout {
    
    public override func prepare() {
        super.prepare()
        
        contentHeight = 0
        columnHeights.removeAll()
        
        for _ in 0..<columnCount {
            columnHeights.append(edgeInsets.top)
        }
        
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
        guard let collectionViewWidth = collectionView?.frame.width else { return attrs }
        
        let width = (collectionViewWidth - edgeInsets.left - edgeInsets.right - (CGFloat(columnCount) - 1) * columnMargin) / CGFloat(columnCount)
        guard let height = delegate?.waterflowLayout(view: self, heightForItemAtIndex: indexPath, itemWidth: width) else { return attrs }
        
        var destColumn: NSInteger = 0
        var minColumnHeight: CGFloat = columnHeights[0]
        
        for i in 0..<columnCount {
            let columnHeight = columnHeights[i]
            if minColumnHeight > columnHeight {
                minColumnHeight = columnHeight
                destColumn = i
            }
        }
        
        let x = edgeInsets.left + CGFloat(destColumn) * (width + columnMargin)
        var y = minColumnHeight
        
        if y != edgeInsets.top {
            y += rowMargin
        }
        
        attrs.frame = CGRect(x: x, y: y, width: width, height: height)
        
        columnHeights[destColumn] = attrs.frame.maxY
        
        let columnHeight = columnHeights[destColumn]
        if contentHeight < columnHeight {
            contentHeight = columnHeight
        }
        
        return attrs
    }
    
    public override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: contentHeight + edgeInsets.bottom)
    }
}
