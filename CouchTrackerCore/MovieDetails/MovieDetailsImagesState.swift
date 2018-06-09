public enum MovieDetailsImagesState {
	case loading
	case showing(images: ImagesViewModel)
	case error(error: Error)
}
