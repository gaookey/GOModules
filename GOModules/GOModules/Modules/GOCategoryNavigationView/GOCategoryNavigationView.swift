//
//  GOCategoryNavigationView.swift
//  GOCategoryNavigationView
//
//  Created by 高文立 on 2021/7/28.
//

import UIKit
import SnapKit
import SDWebImage

@objc public protocol GOCategoryNavigationViewDelegate: NSObjectProtocol {
    @objc optional func didEndDragging(categoryView: GOCategoryNavigationView, scrollView: UIScrollView)
    @objc optional func willBeginDragging(categoryView: GOCategoryNavigationView, scrollView: UIScrollView)
}

@objcMembers public class GOCategoryNavigationView: UIView {
    
    weak open var delegate: GOCategoryNavigationViewDelegate?

    public var didSelectItemHandler: ((_ indexPath: IndexPath, _ parameter: Any) -> ())?
    public var didScrollHandler: ((_ offsetX: CGFloat) -> ())?
    public var didEndDragging: (() -> ())?
    public var willBeginDragging: (() -> ())?
    
    
    public var dataSource: [[String]] {
        get {
            // 二维数组 直接返回
            guard datas2.isEmpty else { return datas2 }
            
            // 一维数组
            guard datas.count > number else { return [datas] }
            let data = stride(from: 0, through: datas.count - 1, by: number).map { (index) -> [String] in
                if (index + number) > datas.count {
                    return Array(datas[index...])
                } else {
                    return Array(datas[index..<index+number])
                }
            }
            return data
        }
    }
    
    public var contentSize: CGSize {
        get {
            guard !dataSource.isEmpty, let count = dataSource.max{ $0.count < $1.count }?.count else { return .zero }
            let width = UIScreen.main.bounds.width * CGFloat(dataSource.count)
            
            var rows: NSInteger = 0;
            if (count % options.columnCount == 0) {
                rows = count / options.columnCount;
            } else {
                rows = count / options.columnCount + 1;
            }
            var height = CGFloat(rows) * options.itemSize.height + (CGFloat(rows) - 1) * options.rowMargin;
            height = ceil(options.insetsTop + height + options.insetsBottom)
            
            return CGSize(width: width, height: height)
        }
    }
    
    public var scrollEnabled: Bool = true {
        willSet {
            collectionView.isScrollEnabled = newValue
        }
    }
    
    /// 点击事件需要传出去的参数。需要和dataSource对应
    public var parameter = [[Any]]()
    
    private lazy var contentImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = options.contentColor
        view.sd_setImage(with: URL(string: options.contentImage))
        return view
    }()
    
    /// 接收的一维数组，手动转为二维数组
    private var datas: [String] = [String]()
    /// 每页多少条
    private var number: Int = 0
    
    /// 接收的二维数组，无需转化。
    private var datas2: [[String]] = [[String]]()
    
    private var options = GOCategoryNavigationOptions()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = GOCategoryNavigationFlowLayout()
        layout.itemSize = options.itemSize
        layout.columnCount = options.columnCount
        layout.columnMargin = options.columnMargin
        layout.rowMargin = options.rowMargin
        layout.edgeInsets = UIEdgeInsets(top: options.insetsTop, left: options.insetsLeftRight, bottom: options.insetsBottom, right: options.insetsLeftRight)
        layout.scrollDirection = .horizontal
        layout.delegate = self
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.register(GOCategoryNavigationCell.self, forCellWithReuseIdentifier: "GOCategoryNavigationCellID")
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = true
        view.bounces = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.isHidden = true
        return view
    }()
    
    public init(options: GOCategoryNavigationOptions) {
        super.init(frame: .zero)
        
        self.options = options
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GOCategoryNavigationView {
    
    /// 更新数据
    /// - Parameters:
    ///   - datas: 所有的数据 二维数组
    ///   - number: 每页显示多少条。需要和 GOCategoryNavigationOptions.columnCount 属性是整除的值
    ///   - heightHandler: 根据数据计算返回的view高度
    /// - Returns:
    public func update(datas2: [[String]], completionHandler: ((_ height: CGFloat) -> ())?) {
        self.datas2 = datas2
        config(completionHandler: completionHandler)
    }
    
    /// 更新数据
    /// - Parameters:
    ///   - datas: 所有的数据
    ///   - number: 每页显示多少条
    ///   - heightHandler: 根据数据计算返回的view高度
    /// - Returns:
    public func update(datas: [String], number: Int, completionHandler: ((_ height: CGFloat) -> ())?) {
        self.datas = datas
        self.number = number
        
        config(completionHandler: completionHandler)
    }
    
    
    private func config(completionHandler: ((_ height: CGFloat) -> ())?) {
        
        pageControl.isHidden = options.isHiddenPageControl
        if !options.isHiddenPageControl { // 不隐藏 pageControl
            pageControl.numberOfPages = dataSource.count
            pageControl.currentPage = 0
            pageControl.isHidden = dataSource.count <= 1
        }
        
        collectionView.reloadData()
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(contentSize.height)
        }
        
        if options.isHiddenPageControl == false, dataSource.count > 1 {
            completionHandler?(contentSize.height + 20)
        } else {
            completionHandler?(contentSize.height)
        }
    }
}

extension GOCategoryNavigationView: GOCategoryNavigationFlowLayoutDelegate {
    
    func contentSize(view: GOCategoryNavigationFlowLayout) -> CGSize {
        return contentSize
    }
}

extension GOCategoryNavigationView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GOCategoryNavigationCellID", for: indexPath) as! GOCategoryNavigationCell
        cell.options = options
        cell.data = dataSource[indexPath.section][indexPath.row]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard parameter.count > indexPath.section,
              parameter[indexPath.section].count > indexPath.row else { return }
        let data = parameter[indexPath.section][indexPath.row]
        didSelectItemHandler?(indexPath, data)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            scrollViewDidEndDecelerating(scrollView)
        }
        delegate?.didEndDragging?(categoryView: self, scrollView: scrollView)
        didEndDragging?()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.willBeginDragging?(categoryView: self, scrollView: scrollView)
        willBeginDragging?()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x / (contentSize.width - UIScreen.main.bounds.width)
        didScrollHandler?(offsetX)
    }
}

extension GOCategoryNavigationView {
    
    private func initView() {
        addSubview(contentImageView)
        addSubview(collectionView)
        addSubview(pageControl)
        
        contentImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(0)
        }
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
    }
}
