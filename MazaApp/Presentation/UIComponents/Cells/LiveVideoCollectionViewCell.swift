//
//  LiveVideoCollectionViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 16/02/25.
//

import UIKit
import AVFoundation
import SnapKit
import MarqueeLabel

class LiveVideoCollectionViewCell: BaseCollectionViewCell {

    // MARK: - Properties

    var playerView: VideoPlayerView!
    private(set) var isPlaying = false
    private(set) var liked = false

    let nameButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Agnes Triselia Yudia", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return btn
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "This is a caption label"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    private let musicIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "music.note")
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        return icon
    }()

    private let musicLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.text = "Music Music Music"
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        label.type = .continuous
        label.speed = .duration(8.0)
        label.fadeLength = 10.0
        label.trailingBuffer = 30.0
        return label
    }()

    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let followButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()

    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()

    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "678"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()

    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "captions.bubble.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()

    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.text = "678"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()

    private let shareCountLabel: UILabel = {
        let label = UILabel()
        label.text = "678"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()

    private let musicButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.note")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let pauseImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.fill")
        imageView.tintColor = .white
        imageView.alpha = 0
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            profileImage,
            followButton,
            likeButton,
            likeCountLabel,
            commentButton,
            commentCountLabel,
            shareButton,
            shareCountLabel,
            musicButton
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupUI()
        setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.makeRounded(color: .white, borderWidth: 1)
        followButton.makeRounded(color: .clear, borderWidth: 0)
        musicButton.makeRounded(color: .clear, borderWidth: 0)
        playerView.frame = contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        playerView.cancelAllLoadingRequest()
        resetViewsForReuse()
    }

    // MARK: - UI Setup

    private func setupUI() {
        playerView = VideoPlayerView(frame: contentView.bounds)
        contentView.addSubview(playerView)
        contentView.sendSubviewToBack(playerView)

        [nameButton, captionLabel, musicIcon, musicLabel, rightStackView, pauseImage].forEach {
            contentView.addSubview($0)
        }

        nameButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalTo(captionLabel.snp.top).offset(-4)
        }

        captionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalTo(musicIcon.snp.top).offset(-4)
            $0.trailing.lessThanOrEqualTo(rightStackView.snp.leading).offset(-8)
        }

        musicIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-24)
            $0.size.equalTo(20)
        }

        musicLabel.snp.makeConstraints {
            $0.leading.equalTo(musicIcon.snp.trailing).offset(8)
            $0.centerY.equalTo(musicIcon)
            $0.trailing.lessThanOrEqualTo(rightStackView.snp.leading).offset(-8)
        }

        rightStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
        }

        pauseImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 60, height: 60))
        }
    }

    private func setupGestures() {
        let pauseTap = UITapGestureRecognizer(target: self, action: #selector(handlePause))
        let doubleTapLike = UITapGestureRecognizer(target: self, action: #selector(handleLikeGesture(sender:)))
        doubleTapLike.numberOfTapsRequired = 2

        contentView.addGestureRecognizer(doubleTapLike)
        contentView.addGestureRecognizer(pauseTap)
        pauseTap.require(toFail: doubleTapLike)
    }

    // MARK: - Public Methods

    func configure(with videoURL: String) {
        guard let url = URL(string: videoURL) else { return }
        playerView.configure(url: url, fileExtension: "mp4", size: (9, 16))
    }

    func play() {
        if !isPlaying {
            playerView.play()
            musicLabel.holdScrolling = false
            isPlaying = true
        }
    }

    func pause() {
        if isPlaying {
            playerView.pause()
            musicLabel.holdScrolling = true
            isPlaying = false
        }
    }

    func replay() {
        playerView.replay()
        play()
    }

    func resetViewsForReuse() {
        likeButton.tintColor = .white
        pauseImage.alpha = 0
    }

    // MARK: - Actions

    @objc private func handlePause() {
        if isPlaying {
            UIView.animate(withDuration: 0.075, animations: {
                self.pauseImage.alpha = 0.35
                self.pauseImage.transform = CGAffineTransform(scaleX: 0.45, y: 0.45)
            }, completion: { _ in
                self.pause()
            })
        } else {
            UIView.animate(withDuration: 0.075, animations: {
                self.pauseImage.alpha = 0
                self.pauseImage.transform = .identity
            }, completion: { _ in
                self.play()
            })
        }
    }

    @objc private func handleLikeGesture(sender: UITapGestureRecognizer) {
        let location = sender.location(in: contentView)
        let heart = UIImageView(image: UIImage(systemName: "heart.fill"))
        heart.tintColor = .red
        heart.frame = CGRect(x: location.x - 55, y: location.y - 55, width: 110, height: 110)
        heart.contentMode = .scaleAspectFit
        heart.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: -0.4...0.4))
        contentView.addSubview(heart)

        UIView.animate(withDuration: 0.3, animations: {
            heart.transform = heart.transform.scaledBy(x: 0.85, y: 0.85)
        }) { _ in
            UIView.animate(withDuration: 0.4, delay: 0.1, animations: {
                heart.transform = heart.transform.scaledBy(x: 2.3, y: 2.3)
                heart.alpha = 0
            }, completion: { _ in heart.removeFromSuperview() })
        }

        liked = true
        likeButton.tintColor = .red
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Extensions
fileprivate extension NSObject {
    func apply(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}
