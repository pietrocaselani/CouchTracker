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

final class MovieDetailsPresenter: MovieDetailsPresenterOutput {

  private let disposeBag = DisposeBag()

  private weak var view: MovieDetailsView?
  private weak var router: MovieDetailsRouter?
  private let interactor: MovieDetailsInteractorInput
  private let movieId: String

  init(view: MovieDetailsView, router: MovieDetailsRouter, interactor: MovieDetailsInteractorInput, movieId: String) {
    self.view = view
    self.router = router
    self.interactor = interactor
    self.movieId = movieId
  }

  func viewDidLoad() {
    let dateFormatter = TraktDateTransformer.dateTransformer.dateFormatter

    let genresObservable = interactor.fetchGenres()
    let detailsObservable = interactor.fetchDetails(movieId: movieId)

    let map = detailsObservable.flatMap { movie -> Observable<MovieDetailsViewModel> in
      return genresObservable.flatMap { genres -> Observable<MovieDetailsViewModel> in
        let presentableGenres = movie.genres?.map { movieGenreSlug -> String in
          let genre = genres.first { genre in
            genre.slug == movieGenreSlug
          }
          return genre?.name ?? ""
        }.filter { genreName in
          return genreName.characters.count > 0
        } ?? [String]()

        let releaseDate = movie.released == nil ? "Unknown" : dateFormatter.string(from: movie.released!)

        let viewModel = MovieDetailsViewModel(
            title: movie.title ?? "TBA",
            tagline: movie.tagline ?? "",
            overview: movie.overview ?? "",
            genres: presentableGenres.joined(separator: " | "),
            releaseDate: releaseDate)

        return Observable.just(viewModel)
      }
    }

    map.observeOn(MainScheduler.instance)
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
}
