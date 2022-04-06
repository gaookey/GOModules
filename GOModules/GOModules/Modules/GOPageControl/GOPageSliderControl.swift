//
//  GOPageSliderControl.swift
//  BrandUIKit
//
//  Created by 高文立 on 2021/8/4.
//

import UIKit
import SnapKit

@objcMembers public class GOPageSliderControl: UIView {
    
    /// 0->1
    public var x: CGFloat = 0.0 {
        didSet {
            x = min(1, x)
            x = max(0, x)
            let value = (bounds.width - bounds.width / CGFloat(count)) * x
            
            guard bounds.width > 0, count > 0 else { return }
            sliderView.snp.updateConstraints { make in
                make.leading.equalTo(value)
                make.width.equalTo(bounds.width / CGFloat(count))
            }
            layoutIfNeeded()
        }
    }
    
    public var count: NSInteger = 0 {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                guard self.bounds.width > 0, self.count > 0 else { return }
                self.sliderView.snp.updateConstraints { make in
                    make.width.equalTo(self.bounds.width / CGFloat(self.count))
                }
            }
        }
    }
    
    public lazy var sliderView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GOPageSliderControl {
    
    private func initView() {
        
        clipsToBounds = true
        backgroundColor = UIColor(white: 0, alpha: 0.25)
        
        addSubview(sliderView)
        sliderView.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(0)
        }        
    }
}
