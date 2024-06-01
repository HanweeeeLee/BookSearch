//
//  Proejct+Framework.swift
//  ProjectDescriptionHelpers
//
//  Created by hanwe on 5/27/24.
//

import ProjectDescription

extension Project {
  
  public static func staticFrameworkTargets(
    name: String,
    destinations: Destinations,
    frameworkDependencies: [TargetDependency],
    testDependencies: [TargetDependency],
    targetScripts: [TargetScript] = [],
    coreDataModel: [CoreDataModel],
    resources: ResourceFileElements = ["Resources/**"],
    sampleAppAdditionalDependencies: [TargetDependency] = [],
    samplePlistPath: Path? = nil,
    additionalSourcePaths: [String] = []
  ) -> [Target] {
    return Project.frameworkTargets(
      name: name,
      destinations: destinations,
      frameworkDependencies: frameworkDependencies,
      testDependencies: testDependencies,
      targetScripts: targetScripts,
      coreDataModel: coreDataModel,
      resources: resources,
      sampleAppAdditionalDependencies: sampleAppAdditionalDependencies,
      samplePlistPath: samplePlistPath,
      additionalSourcePaths: additionalSourcePaths,
      product: .staticFramework
    )
  }
  
  public static func dynamicFrameworkTargets(
    name: String,
    destinations: Destinations,
    frameworkDependencies: [TargetDependency],
    testDependencies: [TargetDependency],
    targetScripts: [TargetScript] = [],
    coreDataModel: [CoreDataModel],
    resources: ResourceFileElements = ["Resources/**"],
    sampleAppAdditionalDependencies: [TargetDependency] = [],
    samplePlistPath: Path? = nil,
    additionalSourcePaths: [String] = []
  ) -> [Target] {
    return Project.frameworkTargets(
      name: name,
      destinations: destinations,
      frameworkDependencies: frameworkDependencies,
      testDependencies: testDependencies,
      targetScripts: targetScripts,
      coreDataModel: coreDataModel,
      resources: resources,
      sampleAppAdditionalDependencies: sampleAppAdditionalDependencies,
      samplePlistPath: samplePlistPath,
      additionalSourcePaths: additionalSourcePaths,
      product: .framework
    )
  }
  
  fileprivate static func frameworkTargets(
    name: String,
    destinations: Destinations,
    frameworkDependencies: [TargetDependency],
    testDependencies: [TargetDependency],
    targetScripts: [TargetScript],
    coreDataModel: [CoreDataModel],
    resources: ResourceFileElements,
    sampleAppAdditionalDependencies: [TargetDependency],
    samplePlistPath: Path?,
    additionalSourcePaths: [String],
    product: Product
  ) -> [Target] {
    
    let sourcesPath: SourceFilesList = {
      let globs: [SourceFileGlob] = {
        var returnValue: [SourceFileGlob] = ["Sources/**"]
        for item in additionalSourcePaths {
          returnValue.append(.glob(
            Path(item)
          ))
        }
        return returnValue
      }()
      return SourceFilesList(globs: globs)
    }()
    
    let sources = Target(
      name: name,
      destinations: destinations,
      product: .framework,
      bundleId: "\(Project.bundleNamePrefix).\(name)",
      deploymentTargets: Project.developmentTarget,
      infoPlist: .default,
      sources: sourcesPath,
      resources: resources,
      scripts: targetScripts,
      dependencies: frameworkDependencies,
      coreDataModels: coreDataModel
    )
    
    let testHostApp = Target(
      name: "\(name)TestHost",
      destinations: destinations,
      product: .app,
      bundleId: "\(Project.bundleNamePrefix).\(name)TestHost",
      deploymentTargets: Project.developmentTarget,
      infoPlist: .default,
      sources: ["TestHost/Sources/**"],
      resources: ["TestHost/Resources/**"],
      dependencies: [.target(name: name)]
    )
    
    let sampleAppInfoPlist: ProjectDescription.InfoPlist = {
      if let samplePlistPath {
        return .file(path: samplePlistPath)
      } else {
        return .default
      }
    }()
    let sampleApp = Target(
      name: "\(name)SampleApp",
      destinations: destinations,
      product: .app,
      bundleId: "\(Project.bundleNamePrefix).\(name)SampleApp",
      deploymentTargets: Project.developmentTarget,
      infoPlist: sampleAppInfoPlist,
      sources: ["SampleApp/Sources/**"],
      resources: ["SampleApp/Resources/**"],
      dependencies: [.target(name: name)] + sampleAppAdditionalDependencies
    )
    
    let tests = Target(
      name: "\(name)Tests",
      destinations: destinations,
      product: .unitTests,
      bundleId: "\(Project.bundleNamePrefix).\(name)tests",
      deploymentTargets: Project.developmentTarget,
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [.target(name: name), .target(name: "\(name)TestHost")] + testDependencies
    )
    
    return [sources, testHostApp, tests, sampleApp]
  }
  
}
