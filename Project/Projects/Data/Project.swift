import ProjectDescription
import ProjectDescriptionHelpers

let projectName: String = "Data"
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
      ),
      .project(
        target: "AppNetwork",
        path: "../AppNetwork"
      ),
    ],
    testDependencies: [
    ],
    coreDataModel: [],
    sampleAppAdditionalDependencies: [
      
    ],
    samplePlistPath: "SampleApp/Resources/SampleAppInfo.plist"
  ),
  schemes: [],
  additionalFiles: []
)
