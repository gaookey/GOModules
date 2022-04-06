//
//  GOPageControl.swift
//  GOPageControl
//
//  Created by gaookey on 2021/7/28.
//

import UIKit
import SnapKit
import YYCategories

@objc public enum GOPageControlType: Int {
    case system
    case round
    case square
}

@objcMembers public class GOPageControl: UIView {
    
    public var numberOfPages: NSInteger = 0 {
        didSet {
            systemPageControl.numberOfPages = numberOfPages
            reloadData()
        }
    }
    
    public var currentPage: NSInteger = 0 {
        didSet {
            systemPageControl.currentPage = currentPage
            pageControl.reloadData()
        }
    }
    
    /// 宽度。 square 模式
    public var squareSize: CGSize = CGSize(width: 25.0, height: 3.0) {
        didSet {
            reloadData()
        }
    }
    
    /// square 和 round 模式下起效
    public var margin: CGFloat = 0.0 {
        didSet {
            reloadData()
        }
    }
    
    public var type: GOPageControlType = .system {
        didSet {
            switch type {
            case .system:
                systemPageControl.isHidden = false
                pageControl.isHidden = true
                break
            case .round:
                systemPageControl.isHidden = true
                pageControl.isHidden = false
                
                reloadData()
                break
            case .square:
                systemPageControl.isHidden = true
                pageControl.isHidden = false
                
                reloadData()
                break
            }
        }
    }
    
    private lazy var systemPageControl = UIPageControl()
    
    private lazy var pageControl: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.register(GOPageControlRoundCell.self, forCellWithReuseIdentifier: "GOPageControlRoundCellID")
        view.register(GOPageControlSquareCell.self, forCellWithReuseIdentifier: "GOPageControlSquareCellID")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.isHidden = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GOPageControl {
    
    private func reloadData() {
        var width: CGFloat = 0.0
        if type == .round {
            width = 15.0
        } else if (type == .square) {
            width = squareSize.width
        }
        
        pageControl.snp.updateConstraints { make in
            make.width.equalTo(CGFloat(numberOfPages) * width + (CGFloat(numberOfPages) - 1) * margin)
        }
        pageControl.reloadData()
    }
    
    private func initView() {
        addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.top.bottom.equalToSuperview()
            make.width.equalTo(0)
        }
        
        addSubview(systemPageControl)
        systemPageControl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
} 

extension GOPageControl: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPages
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard type == .round else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GOPageControlSquareCellID", for: indexPath) as! GOPageControlSquareCell
            cell.isSelect = indexPath.row == currentPage
            cell.squareSize = squareSize
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GOPageControlRoundCellID", for: indexPath) as! GOPageControlRoundCell
        cell.isSelect = indexPath.row == currentPage
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = type == .round ? 15 : squareSize.width
        return CGSize(width: width, height: 20)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


class GOPageControlRoundCell: UICollectionViewCell {
    
    var isSelect = false {
        willSet {
            if newValue {
                roundView.backgroundColor = .black
                roundView.layer.cornerRadius = 4
                roundView.layer.borderColor = UIColor(hexString: "DDDDDD80")?.cgColor
                roundView.snp.updateConstraints { make in
                    make.size.equalTo(8)
                }
            } else {
                roundView.backgroundColor = UIColor(white: 1, alpha: 0.5)
                roundView.layer.cornerRadius = 3.5
                roundView.layer.borderColor = UIColor(hexString: "BFBFBF80")?.cgColor
                roundView.snp.updateConstraints { make in
                    make.size.equalTo(7)
                }
            }
        }
    }
    
    private lazy var roundView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        contentView.addSubview(roundView)
        roundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(7)
        }
    }
}


class GOPageControlSquareCell: UICollectionViewCell {
    
    var isSelect = false {
        willSet {
            if newValue {
                squareView.backgroundColor = .black
            } else {
                squareView.backgroundColor = UIColor(white: 0, alpha: 0.25)
            }
        }
    }
    
    var squareSize: CGSize = CGSize(width: 25, height: 3) {
        didSet {
            squareView.snp.updateConstraints { make in
                make.height.equalTo(squareSize.height)
            }
        }
    }
    
    private lazy var squareView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        contentView.addSubview(squareView)
        squareView.snp.makeConstraints { make in
            make.centerY.leading.trailing.equalToSuperview()
            make.height.equalTo(squareSize.height)
        }
    }
}
