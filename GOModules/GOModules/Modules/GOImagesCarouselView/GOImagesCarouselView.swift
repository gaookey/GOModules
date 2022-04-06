//
//  GOImagesCarouselView.swift
//  GOImagesCarouselView
//
//  Created by gaookey on 2021/5/25.
//

import UIKit
import iCarousel
import SnapKit
import SDWebImage
import SDWebImageWebPCoder

@objc public protocol GOImagesCarouselViewDelegate: NSObjectProtocol {
    @objc optional func didSelectItem(imagesView: GOImagesCarouselView, index: Int, _ views: [UIView], parameter: Any)
    @objc optional func didScrollToItem(imagesView: GOImagesCarouselView, index: Int)
    
    @objc optional func didEndDragging(imagesView: GOImagesCarouselView)
    @objc optional func willBeginDragging(imagesView: GOImagesCarouselView)
}

@objcMembers public class GOImagesCarouselView: UIView {
    
    weak open var delegate: GOImagesCarouselViewDelegate?
    
    public var didSelectItemHandler: ((_ index: Int, _ views: [UIView], _ parameter: Any) -> ())?
    public var didScrollToItemHandler: ((_ index: Int) -> ())?
    
    /// 图片url数组
    public var imageUrls = [String]() {
        didSet {
            if imageUrls.count > 1 {
                datas = imageUrls + imageUrls
            } else {
                datas = imageUrls
            }
            pageControl.numberOfPages = imageUrls.count
            carousel.isScrollEnabled = imageUrls.count > 1
        }
    }
    
    /// 点击事件需要传出去的参数。个数需要和图片数组相等
    public var parameter = [Any]()
    
    private var datas = [String]() {
        didSet {
            if datas.count <= 1 {
                stopTimer()
            } else {
                startTimer()
            }
            carousel.reloadData()
        }
    }
    
    public var scrollEnabled = true {
        willSet {
            guard imageUrls.count > 1 else { return }
            carousel.isScrollEnabled = newValue
        }
    }
    /// 是否自动轮播。默认false
    public var isAutoScroll = false {
        didSet {
            startTimer()
        }
    }
    
    public var placeholder = UIImage()
    public var isHiddenPageControl = false {
        willSet {
            pageControl.isHidden = newValue
        }
    }
    
    public var timeInterval: TimeInterval = 5 {
        didSet {
            startTimer()
        }
    }
    
    public var currentIndex: NSInteger {
        get {
            if datas.count <= 1 {
                return carousel.currentItemIndex
            }
            return carousel.currentItemIndex >= imageUrls.count ? (carousel.currentItemIndex - imageUrls.count) : carousel.currentItemIndex
        }
    }
    
    private var timer: Timer?
    private lazy var carousel: iCarousel = {
        let view = iCarousel()
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.isPagingEnabled = true
        return view
    }()
    private var views = [Int : UIView]()
    
    private lazy var pageControl = UIPageControl()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
        
        addSubview(carousel)
        addSubview(pageControl)
        carousel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.bottom.equalTo(-12)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func carouselTimerAction() {
        guard datas.count > 1 else {
            stopTimer()
            return
        }
        let index = carousel.currentItemIndex
        
        if self.semanticContentAttribute == .forceLeftToRight {
            if index == datas.count - 1 {
                carousel.scrollToItem(at: 0, animated: true)
            } else {
                carousel.scrollToItem(at: index + 1, animated: true)
            }
        } else {
            if index == 0 {
                carousel.scrollToItem(at: datas.count - 1, animated: true)
            } else {
                carousel.scrollToItem(at: index - 1, animated: true)
            }
        }
    }
    
    public func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startTimer() {
        stopTimer()
        guard isAutoScroll else { return }
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(carouselTimerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
}

extension GOImagesCarouselView: iCarouselDelegate, iCarouselDataSource {
    
    public func numberOfItems(in carousel: iCarousel) -> Int {
        return datas.count
    }
    
    public func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var itemView = views[index]
        guard itemView == nil else { return itemView! }
        
        itemView = UIView(frame: bounds)
        let image = UIImageView(frame: bounds)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.sd_setImage(with: URL(string: datas[index]), placeholderImage: placeholder)
        itemView?.addSubview(image)
        views[index] = itemView
        
        return itemView!
    }
    
    public func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        pageControl.currentPage = currentIndex
        delegate?.didScrollToItem?(imagesView: self, index: currentIndex)
        didScrollToItemHandler?(currentIndex)
    }
    
    public func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        guard currentIndex < parameter.count else { return }
        
        var vs = [UIView]()
        var itemView = views[index]
        
        if (itemView != nil) {
            for i in 0..<imageUrls.count {
                vs.append(itemView!)
            }
        } else {
            for i in 0..<imageUrls.count {
                vs.append(UIView())
            }
        }
        
        delegate?.didSelectItem?(imagesView: self, index: currentIndex, vs, parameter: parameter[currentIndex])
        didSelectItemHandler?(currentIndex, vs, parameter[currentIndex])
    }
    
    public func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .wrap:
            return 1
        default:
            return value
        }
    }
    
    public func carouselDidEndDragging(_ carousel: iCarousel, willDecelerate decelerate: Bool) {
        delegate?.didEndDragging?(imagesView: self)
    }
    
    public func carouselWillBeginDragging(_ carousel: iCarousel) {
        delegate?.willBeginDragging?(imagesView: self)
    }
}
