enum MoviesManagerOption: String {
  case trending
}

protocol MoviesManagerPresenter: class {
  init(view: MoviesManagerView, dataSource: MoviesManagerDataSource)

  func viewDidLoad()
}

protocol MoviesManagerView: class {
  var presenter: MoviesManagerPresenter! { get set }

  func show(pages: [MovieManagerModulePage], withDefault index: Int)
}

protocol MoviesManagerDataSource: class {
  var options: [MoviesManagerOption] { get }

  func modulePages() -> [MovieManagerModulePage]
  func defaultModuleIndex() -> Int
}

struct MovieManagerModulePage {
  let page: BaseView
  let title: String
}
