
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  name: "Search",
  frameworkDependencies: [
    .project(
      target: "AppFoundation",
      path: "../../AppFoundation"
    ),
    .project(
      target: "UIComponents",
      path: "../../UIComponents"
    ),
    .project(
      target: "Domain",
      path: "../../Domain"
    ),
    .project(
      target: "ImageLoader",
      path: "../../ImageLoader"
    ),
    .project(
      target: "Coordinator",
      path: "../../Coordinator"
    )
  ],
  testDependencies: []
)
