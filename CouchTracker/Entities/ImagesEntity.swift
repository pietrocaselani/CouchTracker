struct ImagesEntity: Hashable {
	public let identifier: Int
	public let backdrops: [ImageEntity]
	public let posters: [ImageEntity]
	public let stills: [ImageEntity]

	func posterImage() -> ImageEntity? {
		return bestImage(of: posters)
	}

	func backdropImage() -> ImageEntity? {
		return bestImage(of: backdrops)
	}

	func stillImage() -> ImageEntity? {
		let x = bestImage(of: stills)
		return x
	}

	private func bestImage(of images: [ImageEntity]) -> ImageEntity? {
		return images.max(by: { (lhs, rhs) -> Bool in
			return lhs.isBest(then: rhs)
		})
	}

	var hashValue: Int {
		var hash = identifier.hashValue
		backdrops.forEach { hash = hash ^ $0.hashValue }
		posters.forEach { hash = hash ^ $0.hashValue }
		stills.forEach { hash = hash ^ $0.hashValue }
		return hash
	}

	static func == (lhs: ImagesEntity, rhs: ImagesEntity) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}

	static func empty() -> ImagesEntity {
		let imageEntities = [ImageEntity]()
		return ImagesEntity(identifier: -1, backdrops: imageEntities, posters: imageEntities, stills: imageEntities)
	}
}
