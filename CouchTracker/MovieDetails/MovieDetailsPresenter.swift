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

    interactor.fetchDetails(movieId: movieId)
        .map { movie -> MovieDetailsViewModel in
          let releaseDate = movie.released == nil ? "Unknown" : dateFormatter.string(from: movie.released!)

          return MovieDetailsViewModel(
              title: movie.title ?? "TBA",
              tagline: movie.tagline ?? "",
              overview: movie.tagline ?? "",
              genres: movie.genres ?? [String](),
              releaseDate: releaseDate)
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
}
