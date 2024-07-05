//
//  StatusProvider.swift
//  MindPause
//
//  Created by Vishal Manhas on 23/04/24.
//

import Foundation
import UIKit

public protocol StatusModel {
    var isLoading: Bool         { get }
    var title: String?          { get }
    var description: String?    { get }
    var actionTitle: String?    { get }
    var action: (() -> Void)?   { get }
}

extension StatusModel {
    
    public var isLoading: Bool {
        return false
    }
    
    public var title: String? {
        return nil
    }
    
    public var description: String? {
        return nil
    }
    
    public var actionTitle: String? {
        return nil
    }
    
    public var image: UIImage? {
        return nil
    }
    
    public var action: (() -> Void)? {
        return nil
    }

}


public struct Status: StatusModel {
    public let isLoading: Bool
    public let title: String?
    public let description: String?
    public let actionTitle: String?
    public let action: (() -> Void)?
    
    public init(isLoading: Bool = false, title: String? = nil, description: String? = nil, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.isLoading = isLoading
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public static var simpleLoading: Status {
        return Status(isLoading: true)
    }
}

public protocol StatusView: class {
    var status: StatusModel?  { set get }
    var view: UIView { get }
}

public protocol StatusController {
    var onView: StatusViewContainer { get }
    var statusView: StatusView?     { get }

    func show(status: StatusModel)
    func hideStatus()
}

extension StatusController {
        
    public var statusView: StatusView? {
        return DefaultStatusView()
    }
    
    public func hideStatus() {
        onView.statusContainerView = nil
    }
    
    public func show(status: StatusModel) {
        guard let sv = statusView else { return }
        sv.status = status
        onView.statusContainerView = sv.view
    }
}

extension StatusController where Self: UIView {
    
    public var onView: StatusViewContainer {
        return self
    }
}

extension StatusController where Self: UIViewController {
    
    public var onView: StatusViewContainer {
        return view
    }
}

extension StatusController where Self: UITableViewController {
    
    public var onView: StatusViewContainer {
        if let backgroundView = tableView.backgroundView {
            return backgroundView
        }
        return view
    }
}

public protocol StatusViewContainer: class {
    var statusContainerView: UIView? { get set }
}

extension UIView: StatusViewContainer {
    public static let StatusViewTag = 666
    
    open var statusContainerView: UIView? {
        get {
            return viewWithTag(UIView.StatusViewTag)
        }
        set {
            viewWithTag(UIView.StatusViewTag)?.removeFromSuperview()
            
            guard let view = newValue else { return }
            
            view.tag = UIView.StatusViewTag
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: centerXAnchor),
                view.centerYAnchor.constraint(equalTo: centerYAnchor),
                view.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20.0),
                view.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -20.0),
                view.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
                view.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
            ])
        }
    }
}




open class DefaultStatusView: UIView, StatusView {
    
    public var view: UIView {
        return self
    }
    
    public var status: StatusModel? {
        didSet {
            
            guard let status = status else { return }
            
            imageView.image = status.image
            titleLabel.text = status.title
            descriptionLabel.text = status.description
            actionButton.setTitle(status.actionTitle, for: UIControl.State())
            
            if status.isLoading {
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
            }
            
            imageView.isHidden = imageView.image == nil
            titleLabel.isHidden = titleLabel.text == nil
            descriptionLabel.isHidden = descriptionLabel.text == nil
            actionButton.isHidden = status.action == nil
            
            verticalStackView.isHidden = imageView.isHidden && descriptionLabel.isHidden && actionButton.isHidden
        }
    }
    
    public let titleLabel: UILabel = {
       
        $0.textColor = UIColor.lightGray
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    public let descriptionLabel: UILabel = {
       
        $0.textColor = UIColor.lightGray
        $0.textAlignment = .center
        $0.numberOfLines = 0
         return $0
    }(UILabel())
    
    public let activityIndicatorView: UIActivityIndicatorView = {
        $0.isHidden = true
        $0.hidesWhenStopped = true
        $0.style = .whiteLarge
        $0.color = UIColor.lightGray
        return $0
    }(UIActivityIndicatorView())
    
    public let imageView: UIImageView = {
        $0.contentMode = .center
        
        return $0
    }(UIImageView())
    
    public let actionButton: UIButton = {
        $0.backgroundColor = UIColor.cyan
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.layer.cornerRadius = 15 // this value vary as per your desire
        $0.clipsToBounds = true
        $0.contentEdgeInsets = UIEdgeInsets(top: 7.0, left: 20.0, bottom: 7.0, right: 20.0)
        return $0
    }(UIButton(type: .system))
    
    public let verticalStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .center

        return $0
    }(UIStackView())
    
    public let horizontalStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        
        return $0
    }(UIStackView())
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        actionButton.addTarget(self, action: #selector(DefaultStatusView.actionButtonAction), for: .touchUpInside)
        
        addSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(activityIndicatorView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(imageView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addArrangedSubview(actionButton)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    @objc func actionButtonAction() {
        status?.action?()
    }
    
    open override var tintColor: UIColor! {
        didSet {
            titleLabel.textColor = tintColor
            descriptionLabel.textColor = tintColor
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



