//
//  GOCategoryNavigationFlowLayout.swift
//  GOCategoryNavigationView
//
//  Created by 高文立 on 2021/7/31.
//

import UIKit

protocol GOCategoryNavigationFlowLayoutDelegate: NSObjectProtocol {
    func contentSize(view: GOCategoryNavigationFlowLayout) -> CGSize
}

class GOCategoryNavigationFlowLayout: UICollectionViewFlowLayout {
    
    weak open var delegate: GOCategoryNavigationFlowLayoutDelegate?
    
    public var columnCount: NSInteger = 2
    public var columnMargin: CGFloat = 10.0
    public var rowMargin: CGFloat = 10.0
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
    
    private var attrsArray = [UICollectionViewLayoutAttributes]()
}

extension GOCategoryNavigationFlowLayout {
    
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
        guard let collectionViewWidth = collectionView?.frame.width else { return attrs }
        
        var x: CGFloat = edgeInsets.left + (CGFloat(indexPath.row).truncatingRemainder(dividingBy: CGFloat(columnCount))) * (columnMargin + itemSize.width)
        var y: CGFloat = edgeInsets.top + CGFloat(indexPath.row / columnCount) * (rowMargin + itemSize.height)
        x += CGFloat(indexPath.section) * collectionViewWidth
        
        attrs.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
        
        return attrs
    }
    
    public override var collectionViewContentSize: CGSize {
        guard let size = delegate?.contentSize(view: self) else { return .zero }
        return size
    }
}
