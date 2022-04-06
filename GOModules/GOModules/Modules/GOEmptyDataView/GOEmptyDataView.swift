//
//  GOEmptyDataView.swift
//  GOEmptyDataView
//
//  Created by gaookey on 2021/5/6.
//

import UIKit
import SnapKit 

class GOEmptyDataView: UIView {
    
    var viewButtonClickHandler: (() -> ())?
    
    private var options = GOEmptyDataViewOptions()
    
    private lazy var viewImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: options.image))
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var tipLabel: UILabel = {
        let view = UILabel()
        view.text = options.text
        view.textColor = options.textColor
        view.font = options.textFont
        view.textAlignment = options.textAlignment
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var viewButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle(options.buttonText, for: .normal)
        view.setTitleColor(options.buttonTextColor, for: .normal)
        view.titleLabel?.font = options.buttonTextFont
        view.backgroundColor = options.buttonColor
        view.addTarget(self, action: #selector(viewButtonClick(_:)), for: .touchUpInside)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = options.buttonRadius
        return view
    }()
    
    init(options: GOEmptyDataViewOptions) {
        super.init(frame: .zero)
        
        self.options = options
        backgroundColor = options.viewColor
        
        if let _ = options.customView {
            initCustomView()
        } else {
            initView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GOEmptyDataView {
    
    private func initCustomView() {
        guard let view = options.customView else { return }
        
        addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
    }
    
    private func initView() {
        addSubview(viewImageView)
        addSubview(tipLabel)
        addSubview(viewButton)
        
        tipLabel.isHidden = options.textHide
        viewButton.isHidden = options.buttonHide

        viewImageView.snp.makeConstraints { (make) in
            make.top.equalTo(options.imageTop)
            make.centerX.equalTo(self)
            make.size.equalTo(options.imageSize)
        }
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(viewImageView.snp.bottom).offset(options.textTop)
            make.leading.equalTo(options.textMargin);
            make.trailing.equalTo(-options.textMargin);
        }
        
        var viewButtonWidth = options.buttonMinWidth
        if let text: NSString = options.buttonText as? NSString {
            let w = text.size(withAttributes: [NSAttributedString.Key.font : options.buttonTextFont]).width + 2 * options.buttonMargin
            viewButtonWidth = w < viewButtonWidth ? viewButtonWidth : w
            viewButtonWidth = viewButtonWidth < options.buttonMaxWidth ? viewButtonWidth : options.buttonMaxWidth
        }
        viewButton.snp.makeConstraints { (make) in
            if options.textHide && !options.buttonHide { // 隐藏text，不隐藏button
                make.top.equalTo(viewImageView.snp.bottom).offset(options.buttonTop)
            } else {
                make.top.equalTo(tipLabel.snp.bottom).offset(options.buttonTop)
            }
            make.top.equalTo(tipLabel.snp.bottom).offset(options.buttonTop)
            make.centerX.equalTo(self)
            make.height.equalTo(options.buttonHeight)
            make.width.equalTo(viewButtonWidth)
        }
    }
}

extension GOEmptyDataView {
    @objc private func viewButtonClick(_ button: UIButton) {
        viewButtonClickHandler?()
    }
}

