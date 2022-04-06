//
//  GOAlertViewController.swift
//  GOAlertViewController
//
//  Created by gaookey on 2021/6/29.
//

import UIKit
import SnapKit

@objc public enum GOAlertType: Int {
    case bottom
    case middle
}

@objcMembers public class GOAlertViewController: UIViewController {
    
    public lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = options.contentViewColor
        return view
    }()
    
    private var completionHandler: (() -> ())?
    private var options = GOAlertOptions()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = options.contentViewColor
        return view
    }()
    
    public init(options: GOAlertOptions) {
        super.init(nibName: nil, bundle: nil)
        
        self.options = options
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        if options.isKeyboardNotification {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        if options.isHiddenWhenTap {
            contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidden)))
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        show()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var corner: UIRectCorner = .allCorners
        switch options.type {
        case .middle:
            corner = .allCorners
        case .bottom:
            if options.contentViewEdgeInsets.bottom <= 0 {
                corner = [.topLeft, .topRight]
            } else {
                corner = .allCorners
            }
        }
        
        let path = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: options.radius, height: options.radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        contentView.layer.mask = maskLayer
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard options.isHiddenWhenTapContentView else { return }
        hidden()
    }
}

extension GOAlertViewController {
    
    private func show() {
        if options.type == .middle {
            UIView.animate(withDuration: options.duration) {
                self.contentView.alpha = 1
            }
        } else if options.type == .bottom {
            UIView.animate(withDuration: options.duration) {
                self.scrollView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc public func hidden() {
        
        if options.type == .middle {
            UIView.animate(withDuration: options.duration) {
                self.contentView.alpha = 0
            } completion: { finish in
                self .dismiss(animated: true, completion: self.completionHandler)
            }
        } else if options.type == .bottom {
            UIView.animate(withDuration: options.duration) {
                self.scrollView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view).offset(self.options.contentViewHeight)
                }
                self.view.layoutIfNeeded()
            } completion: { finish in
                self .dismiss(animated: true, completion: self.completionHandler)
            }
        }
    }
    
    private func initView() {
        view.backgroundColor = options.backgroundColor
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        if options.type == .middle {
            contentView.alpha = 0
            scrollView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        } else if options.type == .bottom {
            scrollView.snp.makeConstraints { make in
                make.bottom.equalTo(options.contentViewHeight)
            }
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(options.contentViewHeight)
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(options.contentViewEdgeInsets)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(options.contentViewHeight - options.contentViewEdgeInsets.top - options.contentViewEdgeInsets.bottom)
        }
        view.layoutIfNeeded()
    }
} 

extension GOAlertViewController {
    
    @objc private func keyboardWillShow(_ noti: Notification) {
        guard let info = noti.userInfo,
              let rect: CGRect = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration: TimeInterval = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        if options.type == .bottom {
            UIView.animate(withDuration: duration) {
                self.scrollView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view).offset(-rect.height)
                }
                self.view.layoutIfNeeded()
            }
        } else if options.type == .middle {
            UIView.animate(withDuration: duration) {
                self.scrollView.snp.updateConstraints { make in
                    make.centerY.equalTo(self.view).offset(-self.options.contentViewHeight * 0.5 - rect.height + UIScreen.main.bounds.height * 0.5)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ noti: Notification) {
        guard let info = noti.userInfo,
              //let rect: CGRect = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration: TimeInterval = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        if options.type == .bottom {
            UIView.animate(withDuration: duration) {
                self.scrollView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view)
                }
                self.view.layoutIfNeeded()
            }
        } else if options.type == .middle {
            UIView.animate(withDuration: duration) {
                self.scrollView.snp.updateConstraints { make in
                    make.centerY.equalTo(self.view)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension GOAlertViewController {
    
    public func present(in view: UIViewController, _ completion: (() -> ())?) {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.completionHandler = completion
        view.present(self, animated: true, completion: nil)
    }
}

@objcMembers public class GOAlertOptions: NSObject {
    
    public var backgroundColor: UIColor = UIColor(white: 0, alpha: 0.3)
    public var contentViewColor: UIColor = .white
    public var radius: CGFloat = 0
    public var duration: TimeInterval = 0.25
    public var contentViewEdgeInsets: UIEdgeInsets = .zero
    public var contentViewHeight: CGFloat = UIScreen.main.bounds.height * 0.6
    public var type: GOAlertType = .bottom
    public var isKeyboardNotification: Bool = false
    public var isHiddenWhenTapContentView: Bool = true
    public var isHiddenWhenTap: Bool = false {
        willSet {
            guard newValue else { return }
            isHiddenWhenTapContentView = true
        }
    }
}
