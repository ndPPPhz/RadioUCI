//
//  PlayerViewController.swift
//  RadioUci
//
//  Created by Annino De Petra on 15/03/2018.
//  Copyright © 2018 Annino De Petra. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import OSLog

final class PlayerViewController: UIViewController {
	@IBOutlet private var artistLabel: UILabel!
	@IBOutlet private var songLabel: UILabel!
	@IBOutlet private var playerButton: PlayerButton! {
		didSet {
			setupPlayerButton()
		}
	}
	@IBOutlet private var volumeViewContainer: UIView! {
		didSet {
			setupVolumeView()
		}
	}

	private let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
	private let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()

	private var playerController: AVPlayer?
	private var configFile: Configuration?
	weak var radioUCICoordinator: RadioUCICoordinatorInterface?

	private lazy var playerViewModel: PlayerViewModelInterface = {
		let playerViewModel = PlayerViewModel()
		playerViewModel.delegate = self
		return playerViewModel
	}()

	private let volumeView: MPVolumeView = {
		let view = MPVolumeView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.showsRouteButton = false
		return view
	}()

	private var defaultCommandCenterDictionary: [String: Any] {
		guard
			let configFile = configFile,
			let artworkImage = UIImage(named: "uciArtwork")
		else {
			return [:]
		}

		let dictionary: [String : Any] = [
			MPMediaItemPropertyTitle: configFile.title,
			MPMediaItemPropertyArtist: configFile.description,
			MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: artworkImage.size, requestHandler: { size -> UIImage in
				return artworkImage
			})
		]
		return dictionary
	}

	// MARK: - Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		setupBarButtonItem()
		playerViewModel.fetchConfigFile()
	}

	private func setupBarButtonItem() {
		let barButtonItem = UIBarButtonItem(title: "Contatti", style: .plain, target: self, action: #selector(contactsButtonTapped))
		let font = UIFont.systemFont(ofSize: 16, weight: .light)
		barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
		navigationItem.rightBarButtonItem = barButtonItem
	}

	private func setupPlayerButton() {
		guard
			let playImage: UIImage = UIImage(named: "PlayButton"),
			let pauseImage: UIImage = UIImage(named: "PauseButton")
		else {
			return
		}

		playerButton.configure(with: PlayerButton.ViewData(playImage: playImage, pauseImage: pauseImage))
	}

	private func startBackgroundActivity() {
		do {
			try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: AVAudioSession.Mode.moviePlayback)
			try audioSession.setActive(true)
			UIApplication.shared.beginReceivingRemoteControlEvents()
			setupCommandCenter(dictionary: defaultCommandCenterDictionary)
		} catch {
			os_log(.info, "Start background activity failed to launch, error: %s", error.localizedDescription)
		}
	}

	private func setupVolumeView() {
		volumeViewContainer.addSubview(volumeView)
		volumeView.widthAnchor.constraint(equalTo: volumeViewContainer.widthAnchor).isActive = true
		volumeView.heightAnchor.constraint(equalToConstant: 31).isActive = true
		volumeView.centerXAnchor.constraint(equalTo: volumeViewContainer.centerXAnchor).isActive = true
		volumeView.centerYAnchor.constraint(equalTo: volumeViewContainer.centerYAnchor).isActive = true
	}

	@objc private func contactsButtonTapped(_ sender: UIBarButtonItem) {
		let shareOptions = configFile?.share ?? []
		radioUCICoordinator?.showContactsSheet(shareOptions: shareOptions)
	}

	private func setupCommandCenter(dictionary: [String: Any]) {
		nowPlayingInfoCenter.nowPlayingInfo = dictionary

		let commandCenter = MPRemoteCommandCenter.shared()
		commandCenter.playCommand.isEnabled = true
		commandCenter.pauseCommand.isEnabled = true
		commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
			self?.playerViewModel.setNewPlayerStateIfNeeded(.playing)
			return .success
		}
		commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
			self?.playerViewModel.setNewPlayerStateIfNeeded(.pause)
			return .success
		}

		commandCenter.stopCommand.addTarget{ [weak self] (event) -> MPRemoteCommandHandlerStatus in
			self?.playerViewModel.setNewPlayerStateIfNeeded(.pause)
			return .success
		}
	}

	@IBAction private func playButtonPressed() {
		playerViewModel.togglePlayerState()
	}
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}

extension PlayerViewController: PlayerViewModelDelegate {
	func propagate(initialisationState: PlayerViewModel.InitialisationState) {
		switch initialisationState {
		case .initial:
			return
		case .loading:
			// show spinnign indicator
			return
		case .loaded(let configFile):
			guard let streamURL = URL(string: configFile.radioURL) else {
				// Show error popup
				return
			}
			self.configFile = configFile
			startBackgroundActivity()

			playerController = AVPlayer(url: streamURL)
			playerViewModel.fetchCurrentPlaying()
		}
	}

	func propagate(playerState: PlayerViewModel.PlayerState) {
		switch playerState {
		case .playing:
			playerController?.play()
			playerButton.setAppearance(.pause)
		case .pause:
			playerController?.pause()
			playerButton.setAppearance(.play)
		}
	}

	func newTrackIsPlaying(artists: String?, songName: String?) {
		guard
			let artists = artists,
			let songName = songName
		else {
			updateCurrentInfo(title: ConfigFile.default.title, description: ConfigFile.default.description)
			return
		}
		updateCurrentInfo(title: artists, description: songName)
	}

	private func updateCurrentInfo(title: String, description: String) {
		artistLabel.text = title
		songLabel.text = description

		var defaultDictionaryCopy = defaultCommandCenterDictionary
		defaultDictionaryCopy[MPMediaItemPropertyArtist] = description
		defaultDictionaryCopy[MPMediaItemPropertyTitle] = title
		nowPlayingInfoCenter.nowPlayingInfo = defaultDictionaryCopy
	}
}
