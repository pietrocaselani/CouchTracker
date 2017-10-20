final class ShowsManageriOSModuleSetup: ShowsManagerModulesSetup {
  var options: [ShowsManagerOption] {
    let progress = ShowsManagerOption.progress
    let now = ShowsManagerOption.now

    return [progress, now]
  }
}
