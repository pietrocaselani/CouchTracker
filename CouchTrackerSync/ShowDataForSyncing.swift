import TraktSwift

struct ShowDataForSyncing: DataStruct {
  let progressShow: BaseShow
  let show: TraktSwift.Show
  let seasons: [Season]

  var showIds: ShowIds {
    return show.ids
  }
}
