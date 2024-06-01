import ProjectDescription
import ProjectDescriptionHelpers

let projectName: String = "Domain"
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
    coreDataModel: []
  ),
  schemes: [],
  additionalFiles: []
)
