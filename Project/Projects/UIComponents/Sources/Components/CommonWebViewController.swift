//
//  CommonWebViewController.swift
//  UIComponents
//
//  Created by hanwe on 5/31/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import UIKit
import WebKit

public final class CommonWebViewController: UIViewController {
  
  public enum ShowType {
    case push
    case present
  }
  
  // MARK: - UIProperty
  
  private var webView: WKWebView = {
    let view = WKWebView(frame: .zero)
    return view
  }()
  
  private lazy var closeButton: UIBarButtonItem = {
    var button = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
    button.tintColor = .black
    return button
  }()
  
  // MARK: - private property
  
  private var url: URL
  private let showType: ShowType
  
  // MARK: - public property
  
  // MARK: - lifeCycle
  
  public init(
    url: URL,
    title: String? = nil,
    showType: ShowType = .present
  ) {
    self.url = url
    self.showType = showType
    super.init(nibName: nil, bundle: nil)
    self.title = title
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func loadView() {
    super.loadView()
    setupUI()
    switch self.showType {
    case .push:
      break
    case .present:
      setupNavigationBar()
    }
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    load()
  }
  
  // MARK: - private method
  
  private func setupUI() {
    webView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(webView)
    webView.fillSuperview()
  }
  
  private func load() {
    self.webView.load(URLRequest(url: url))
  }
  
  private func setupNavigationBar() {
    navigationItem.rightBarButtonItems = [self.closeButton]
  }
  
  @objc private func close() {
    self.dismiss(animated: true, completion: nil)
  }
  
  // MARK: - public method
  

  

}
