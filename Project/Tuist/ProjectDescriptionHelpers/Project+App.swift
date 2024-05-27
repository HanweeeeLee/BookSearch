//
//  Project+App.swift
//  ProjectDescriptionHelpers
//
//  Created by hanwe on 5/27/24.
//

import ProjectDescription

extension Project {
  /// Helper function to create the Project for this ExampleApp
  public static func app(
    name: String,
    bundleAppName: String? = nil,
    destinations: Destinations,
    dependencies: [TargetDependency],
    testDependencies: [TargetDependency] = [],
    additionalTargets: [String],
    additionalSourcePaths: [String],
    additionalResourcePaths: [String]
  ) -> Project {
    
    let targets = makeAppTargets(
      name: name,
      bundleAppName: bundleAppName,
      destinations: destinations,
      dependencies: dependencies,
      testDependencies: testDependencies,
      additionalSourcePaths: additionalSourcePaths,
      additionalResourcePaths: additionalResourcePaths
    )
    
    return Project(
      name: name,
      organizationName: Project.organizationName,
      settings: Settings.settings(),
      targets: targets,
      resourceSynthesizers: [
        .assets()
      ]
    )
  }
  
  // MARK: - Private
  
  /// Helper function to create the application target and the unit test target.
  private static func makeAppTargets(
    name: String,
    bundleAppName: String? = nil,
    destinations: Destinations,
    dependencies: [TargetDependency],
    testDependencies: [TargetDependency] = [],
    additionalSourcePaths: [String],
    additionalResourcePaths: [String]
  ) -> [Target] {
    let destinations: Destinations = destinations
    
    let targetScripts: [TargetScript] = {
      var returnValue: [TargetScript] = []
      
      return returnValue
    }()
    
    let willSetResourcePath: ResourceFileElements = {
      var resourceFileElementList: [ProjectDescription.ResourceFileElement] = additionalResourcePaths.map {
        .init(stringLiteral: $0)
      }
      resourceFileElementList.append("Resources/**")
      return .init(resources: resourceFileElementList)
    }()
    let mainTarget = Target(
      name: name,
      destinations: destinations,
      product: .app,
      bundleId: "\(Project.bundleNamePrefix).\(bundleAppName ?? name)",
      deploymentTargets: Project.developmentTarget,
      infoPlist: .file(path: "./InfoPlist/Info.plist"),
      sources: ["Sources/**"],
      resources: willSetResourcePath,
      scripts: targetScripts,
      dependencies: dependencies
    )
    
    var testDependencies = testDependencies
    testDependencies.append(.target(name: "\(name)"))
    let testTarget = Target(
      name: "\(name)Tests",
      destinations: destinations,
      product: .unitTests,
      bundleId: "\(Project.bundleNamePrefix).\(name)Tests",
      infoPlist: .default,
      sources: ["../\(name)/Tests/**"],
      dependencies: testDependencies
    )
    return [mainTarget, testTarget]
  }
}
