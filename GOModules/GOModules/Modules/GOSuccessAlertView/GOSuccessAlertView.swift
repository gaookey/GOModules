//
//  GOSuccessAlertView.swift
//  GOSuccessAlertView
//
//  Created by gaookey on 2021/8/2.
//

import UIKit
import SnapKit

@objcMembers public class GOSuccessAlertView: UIView {
    
    private lazy var successView = GOSuccessView()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 17)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    public init(text: String, image: String) {
        super.init(frame: .zero)
        
        textLabel.text = text
        imageView.image = UIImage(named: image)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GOSuccessAlertView {
    
    private func initView() {
        
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        layer.masksToBounds = true
        layer.cornerRadius = 6
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(20)
        }
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.equalTo(15)
            make.trailing.bottom.equalTo(-15)
        }
        
        if imageView.image == nil {
            addSubview(successView)
            successView.snp.makeConstraints { make in
                make.top.equalTo(15)
                make.centerX.equalToSuperview()
                make.size.equalTo(20)
            }
        }
    }
}

@objcMembers public class GOSuccessView: UIView {
    
    // 20 * 20
    public override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 2, y: 10))
        path.addLine(to: CGPoint(x: 8, y: 16))
        path.addLine(to: CGPoint(x: 18, y: 4))
        
        path.lineWidth = 2
        UIColor.clear.setStroke()
        UIColor.clear.setFill()
        path.stroke()
        path.fill()
        
        let pathAnimation = CABasicAnimation()
        pathAnimation.keyPath = "strokeEnd"
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        pathAnimation.duration = 0.5
        
        let line = CAShapeLayer()
        line.path = path.cgPath
        line.strokeColor = UIColor.white.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 2
        line.strokeEnd = 1
        layer.addSublayer(line)
        line.add(pathAnimation, forKey: nil)
    }
}

