//
//  ViewController.swift
//  CustomObservable
//
//  Created by hanwe on 5/27/24.
//

import UIKit
import UIComponents

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func commonWebViewAction(_ sender: Any) {
    let vc = CommonWebViewController(
      url: URL(string: "https://naver.com")!,
      title: "title"
    )
    self.present(vc, animated: true)
  }
  
  
}

