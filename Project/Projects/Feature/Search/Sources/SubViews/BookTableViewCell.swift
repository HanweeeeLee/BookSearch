//
//  BookTableViewCell.swift
//  Search
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import UIKit
import AppFoundation
import ImageLoader
import Domain
import UIComponents

final class BookTableViewCell: UITableViewCell, ClassIdentifiable {
  
  // MARK: - components
  
  private let bookImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8
    imageView.backgroundColor = .lightGray
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textColor = .black
    label.numberOfLines = 2
    return label
  }()
  
  private let subTitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textColor = .darkGray
    label.numberOfLines = 1
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textColor = .blue
    label.textAlignment = .right
    return label
  }()
  
  // MARK: - private properties
  
  // MARK: - internal properties
  
  // MARK: - life cycle
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    self.bookImageView.backgroundColor = .lightGray
  }
  
  // MARK: - private method
  
  private func setupUI() {
    contentView.addSubview(bookImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(subTitleLabel)
    contentView.addSubview(priceLabel)
    
    bookImageView.anchor(
      top: contentView.topAnchor,
      leading: contentView.leadingAnchor,
      bottom: contentView.bottomAnchor,
      padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
      size: CGSize(width: 80, height: 0)
    )
    
    titleLabel.anchor(
      top: contentView.topAnchor,
      leading: bookImageView.trailingAnchor,
      trailing: contentView.trailingAnchor,
      padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    )
    
    subTitleLabel.anchor(
      top: titleLabel.bottomAnchor,
      leading: bookImageView.trailingAnchor,
      trailing: contentView.trailingAnchor,
      padding: UIEdgeInsets(top: 4, left: 8, bottom: 0, right: 8)
    )
    
    priceLabel.anchor(
      top: subTitleLabel.bottomAnchor,
      leading: bookImageView.trailingAnchor,
      bottom: contentView.bottomAnchor,
      trailing: contentView.trailingAnchor,
      padding: UIEdgeInsets(top: 4, left: 8, bottom: 8, right: 8)
    )
  }
  
  // MARK: - internal method
  
  func setConfigure(_ data: Book) {
    titleLabel.text = data.title
    subTitleLabel.text = data.subTitle
    priceLabel.text = data.price
    self.bookImageView.setImage(from: data.imageUrl, completion: {
      self.bookImageView.backgroundColor = .clear
    })
  }
}
