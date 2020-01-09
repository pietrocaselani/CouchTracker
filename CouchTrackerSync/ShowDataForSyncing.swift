struct ShowDataForSyncing: DataStruct {
  let progressShow: BaseShow
  let show: TraktSwift.Show
  let seasons: [Season]

  var showIds: ShowIds {
    return show.ids
  }

  // sourcery:inline:ShowDataForSyncing.TemplateName
  internal func copy(
    progressShow: CopyValue<BaseShow> = .same,
    show: CopyValue<TraktSwift.Show> = .same,
    seasons: CopyValue<[Season]> = .same
  ) -> ShowDataForSyncing {
    let newProgressShow: BaseShow = setValue(progressShow, self.progressShow)
    let newShow: TraktSwift.Show = setValue(show, self.show)
    let newSeasons: [Season] = setValue(seasons, self.seasons)

    return ShowDataForSyncing(progressShow: newProgressShow, show: newShow, seasons: newSeasons)
  }
  // sourcery:end
}
