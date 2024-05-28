//
//  Project+Extension.swift
//  ProjectDescriptionHelpers
//
//  Created by hanwe on 5/27/24.
//

import ProjectDescription
import Foundation

extension Project {
  
  public static var organizationName: String {
    return "Hanwe Lee"
  }
  
  public static var bundleNamePrefix: String {
    return "com.hanwe"
  }
  
  public static var developmentTarget: DeploymentTargets {
    return .iOS("17.0")
  }
  
  public static func currentDirectoryPath() -> String {
    let fileManager = FileManager.default
    let currentPath = fileManager.currentDirectoryPath
    return currentPath
  }
  
  public static func subDirectoryNameList(path: String) -> [String] {
    let fileManager = FileManager.default
    let currentPath = path
    
    do {
      let contents = try fileManager.contentsOfDirectory(atPath: currentPath)
      var subdirectories: [String] = []
      
      for item in contents {
        var isDirectory: ObjCBool = false
        let itemPath = (currentPath as NSString).appendingPathComponent(item)
        
        if fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory) && isDirectory.boolValue {
          subdirectories.append(item)
        }
      }
      
      return subdirectories
    } catch {
      print("디렉토리 내용을 읽어오는 데 실패했습니다: \(error)")
      return []
    }
  }
  
}
