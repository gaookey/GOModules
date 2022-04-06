//
//  GOCustomTagsView.swift
//  GOCustomTagsView
//
//  Created by gaookey on 2021/5/31.
//

import UIKit
import YYCategories

@objcMembers public class GOCustomTagsView: UIView {
    
    public var didSelectItemHandler: ((_ ID: NSInteger) -> ())?
    
    public var tags = [GOCustomTagsModel]() {
        didSet {
            updateView()
        }
    }
    
    public var isHiddenMore = true {
        willSet {
            moreButton.isHidden = newValue
            moreImageView.isHidden = newValue
        }
    }
    
    public var titleText: String = "" {
        willSet {
            titleLabel.text = newValue
        }
    }
    
    public var moreText: String = "" {
        willSet {
            moreButton.setTitle(newValue, for: .normal)
        }
    }
    
    public var moreImage: String = "" {
        willSet {
            if var image = UIImage(named: newValue), let cgImage = image.cgImage {
                if self.semanticContentAttribute == .forceRightToLeft {
                    image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .upMirrored)
                }
                moreImageView.image = image
            }
        }
    }
    
    public lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 16, weight: .semibold)
        return view
    }()
    
    public lazy var moreButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 12)
        view.addTarget(self, action: #selector(moreButtonClick(_:)), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    public lazy var moreImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.isHidden = true
        return view
    }()
    
    private var tagButtonViews = [(ID: NSInteger, view: GOCustomTagView)]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = 3
        
        initView()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GOCustomTagsView {
    
    public func updateNumber(_ parameter: [String : String]) {
        for i in 0..<tagButtonViews.count {
            let tag = tagButtonViews[i]
            if let number: String = parameter["\(tag.ID)"],
               let num: NSInteger = NSInteger(number) {
                tag.view.number = num
            }
        }
    }
}

extension GOCustomTagsView {
    
    @objc private func moreButtonClick(_ button: UIButton) {
        didSelectItemHandler?(1004)
    }
    
    private func updateView() {
        
        var lastButton = GOCustomTagView()
        
        for i in 0..<tags.count {
            let m = tags[i]
            let button = GOCustomTagView(ID: m.ID, title: m.title, image: m.image)
            button.didSelectItemHandler = { [weak self] ID in
                guard let weakSelf = self else { return }
                weakSelf.didSelectItemHandler?(ID)
            }
            self.addSubview(button)
            if i == 0 {
                button.snp.makeConstraints { make in
                    make.top.equalTo(44)
                    make.leading.equalTo(10)
                }
            } else if i == tags.count - 1 {
                button.snp.makeConstraints { make in
                    make.top.width.equalTo(lastButton)
                    make.leading.equalTo(lastButton.snp.trailing).offset(10)
                    make.trailing.equalTo(-10)
                }
            } else {
                button.snp.makeConstraints { make in
                    make.top.width.equalTo(lastButton)
                    make.leading.equalTo(lastButton.snp.trailing).offset(10)
                }
            }
            lastButton = button
            tagButtonViews.append((ID: m.ID, view: button))
        }
    }
    
    private func initView() {
        addSubview(titleLabel)
        addSubview(moreImageView)
        addSubview(moreButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(15)
        }
        moreImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 9 * 0.5, height: 15 * 0.5))
            make.trailing.equalTo(-15)
        }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(moreImageView.snp.leading).offset(-5)
            make.height.equalTo(60)
        }
    }
}
