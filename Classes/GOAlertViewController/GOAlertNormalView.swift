//
//  GOAlertNormalView.swift
//  GOAlertNormalView
//
//  Created by gaookey on 2021/6/30.
//

import UIKit
import SnapKit

@objcMembers public class GOAlertNormalView: UIView {
    
    public var leftHandler: (() -> ())?
    public var rightHandler: (() -> ())?
    
    public var isHideWhenLeftAction = true
    public var isHideWhenRightAction = true
    
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
    
    public lazy var leftButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
        return view
    }()
    
    public lazy var rightButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        return view
    }()
    
    
    public lazy var verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .groupTableViewBackground
        return view
    }()
    
    public lazy var horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .groupTableViewBackground
        return view
    }()
    
    private var alertViewController: GOAlertViewController?
    
    public init(title: String, detailText: String, left: String, right: String) {
        super.init(frame: .zero)
        
        layer.masksToBounds = true
        layer.cornerRadius = 12
        
        titleLabel.text = title
        detailTextLabel.text = detailText
        leftButton.setTitle(left, for: .normal)
        rightButton.setTitle(right, for: .normal)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GOAlertNormalView {
    
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

extension GOAlertNormalView {
    
    private func initView() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(detailTextLabel)
        addSubview(horizontalLine)
        addSubview(verticalLine)
        addSubview(leftButton)
        addSubview(rightButton)
        
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
        verticalLine.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine.snp.bottom)
            make.width.equalTo(1)
            make.height.equalTo(48)
            make.bottom.centerX.equalToSuperview()
        }
        leftButton.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
            make.trailing.equalTo(verticalLine.snp.leading)
            make.top.equalTo(horizontalLine.snp.bottom)
        }
        rightButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.leading.equalTo(verticalLine.snp.trailing)
            make.top.equalTo(horizontalLine.snp.bottom)
        }
    }
}

extension GOAlertNormalView {
    
    @objc private func leftButtonClick() {
        leftHandler?()
        guard isHideWhenLeftAction else { return }
        hidden()
    }
    
    @objc private func rightButtonClick() {
        rightHandler?()
        guard isHideWhenRightAction else { return }
        hidden()
    }
}
