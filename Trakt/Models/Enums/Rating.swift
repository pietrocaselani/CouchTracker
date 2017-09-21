//
//  Rating.swift
//  Trakt
//
//  Created by Pietro Caselani on 23/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

public enum Rating: Int, Equatable {
	case weaksauce = 1
	case terrible = 2
	case bad = 3
	case poor = 4
	case meh = 5
	case fair = 6
	case good = 7
	case great = 8
	case superb = 9
	case totallyninja = 10
	
	public static func ==(lhs: Rating, rhs: Rating) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
}
