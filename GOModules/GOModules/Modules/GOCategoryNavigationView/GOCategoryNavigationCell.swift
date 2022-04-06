//
//  GOCategoryNavigationCell.swift
//  GOCategoryNavigationView
//
//  Created by gaookey on 2021/7/29.
//

import UIKit
import SDWebImage
import SDWebImageWebPCoder
import SnapKit

@objcMembers public class GOCategoryNavigationCell: UICollectionViewCell {
    
    public var options = GOCategoryNavigationOptions() {
        didSet {
            config()
        }
    }
    
    public var data: String = "" {
        didSet {
            if options.type == .image {
                if data.isEmpty {
                    imageView.sd_setImage(with: URL(string: data), placeholderImage: UIImage(named: ""))
                } else {
                    imageView.sd_setImage(with: URL(string: data), placeholderImage: UIImage(named: options.placeholder))
                }
            } else {
                label.text = data
            }
        }
    }
    
    lazy var label: UILabel = UILabel()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
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
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func config() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = options.radius
        contentView.layer.borderColor = options.borderColor.cgColor
        contentView.layer.borderWidth = options.borderWidth
        
        contentView.backgroundColor = options.itemColor
        
        label.textColor = options.textColor
        label.font = options.font
        label.textAlignment = options.textAlignment
        label.numberOfLines = options.numberOfLines
        
        if options.type == .image {
            label.isHidden = true
            imageView.isHidden = false
        } else {
            label.isHidden = false
            imageView.isHidden = true
        }
    }
}
