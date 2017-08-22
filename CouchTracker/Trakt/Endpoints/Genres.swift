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

import Moya

public enum Genres {
  case list(MediaType)
}

extension Genres: TraktType {

  public var path: String {
    switch self {
    case .list(let mediaType):
      return "genres/\(mediaType.rawValue)"
    }
  }

  public var parameters: [String: Any]? {
    return nil
  }

  public var sampleData: Data {
    // swiftlint:disable line_length
    return "[{\"name\":\"Action\",\"slug\":\"action\"},{\"name\":\"Adventure\",\"slug\":\"adventure\"},{\"name\":\"Animation\",\"slug\":\"animation\"},{\"name\":\"Anime\",\"slug\":\"anime\"},{\"name\":\"Comedy\",\"slug\":\"comedy\"},{\"name\":\"Crime\",\"slug\":\"crime\"},{\"name\":\"Disaster\",\"slug\":\"disaster\"},{\"name\":\"Documentary\",\"slug\":\"documentary\"},{\"name\":\"Drama\",\"slug\":\"drama\"},{\"name\":\"Eastern\",\"slug\":\"eastern\"},{\"name\":\"Family\",\"slug\":\"family\"},{\"name\":\"FanFilm\",\"slug\":\"fan-film\"},{\"name\":\"Fantasy\",\"slug\":\"fantasy\"},{\"name\":\"FilmNoir\",\"slug\":\"film-noir\"},{\"name\":\"History\",\"slug\":\"history\"},{\"name\":\"Holiday\",\"slug\":\"holiday\"},{\"name\":\"Horror\",\"slug\":\"horror\"},{\"name\":\"Indie\",\"slug\":\"indie\"},{\"name\":\"Music\",\"slug\":\"music\"},{\"name\":\"Musical\",\"slug\":\"musical\"},{\"name\":\"Mystery\",\"slug\":\"mystery\"},{\"name\":\"None\",\"slug\":\"none\"},{\"name\":\"Road\",\"slug\":\"road\"},{\"name\":\"Romance\",\"slug\":\"romance\"},{\"name\":\"ScienceFiction\",\"slug\":\"science-fiction\"},{\"name\":\"Short\",\"slug\":\"short\"},{\"name\":\"Sports\",\"slug\":\"sports\"},{\"name\":\"SportingEvent\",\"slug\":\"sporting-event\"},{\"name\":\"Suspense\",\"slug\":\"suspense\"},{\"name\":\"Thriller\",\"slug\":\"thriller\"},{\"name\":\"TvMovie\",\"slug\":\"tv-movie\"},{\"name\":\"War\",\"slug\":\"war\"},{\"name\":\"Western\",\"slug\":\"western\"}]".utf8Encoded
  }
}
