import ProjectDescription
import ProjectDescriptionHelpers

let projectName: String = "Coordinator"
let project = Project(
  name: projectName,
  organizationName: Project.organizationName,
  packages: [],
  settings: .settings(),
  targets: Project.dynamicFrameworkTargets(
    name: projectName,
    destinations: .iOS,
    frameworkDependencies: [
      .project(
        target: "AppFoundation",
        path: "../AppFoundation"
      ),
      .project(
        target: "Domain",
        path: "../Domain"
      )
    ],
    testDependencies: [
    ],
    coreDataModel: []
  ),
  schemes: [],
  additionalFiles: []
)
