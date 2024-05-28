import ProjectDescription
import ProjectDescriptionHelpers

let projectName: String = "ImageLoader"
let project = Project(
  name: projectName,
  organizationName: Project.organizationName,
  packages: [],
  settings: Settings.settings(),
  targets: Project.dynamicFrameworkTargets(
    name: projectName,
    destinations: .iOS,
    frameworkDependencies: [
      .project(
        target: "AppFoundation",
        path: "../AppFoundation"
      )
    ],
    testDependencies: [
    ],
    coreDataModel: [],
    samplePlistPath: "SampleApp/Resources/SampleAppInfo.plist"
  ),
  schemes: [],
  additionalFiles: []
)
