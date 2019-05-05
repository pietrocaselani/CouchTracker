import PlaygroundSupport
import UIKit

import CouchTrackerApp
import CouchTrackerCore
import TraktSwift
import TMDBSwift
import TVDBSwift
import Kingfisher
import SnapKit
import RxSwift

class ColorsView: CouchTrackerApp.View {
    public lazy var label1: UILabel = {
        let label = UILabel()
        label.text = "ctdarkerBunker"
        label.backgroundColor = UIColor(red: 0.1764705926, green: 0.1764705926, blue: 0.1764705926, alpha: 1.0000000000)
        return label
    }()

    public lazy var label2: UILabel = {
        let label = UILabel()
        label.text = "ctbunker"
        label.backgroundColor = UIColor(red: 0.1725489944, green: 0.1725489944, blue: 0.1725489944, alpha: 1.0000000000)
        return label
    }()

    public lazy var label3: UILabel = {
        let label = UILabel()
        label.text = "ctzircon"
        label.backgroundColor = UIColor(red: 0.8823528886, green: 0.8823528886, blue: 0.8823528886, alpha: 1.0000000000)
        return label
    }()

    public lazy var label4: UILabel = {
        let label = UILabel()
        label.text = "ctblack"
        label.backgroundColor = UIColor(red: 0.1333332956, green: 0.1333332956, blue: 0.1333332956, alpha: 1.0000000000)
        return label
    }()

    public lazy var label5: UILabel = {
        let label = UILabel()
        label.text = "ctjaguar"
        label.backgroundColor = UIColor(red: 0.1647059023, green: 0.1647059023, blue: 0.1647059023, alpha: 1.0000000000)
        return label
    }()

    public lazy var label6: UILabel = {
        let label = UILabel()
        label.text = "ctconcord"
        label.backgroundColor = UIColor(red: 0.4862745106, green: 0.4862745106, blue: 0.4862745106, alpha: 1.0000000000)
        return label
    }()

    public lazy var label7: UILabel = {
        let label = UILabel()
        label.text = "ctfog"
        label.backgroundColor = UIColor(red: 0.8274509907, green: 0.7960783839, blue: 0.8941177130, alpha: 1.0000000000)
        return label
    }()

    public lazy var stackview: UIStackView = {
        let subviews = [label1, label2, label3, label4, label5, label6, label7]
        let stackView = UIStackView(arrangedSubviews: subviews)

        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        return stackView
    }()

    override func initialize() {
        addSubview(stackview)
    }

    override func installConstraints() {
//        constrain(stackview) { contentView in
//            contentView.size == contentView.superview!.size
//        }
    }
}

public class ColorsViewController: UIViewController {
    public override func loadView() {
        view = ColorsView()
    }
}
