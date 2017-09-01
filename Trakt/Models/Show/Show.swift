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

import Foundation
import ObjectMapper

public final class Show: StandardMediaEntity {
  public let year: Int
  public let ids: ShowIds
  public let firstAired: Date?
  public let airs: Airs?
  public let runtime: Int?
  public let certification: String?
  public let network: String?
  public let country: String?
  public let trailer: String?
  public let homepage: String?
  public let status: Status?
  public let language: String?
  public let genres: [String]?
  
  public required init(map: Map) throws {
    self.year = try map.value("year")
    self.ids = try map.value("ids")
    self.firstAired = try? map.value("first_aired", using: TraktDateTransformer.dateTimeTransformer)
    self.airs = try? map.value("airs")
    self.runtime = try? map.value("runtime")
    self.certification = try? map.value("certification")
    self.network = try? map.value("network")
    self.country = try? map.value("country")
    self.trailer = try? map.value("trailer")
    self.homepage = try? map.value("homepage")
    self.status = try? map.value("status")
    self.language = try? map.value("language")
    self.genres = try? map.value("genres")
    
    try super.init(map: map)
  }
  
  public override var hashValue: Int {
    var hash = super.hashValue ^ year.hashValue ^ ids.hashValue
    
    if let firstAiredHash = firstAired?.hashValue {
      hash = hash ^ firstAiredHash
    }
    
    if let airsHash = airs?.hashValue {
      hash = hash ^ airsHash
    }
    
    if let runtimeHash = runtime?.hashValue {
      hash = hash ^ runtimeHash
    }
    
    if let certificationHash = certification?.hashValue {
      hash = hash ^ certificationHash
    }
    
    if let networkHash = network?.hashValue {
      hash = hash ^ networkHash
    }
    
    if let countryHash = country?.hashValue {
      hash = hash ^ countryHash
    }
    
    if let trailerHash = trailer?.hashValue {
      hash = hash ^ trailerHash
    }
    
    if let homepageHash = homepage?.hashValue {
      hash = hash ^ homepageHash
    }
    
    if let statusHash = status?.hashValue {
      hash = hash ^ statusHash
    }
    
    if let languageHash = language?.hashValue {
      hash = hash ^ languageHash
    }
    
    genres?.forEach { hash = hash ^ $0.hashValue }
    
    return hash
  }
}
