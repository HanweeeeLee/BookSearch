//
//  UIViewExtension.swift
//  UIComponents
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import UIKit

extension UIView {
  
  public func anchor(
    top: NSLayoutYAxisAnchor? = nil,
    leading: NSLayoutXAxisAnchor? = nil,
    bottom: NSLayoutYAxisAnchor? = nil,
    trailing: NSLayoutXAxisAnchor? = nil,
    padding: UIEdgeInsets = .zero,
    size: CGSize = .zero
  ) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top {
      topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
    }
    
    if let leading {
      leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
    }
    
    if let bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
    }
    
    if let trailing {
      trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
    }
    
    if size.width != 0 {
      widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    if size.height != 0 {
      heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
  }
  
  public func centerInSuperview(size: CGSize = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    if let superviewCenterXAnchor = superview?.centerXAnchor {
      centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
    }
    
    if let superviewCenterYAnchor = superview?.centerYAnchor {
      centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
    }
    
    if size.width != 0 {
      widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    if size.height != 0 {
      heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
  }
  
  public func fillSuperview(padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    if let superviewTopAnchor = superview?.topAnchor {
      topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
    }
    
    if let superviewLeadingAnchor = superview?.leadingAnchor {
      leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
    }
    
    if let superviewBottomAnchor = superview?.bottomAnchor {
      bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
    }
    
    if let superviewTrailingAnchor = superview?.trailingAnchor {
      trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
    }
  }
  
}
