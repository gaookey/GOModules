//
//  GOCustomTagView.swift
//  GOCustomTagsView
//
//  Created by gaookey on 2021/5/31.
//

import UIKit
import SnapKit
import YYCategories

@objcMembers public class GOCustomTagsModel: NSObject {
    
    public var ID: NSInteger = 0
    public var title = " "
    public var image = " "
    public var number: NSInteger = 0
    
    public init(ID: NSInteger, title: String, image: String) {
        self.ID = ID
        self.title = title
        self.image = image
    }
}

@objcMembers public class GOCustomTagView: UIView {
    
    public var didSelectItemHandler: ((_ ID: NSInteger) -> ())?
    
    public var ID: NSInteger = 999999
    
    public var number: NSInteger = 0 {
        willSet {
            updateNumLabel(newValue)
        }
    }
    
    public var imageViewSize: CGSize = .zero {
        willSet {
            imageView.snp.updateConstraints { make in
                make.size.equalTo(newValue)
            }
        }
    }
    
    public lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    public lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hexString: "808080")
        view.font = .systemFont(ofSize: 12)
        view.textAlignment = .center
        view.numberOfLines = 2
        return view
    }()
    
    public lazy var numLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.backgroundColor = UIColor(hexString: "DD3A3A")
        view.font = .systemFont(ofSize: 9)
        view.textAlignment = .center
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        view.isHidden = true
        return view
    }()
    
    public init(ID: NSInteger = 999999, title: String = "", image: String = "") {
        super.init(frame: .zero)
        
        initView()
        
        self.ID = ID
        self.titleLabel.text = title
        self.imageView.image = UIImage(named: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GOCustomTagView {
    
    private func initView() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(numLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self)
        }
        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.top.equalTo(9)
        }
        numLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.centerY.equalTo(imageView.snp.top)
            make.height.equalTo(12)
            make.width.equalTo(12)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewAction)))
    }
    
    @objc private func viewAction() {
        didSelectItemHandler?(ID)
    }
}

extension GOCustomTagView {
    
    private func updateNumLabel(_ value: NSInteger) {
        numLabel.isHidden = value <= 0
        
        let num = value > 99 ? "99+" : "\(value)"
        numLabel.text = num
        
        var width: CGFloat = 0
        if value < 10 {
            width = 12
        } else if value >= 10 && value <= 99 {
            width = 20
        } else {
            width = 26
        }
        numLabel.snp.updateConstraints { make in
            make.width.equalTo(width)
        }
    }
}
