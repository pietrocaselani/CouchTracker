//
//  Sync.swift
//  Trakt
//
//  Created by Pietro Caselani on 15/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Moya

public enum Sync {
	case watched(type: WatchedType, extended: Extended)
	case addToHistory(items: SyncItems)
	case removeFromHistory(items: SyncItems)
}

extension Sync: TraktType {
	public var path: String {
		switch self {
		case .watched(let type, _):
			return "/sync/watched/\(type.rawValue)"
		case .addToHistory:
			return "sync/history"
		case .removeFromHistory:
			return "/sync/history/remove"
		}
	}
	
	public var method: Moya.Method {
		switch self {
		case .addToHistory, .removeFromHistory:
			return .post
		default:
			return .get
		}
	}
	
	public var parameters: [String : Any]? {
		switch self {
		case .watched( _, let extended):
			return ["extended" : extended.rawValue]
		case .addToHistory(let items), .removeFromHistory(let items):
			return items.toJSON()
		}
	}
	
	public var parameterEncoding: ParameterEncoding {
		switch self {
		case .addToHistory, .removeFromHistory:
			return JSONEncoding.default
		default:
			return URLEncoding.default
		}
	}
	
	public var sampleData: Data {
		return "".utf8Encoded
	}
	
}
