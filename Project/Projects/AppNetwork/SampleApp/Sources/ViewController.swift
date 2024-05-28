//
//  ViewController.swift
//  CustomObservable
//
//  Created by hanwe on 5/27/24.
//

import UIKit
import AppNetwork

class ViewController: UIViewController {
  
  struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
  }
  
  struct NewPost {
    let title: String
    let body: String
    let userId: Int
  }
  
  struct CreatedPostResponse: Decodable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func getAction(_ sender: Any) {
    Task {
      let target = JSONPlaceholderAPI.getPost(id: 1)
      let result: Result<Post, NetworkManager.NetworkError> = await NetworkManager.shared.requestData(target: target)
      
      switch result {
      case .success(let post):
        print("Post title: \(post.title)")
        print("Post body: \(post.body)")
      case .failure(let error):
        print("Error: \(error)")
      }
    }
  }
  
  @IBAction func postAction(_ sender: Any) {
    
    Task {
      let target = JSONPlaceholderAPI.createPost(title: "Sample Title", body: "This is the body of the post.", userId: 1)
      let result: Result<CreatedPostResponse, NetworkManager.NetworkError> = await NetworkManager.shared.requestData(target: target)
      
      switch result {
      case .success(let createdPost):
        print("New post created with ID: \(createdPost.id)")
        print("Title: \(createdPost.title)")
        print("Body: \(createdPost.body)")
      case .failure(let error):
        print("Error: \(error)")
      }
    }
  }
}

enum JSONPlaceholderAPI {
  case getPost(id: Int)
  case createPost(title: String, body: String, userId: Int)
}

extension JSONPlaceholderAPI: TargetType {
  var baseURL: URL {
    return URL(string: "https://jsonplaceholder.typicode.com")!
  }
  
  var path: String {
    switch self {
    case .getPost(let id):
      return "/posts/\(id)"
    case .createPost:
      return "/posts"
    }
  }
  
  var method: NetworkManager.HTTPMethod {
    switch self {
    case .getPost:
      return .get
    case .createPost:
      return .post
    }
  }
  
  var task: NetworkManager.Task {
    switch self {
    case .getPost:
      return .requestPlain
    case .createPost(let title, let body, let userId):
      return .requestParameters(parameters: [
        "title": title,
        "body": body,
        "userId": userId
      ])
    }
  }
  
  var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
}
