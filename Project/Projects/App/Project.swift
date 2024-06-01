
import ProjectDescription
import ProjectDescriptionHelpers

let projectName: String = "App"

let project = Project.app(
  name: projectName,
  bundleAppName: projectName,
  destinations: .iOS,
  dependencies: [
    .project(
      target: "AppFoundation",
      path: "../AppFoundation"
    ),
    .project(
      target: "Coordinator",
      path: "../Coordinator"
    ),
    .project(
      target: "Data",
      path: "../Data"
    ),
    .project(
      target: "Detail",
      path: "../Feature/Detail"
    ),
    .project(
      target: "Search",
      path: "../Feature/Search"
    )
  ],
  testDependencies: [],
  additionalTargets: [],
  additionalSourcePaths: [],
  additionalResourcePaths: []
)
