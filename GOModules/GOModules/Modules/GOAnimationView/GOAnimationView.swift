//
//  GOAnimationView.swift
//  GOModules
//
//  Created by gaookey on 2021/6/11.
//

import UIKit
import Lottie
import SnapKit

@objcMembers public class GOAnimationView: UIView {
    
    /// animationView 动画文件名
    public var jsonName = "";
    /// animationView 动画是否循环
    public var isLoop = false {
        willSet {
            animationView.loopMode = newValue ? .loop : .playOnce
            animationImageView.animationRepeatCount = newValue ? .max : 1
        }
    }
    
    /// animationImageView 动画数组
    public var images = [UIImage]()
    /// animationImageView 动画时间。默认1s
    public var animationDuration: TimeInterval = 1
    
    private lazy var animationView: AnimationView = {
        let view = AnimationView(name: jsonName)
        view.loopMode = .playOnce
        return view
    }()
    
    private lazy var animationImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    public init(images: [UIImage]) {
        super.init(frame: .zero)
        
        self.images = images
        initImagesView()
    }
    
    public init(jsonName: String) {
        super.init(frame: .zero)
        
        self.jsonName = jsonName
        initAnimationView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GOAnimationView {
    
    public func startAnimating() {
        animationView.play()
        
        guard animationImageView.isAnimating == false else { return }
        animationImageView.animationImages = images
        animationImageView.animationDuration = animationDuration
        animationImageView.animationRepeatCount = 1
        animationImageView.startAnimating()
    }
    
    public func stopAnimating() {
        animationView.stop()
        animationImageView.stopAnimating()
    }
}

extension GOAnimationView {
    private func initAnimationView() {
        addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension GOAnimationView {
    private func initImagesView() {
        addSubview(animationImageView)
        animationImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
