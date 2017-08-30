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
import Trakt_Swift

final class MovieDetailsiOSPresenter: MovieDetailsPresenter {

  private let disposeBag = DisposeBag()

  private weak var view: MovieDetailsView?
  private let interactor: MovieDetailsInteractor
  private let router: MovieDetailsRouter

  init(view: MovieDetailsView, interactor: MovieDetailsInteractor, router: MovieDetailsRouter) {
    self.view = view
    self.interactor = interactor
    self.router = router
  }

  func viewDidLoad() {
    let genresObservable = interactor.fetchGenres()
    let detailsObservable = interactor.fetchDetails()

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
          if let detailsError = error as? MovieDetailsError {
            self.router.showError(message: detailsError.message)
          } else {
            self.router.showError(message: error.localizedDescription)
          }
        }).disposed(by: disposeBag)
  }

  private func mapToViewModel(_ movie: Movie, _ genres: [String]) -> MovieDetailsViewModel {
    let releaseDate = movie.released?.parse() ?? "Unknown".localized

    return MovieDetailsViewModel(
        title: movie.title ?? "TBA".localized,
        tagline: movie.tagline ?? "",
        overview: movie.overview ?? "",
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
