
import ProjectDescription
import ProjectDescriptionHelpers

let projectName: String = "AppFoundation"
let project = Project(
  name: projectName,
  organizationName: Project.organizationName,
  packages: [],
  settings: Settings.settings(),
  targets: Project.dynamicFrameworkTargets(
    name: projectName,
    destinations: .iOS,
    frameworkDependencies: [
    ],
    testDependencies: [
    ],
    coreDataModel: []
  ),
  schemes: [],
  additionalFiles: []
)
