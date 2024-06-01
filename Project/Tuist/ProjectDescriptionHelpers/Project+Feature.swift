//
//  Project+Feature.swift
//  ProjectDescriptionHelpers
//
//  Created by hanwe on 5/27/24.
//

import ProjectDescription

extension Project {
  
  public static func makeFeature(
    name: String,
    frameworkDependencies: [TargetDependency],
    testDependencies: [TargetDependency]
  ) -> Project {
    return Project(
      name: name,
      organizationName: Project.organizationName,
      packages: [],
      targets: Project.dynamicFrameworkTargets(
        name: name,
        destinations: .iOS,
        frameworkDependencies: frameworkDependencies,
        testDependencies: testDependencies,
        targetScripts: [
        ],
        coreDataModel: [],
        resources: ["Resources/**"],
        samplePlistPath: "SampleApp/Resources/SampleAppInfo.plist",
        additionalSourcePaths: []
      ),
      schemes: [],
      additionalFiles: [],
      resourceSynthesizers: []
    )
  }
  
}
