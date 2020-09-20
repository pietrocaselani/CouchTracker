import UIKit

func posterAndTitleCellSize(
    for viewWidth: CGFloat = UIScreen.main.bounds.width,
    horizontalSpacing: CGFloat = 10
) -> CGSize {
    let defaultHeight: CGFloat = 180
    let defaultWidth: CGFloat = 100

    let width = (viewWidth / 3) - horizontalSpacing

    let height = defaultHeight * width / defaultWidth

    return CGSize(width: width, height: height)
  }
