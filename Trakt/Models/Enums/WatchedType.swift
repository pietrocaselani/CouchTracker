//
//  WatchedType.swift
//  Trakt
//
//  Created by Pietro Caselani on 23/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

public enum WatchedType: String, Equatable {
	case movies = "movies"
	case shows = "shows"
	
	public static func ==(lhs: WatchedType, rhs: WatchedType) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
}
