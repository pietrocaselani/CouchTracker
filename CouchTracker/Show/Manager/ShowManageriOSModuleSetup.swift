final class ShowManageriOSModuleSetup: ShowManagerModulesSetup {
  var options: [ShowManagerOption] {
    let overview = ShowManagerOption.overview
    let episode = ShowManagerOption.episode
    let seasons = ShowManagerOption.seasons

    return [overview, episode, seasons]
  }
}
