/*
Copyright 2017 ArcTouch LLC.
All rights reserved.
 
This file, its contents, concepts, methods, behavior, and operation
(collectively the "Software") are protected by trade secret, patent,
and copyright laws. The use of the Software is governed by a license
agreement. Disclosure of the Software to third parties, in any form,
in whole or in part, is expressly prohibited except as authorized by
the license agreement.
*/

import RxSwift
import Foundation

final class MovieDetailsPresenter: MovieDetailsPresenterLayer {

  private let disposeBag = DisposeBag()

  private weak var view: MovieDetailsView?
  private let interactor: MovieDetailsInteractorLayer
  private let movieId: String

  init(view: MovieDetailsView, interactor: MovieDetailsInteractorLayer, movieId: String) {
    self.view = view
    self.interactor = interactor
    self.movieId = movieId
  }

  func viewDidLoad() {
    let genresObservable = interactor.fetchGenres()
    let detailsObservable = interactor.fetchDetails(movieId: movieId)

    detailsObservable.flatMap { movie -> Observable<MovieDetailsViewModel> in
          return genresObservable.flatMap { [unowned self] genres -> Observable<MovieDetailsViewModel> in
            let presentableGenres = self.map(genres: genres, for: movie)

            let viewModel = self.mapToViewModel(movie, presentableGenres)

            return Observable.just(viewModel)
          }
        }.observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] viewModel in
          self.view?.show(details: viewModel)
        }, onError: { [unowned self] error in
          guard let view = self.view else {
            return
          }

          if let detailsError = error as? MovieDetailsError {
            view.show(error: detailsError.message)
          } else {
            view.show(error: error.localizedDescription)
          }
        }).disposed(by: disposeBag)
  }

  private func mapToViewModel(_ movie: Movie, _ genres: [String]) -> MovieDetailsViewModel {
    let releaseDate = movie.released?.parse() ?? "Unknown"

    return MovieDetailsViewModel(
        title: movie.title ?? "TBA",
        tagline: movie.tagline ?? "",
        overview: movie.tagline ?? "",
        genres: genres.joined(separator: " | "),
        releaseDate: releaseDate)
  }

  private func map(genres: [Genre], for movie: Movie) -> [String] {
    return movie.genres?.map { movieGenreSlug -> String in
      let genre = genres.first { genre in
        genre.slug == movieGenreSlug
      }
      return genre?.name ?? ""
    }.filter { genreName in
      return genreName.characters.count > 0
    } ?? [String]()
  }
}
