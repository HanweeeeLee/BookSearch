//
//  DetailViewController.swift
//  Detail
//
//  Created by hanwe on 5/30/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import UIKit
import Domain
import AppFoundation
import ImageLoader
import UIComponents

public final class DetailViewController: UIViewController, View {
  
  // MARK: - UIProperty
  
  private let backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  private let contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let loadingIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.hidesWhenStopped = true
    return indicator
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.textColor = .black
    label.numberOfLines = 0
    return label
  }()
  
  private let subTitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = .darkGray
    label.numberOfLines = 0
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = .blue
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .gray
    label.numberOfLines = 0
    return label
  }()
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let languageLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .black
    label.numberOfLines = 0
    return label
  }()
  
  private let ratingLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .black
    label.numberOfLines = 0
    return label
  }()
  
  private let pageLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .black
    label.numberOfLines = 0
    return label
  }()
  
  private let authorsLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .black
    label.numberOfLines = 0
    return label
  }()
  
  private let publisherYear: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .black
    label.numberOfLines = 0
    return label
  }()
  
  private let publisherLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .black
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var linkButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("자세한 정보 보기", for: .normal)
    button.addTarget(self, action: #selector(openLink), for: .touchUpInside)
    return button
  }()
  
  // MARK: - private property
  
  // MARK: - public property
  
  public var viewModel: DetailViewModel
  public var disposeBag = DisposeBag()
  
  // MARK: - lifeCycle
  
  public init(
    viewModel: DetailViewModel
  ) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public convenience init(
    title: String,
    viewModel: DetailViewModel
  ) {
    self.init(viewModel: viewModel)
    self.title = title
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func loadView() {
    super.loadView()
    setupUI()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    bind(viewModel: self.viewModel)
    self.viewModel.send(.requestDetail)
  }
  
  public override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
    if parent == nil {
      self.viewModel.send(.endFlow)
    }
  }
  
  public func bind(viewModel: DetailViewModel) {
    
    viewModel.state.map { $0.bookDetail }
      .withPrevious { newValue, oldValue in
        return newValue.valueUpdatedCount != oldValue?.valueUpdatedCount
      }
      .subscribe { [weak self] info in
        if let detailInfo = info.value {
          self?.updateUI(info: detailInfo)
        }
      }
      .disposed(by: self.disposeBag)

    viewModel.state.map { $0.err }
      .withPrevious { newValue, oldValue in
        return newValue.valueUpdatedCount != oldValue?.valueUpdatedCount
      }
      .subscribe { [weak self] err in
        if let err = err.value {
          DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
          }
        }
      }
      .disposed(by: self.disposeBag)
    
    viewModel.state.map { $0.isLoading }
      .withPrevious { newValue, oldValue in
        return newValue.valueUpdatedCount != oldValue?.valueUpdatedCount
      }
      .subscribe { [weak self] isLoading in
        DispatchQueue.main.async {
          if isLoading.value {
            self?.loadingIndicator.startAnimating()
          } else {
            self?.loadingIndicator.stopAnimating()
          }
        }
      }
      .disposed(by: self.disposeBag)
    
  }
  
  // MARK: - private method
  
  private func setupUI() {
    view.addSubview(backgroundView)
    backgroundView.fillSuperview()
    
    backgroundView.addSubview(scrollView)
    scrollView.fillSuperview()
    
    scrollView.addSubview(contentView)
    contentView.anchor(
      top: scrollView.topAnchor,
      leading: scrollView.leadingAnchor,
      bottom: scrollView.bottomAnchor,
      trailing: scrollView.trailingAnchor
    )
    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    
    [loadingIndicator, titleLabel, subTitleLabel, priceLabel, descriptionLabel, imageView, languageLabel, ratingLabel, pageLabel, authorsLabel, publisherYear, publisherLabel, linkButton].forEach {
      contentView.addSubview($0)
    }
    
    loadingIndicator.centerInSuperview()
    
    imageView.anchor(
      top: contentView.safeAreaLayoutGuide.topAnchor,
      leading: nil,
      bottom: nil,
      trailing: nil,
      padding: .init(
        top: .itemSidePadding,
        left: 0,
        bottom: 0,
        right: 0
      ),
      size: .init(width: 200, height: 300)
    )
    imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    
    titleLabel.anchor(
      top: imageView.bottomAnchor,
      leading: contentView.leadingAnchor,
      bottom: nil,
      trailing: contentView.trailingAnchor,
      padding: .init(
        top: .itemSidePadding,
        left: .itemSidePadding,
        bottom: 0,
        right: .itemSidePadding
      )
    )
    
    subTitleLabel.anchor(
      top: titleLabel.bottomAnchor,
      leading: contentView.leadingAnchor,
      bottom: nil,
      trailing: contentView.trailingAnchor,
      padding: .init(
        top: .itemTopPadding,
        left: .itemSidePadding,
        bottom: 0,
        right: .itemSidePadding
      )
    )
    
    priceLabel.anchor(
      top: subTitleLabel.bottomAnchor,
      leading: contentView.leadingAnchor,
      bottom: nil,
      trailing: contentView.trailingAnchor,
      padding: .init(
        top: .itemTopPadding,
        left: .itemSidePadding,
        bottom: 0,
        right: .itemSidePadding
      )
    )
    
    languageLabel.anchor(
      top: priceLabel.bottomAnchor,
      leading: contentView.leadingAnchor,
      bottom: nil,
      trailing: contentView.trailingAnchor,
      padding: .init(
        top: .itemTopPadding,
        left: .itemSidePadding,
        bottom: 0,
        right: .itemSidePadding
      )
    )
    
    ratingLabel.anchor(
      top: languageLabel.bottomAnchor,
      leading: contentView.leadingAnchor,
      bottom: nil,
      trailing: contentView.trailingAnchor,
      padding: .init(
        top: .itemTopPadding,
        left: .itemSidePadding,
        bottom: 0,
        right: .itemSidePadding
      )
    )
    
    pageLabel.anchor(
      top: ratingLabel.bottomAnchor,
      leading: contentView.leadingAnchor,
      bottom: nil,
      trailing: contentView.trailingAnchor,
      padding: .init(
        top: .itemTopPadding,
        left: .itemSidePadding,
        bottom: 0,
        right: .itemSidePadding
      )
    )
    
    authorsLabel.anchor(
      top: pageLabel.bottomAnchor,
      leading: contentView.leadingAnchor,
      bottom: nil,
      trailing: contentView.trailingAnchor,
      padding: .init(
        top: .itemTopPadding,
        left: .itemSidePadding,
        bottom: 0,
        right: .itemSidePadding
      )
    )
    
    publisherYear.anchor(
      top: authorsLabel.bottomAnchor,
      leading: contentView.leadingAnchor,
      bottom: nil,
      trailing: contentView.trailingAnchor,
      padding: .init(
        top: .itemTopPadding,
        left: .itemSidePadding,
        bottom: 0,
        right: .itemSidePadding
      )
    )
    
    publisherLabel.anchor(
      top: publisherYear.bottomAnchor,
      leading: contentView.leadingAnchor,
      bottom: nil,
      trailing: contentView.trailingAnchor,
      padding: .init(
        top: .itemTopPadding,
        left: .itemSidePadding,
        bottom: 0,
        right: .itemSidePadding
      )
    )
    
    descriptionLabel.anchor(
      top: publisherLabel.bottomAnchor,
      leading: contentView.leadingAnchor,
      bottom: nil,
      trailing: contentView.trailingAnchor,
      padding: .init(
        top: .itemTopPadding,
        left: .itemSidePadding,
        bottom: 0,
        right: .itemSidePadding
      )
    )
    
    linkButton.anchor(
      top: descriptionLabel.bottomAnchor,
      leading: contentView.leadingAnchor,
      bottom: contentView.bottomAnchor,
      trailing: contentView.trailingAnchor,
      padding: .init(
        top: .itemTopPadding,
        left: .itemSidePadding,
        bottom: .itemTopPadding,
        right: .itemSidePadding
      )
    )
  }
  
  private func updateUI(info bookDetail: BookDetail) {
    DispatchQueue.main.async { [weak self] in
      self?.titleLabel.text = bookDetail.title
      self?.subTitleLabel.text = bookDetail.subTitle
      self?.priceLabel.text = bookDetail.price
      self?.descriptionLabel.text = bookDetail.description
      self?.languageLabel.text = "언어: \(bookDetail.language)"
      self?.ratingLabel.text = "별점: \(bookDetail.rating)"
      self?.pageLabel.text = "페이지 수: \(bookDetail.page)"
      self?.authorsLabel.text = "작가: \(bookDetail.authors)"
      self?.publisherYear.text = "출판년도: \(bookDetail.publishedYear)"
      self?.publisherLabel.text = "출판사: \(bookDetail.publisher)"
      self?.linkButton.isHidden = bookDetail.linkUrl == nil
      self?.imageView.setImage(from: bookDetail.imageUrl)
    }
  }
  
  @objc private func openLink() {
    if let url = self.viewModel.state.value?.bookDetail.value?.linkUrl {
      UIApplication.shared.open(url)
    }
  }
}
