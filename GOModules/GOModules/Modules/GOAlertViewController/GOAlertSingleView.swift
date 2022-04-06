//
//  GOAlertSingleView.swift
//  BrandUIKit
//
//  Created by gaookey on 2021/7/1.
//

import UIKit
import SnapKit

@objcMembers public class GOAlertSingleView: UIView {
    
    public var actionHandler: (() -> ())?
    
    public var isHideWhenAction = true
    
    public lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    public lazy var detailTextLabel: UILabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 12)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    public lazy var singleButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.addTarget(self, action: #selector(singleButtonAction), for: .touchUpInside)
        return view
    }()
    
    public lazy var horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .groupTableViewBackground
        return view
    }()
    
    private var alertViewController: GOAlertViewController?
    
    public init(title: String, detailText: String, button: String) {
        super.init(frame: .zero)
        
        layer.masksToBounds = true
        layer.cornerRadius = 12
        
        titleLabel.text = title
        detailTextLabel.text = detailText
        singleButton.setTitle(button, for: .normal)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GOAlertSingleView {
    
    @objc public func showView(in view: UIViewController, _ completion: (() -> ())?) {
        let options = GOAlertOptions()
        options.type = .middle
        options.isHiddenWhenTapContentView = false
        options.contentViewColor = .clear
        let alert = GOAlertViewController(options: options)
        alertViewController = alert
        alert.contentView.addSubview(self)
        self.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 100)
        }
        alert.present(in: view, completion)
    }
    
    @objc public func hidden() {
        alertViewController?.hidden()
    }
}

extension GOAlertSingleView {
    
    private func initView() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(detailTextLabel)
        addSubview(horizontalLine)
        addSubview(singleButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(25)
            make.trailing.equalTo(-25)
        }
        var margin: CGFloat = 15
        if let count = detailTextLabel.text?.count, count <= 0 {
            margin = 0
        }
        detailTextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(margin)
            make.leading.trailing.equalTo(titleLabel)
        }
        horizontalLine.snp.makeConstraints { make in
            make.top.equalTo(detailTextLabel.snp.bottom).offset(15)
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }
        singleButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(horizontalLine.snp.bottom)
            make.height.equalTo(48)
        }
    }
}

extension GOAlertSingleView {
    
    @objc private func singleButtonAction() {
        actionHandler?()
        guard isHideWhenAction else { return }
        hidden()
    }
}

