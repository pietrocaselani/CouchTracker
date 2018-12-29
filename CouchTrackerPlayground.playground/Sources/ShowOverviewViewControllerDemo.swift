import UIKit
import CouchTrackerApp

public final class ShowOverviewViewControllerDemo: UIViewController {
    private var showView: ShowOverviewView {
        guard let showView = self.view as? ShowOverviewView else {
            preconditionFailure("self.view should be an instance of ShowOverviewView")
        }

        return showView
    }

    public override func loadView() {
        view = ShowOverviewView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        vikings()
    }

    private func vikings() {
        let posterLink = "https://image.tmdb.org/t/p/w342/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg"
        let backdropLink = "https://image.tmdb.org/t/p/w780/A30ZqEoDbchvE7mCZcSp6TEwB1Q.jpg"

        showView.posterImageView.kf.setImage(with: URL(string: posterLink))
        showView.backdropImageView.kf.setImage(with: URL(string: backdropLink))
        showView.titleLabel.text = "Vikings"
        showView.networkLabel.text = "Showtime"
        showView.statusLabel.text = "Em exibição"
        showView.genresLabel.text = "Drama | Action | Crime | Adventure | War | Mystery"
        showView.releaseDateLabel.text = "10/01/2011"
        showView.overviewLabel.text = "History sees the Vikings as a band of bloodthirsty pirates, raiding peaceful Christian monasteries... and it's true. The vikings took no prisoners, relished cruel retribution and prided themselves as fierce warriors. But their Prowess in battle is only the start of the story. Going on the trail of the real Vikings this series reveals an extraordinary story of a people who, from the brink of destruction, built an empire reaching around a qarter of the globe. Where did they come from? How did they really live? And what drove them to embark on such extraordinary voyages of discovery? Neil Oliver goes beyond their bloody reputation, from Iceland to Instanbul, to search for the truth about the Vikings."
    }

    private func homeland() {
        let posterLink = "https://image.tmdb.org/t/p/w342/vigxiGD6KWEeRIknmsqV460hG6a.jpg"
        let backdropLink = "https://image.tmdb.org/t/p/w780/hTxfw4af6EizpLM7tHKtoSlbdnu.jpg"

        showView.posterImageView.kf.setImage(with: URL(string: posterLink))
        showView.backdropImageView.kf.setImage(with: URL(string: backdropLink))
        showView.titleLabel.text = "Homeland"
        showView.networkLabel.text = "Showtime"
        showView.statusLabel.text = "Em exibição"
        showView.genresLabel.text = "Drama | Action | Crime | Adventure | War | Mystery"
        showView.releaseDateLabel.text = "10/01/2011"
        showView.overviewLabel.text = "A bipolar CIA operative becomes convinced a prisoner of war has been turned by al-Qaeda and is planning to carry out a terrorist attack on American soil."
    }

    private func sonsOfAnarchy() {
        let posterLink = "https://image.tmdb.org/t/p/w342/2qg0MOwPD1G0FcYpDPeu6AOjh8i.jpg"
        let backdropLink = "https://image.tmdb.org/t/p/w780/fZ8j6F8dxZPA8wE5sGS9oiKzXzM.jpg"

        showView.posterImageView.kf.setImage(with: URL(string: posterLink))
        showView.backdropImageView.kf.setImage(with: URL(string: backdropLink))
        showView.titleLabel.text = "Sons of Anarchy"
        showView.networkLabel.text = "FX (US)"
        showView.statusLabel.text = "Finalizada"
        showView.genresLabel.text = "Drama | Crime | Thriller"
        showView.releaseDateLabel.text = "02/09/2008"
        showView.overviewLabel.text = "Sons of Anarchy is an adrenalized drama with darkly comedic undertones that explores a notorious outlaw motorcycle club’s (MC) desire to protect its livelihood while ensuring that their simple, sheltered town of Charming, California remains exactly that, charming. The MC must confront threats from drug dealers, corporate developers, and overzealous law officers. Behind the MC’s familial lifestyle and legally thriving automotive shop is a ruthless and illegal arms business driven by the seduction of money, power, and blood."
    }
}

