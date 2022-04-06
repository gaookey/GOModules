//
//  GOHorizontalColorsView.swift
//  GOHorizontalColorsView
//
//  Created by gaookey on 2021/6/3.
//

import UIKit
import SnapKit
import SDWebImage
import SDWebImageWebPCoder
import YYCategories

@objcMembers public class GOHorizontalColorsView: UIView {
    
    public var didSelectItemHandler: ((_ index: Int) -> ())?
    public var didSelectMoreHandler: (() -> ())?
    
    /// 图片 或 颜色值
    public var imageUrls = [String]() {
        didSet {
            moreButton.isHidden = imageUrls.count <= minNumberHiddenMore
            colorList.reloadData()
        }
    }
    public var placeholderImage: String = ""
    public var selectImage: String = ""
    
    public var currentSelectIndex: Int = -1 {
        didSet {
            colorList.reloadData()
        }
    }
    public var minNumberHiddenMore: Int = 0
    public var xSpacing: CGFloat = 12.0
    
    public var moreButtonImage = UIImage() {
        willSet {
            moreButton.setImage(newValue.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private lazy var moreButton: UIButton = {
        let view = UIButton(type: .custom)
        view.backgroundColor = .white
        view.addTarget(self, action: #selector(moreButtonClick(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var colorList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.register(HorizontalColorsViewCell.self, forCellWithReuseIdentifier: HorizontalColorsViewCell.ID)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        addSubview(colorList)
        addSubview(moreButton)
        
        colorList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        moreButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(moreButton.snp.height)
        }
    }
}

extension GOHorizontalColorsView {
    @objc private func moreButtonClick(_ button: UIButton) {
        didSelectMoreHandler?()
        
        guard let row = colorList.indexPathsForVisibleItems.sorted(by: { obj1, obj2 in
            return obj1 < obj2
        }).last?.row else { return }
        colorList.scrollToItem(at: IndexPath(row: row, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
    }
}

extension GOHorizontalColorsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalColorsViewCell.ID, for: indexPath) as! HorizontalColorsViewCell
        cell.data = (imageUrls[indexPath.row], placeholderImage, indexPath.row == currentSelectIndex, selectImage)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.height, height: bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return xSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectIndex = indexPath.row
        colorList.reloadData()
        didSelectItemHandler?(indexPath.row)
        guard currentSelectIndex > 0 else { return }
        colorList.scrollToItem(at: IndexPath(row: currentSelectIndex - 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
        scrollViewDidScroll(colorList)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        let totalWidth = CGFloat(imageUrls.count) * scrollView.bounds.height + (CGFloat(imageUrls.count) - 1) * xSpacing
        
        /// 滑到最后隐藏更多按钮
        moreButton.isHidden = offsetX + width >= totalWidth
    }
}


class HorizontalColorsViewCell: UICollectionViewCell {
    
    static let ID = "HorizontalColorsViewCellID"
    
    public var data: (image: String, placeholderImage: String, isSelect: Bool, selectImage: String) = ("", "", false, "") {
        willSet {
            if newValue.image.hasPrefix("#"){// 颜色值
                if let color = UIColor(hexString: newValue.image) {
                    colorImageView.image = UIImage(color: color)
                }
            } else {// 图片
                colorImageView.sd_setImage(with: URL(string: newValue.image), placeholderImage: UIImage(named: newValue.placeholderImage))
            }
            selectImageView.isHidden = !newValue.isSelect
            selectImageView.image = UIImage(named: newValue.selectImage)
        }
    }
    
    public lazy var selectImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    public lazy var colorImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = bounds.height * 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        contentView.addSubview(colorImageView)
        contentView.addSubview(selectImageView)
        
        colorImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        selectImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

