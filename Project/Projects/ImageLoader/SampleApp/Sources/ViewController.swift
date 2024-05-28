//
//  ViewController.swift
//  CustomObservable
//
//  Created by hanwe on 5/27/24.
//

import UIKit
import ImageLoader

class ViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let imageURL = URL(string: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&h=500")!
    imageView.setImage(from: imageURL)
  }


}

