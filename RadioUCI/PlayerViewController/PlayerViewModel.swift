//
//  PlayerViewModel.swift
//  Radio UCI
//
//  Created by Annino De Petra on 09/04/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

import Foundation
import OSLog

protocol PlayerViewModelInterface {
	func fetchConfigFile()
	func fetchCurrentPlaying()
	func setNewPlayerStateIfNeeded(_ newPlayerState: PlayerViewModel.PlayerState)
	func togglePlayerState()
}

protocol PlayerViewModelDelegate: AnyObject {
	func propagate(initialisationState: PlayerViewModel.InitialisationState)
	func propagate(playerState: PlayerViewModel.PlayerState)
	func newTrackIsPlaying(artists: String?, songName: String?)
}

final class PlayerViewModel: PlayerViewModelInterface {
	enum InitialisationState {
		case initial
		case loading
		case loaded(Configuration)
	}

	enum PlayerState {
		case pause
		case playing

		mutating func toggle() {
			switch self {
			case .pause:
				self = .playing
			case .playing:
				self = .pause
			}
		}
	}

	private(set) var initialisationState: InitialisationState = .initial {
		didSet {
			delegate?.propagate(initialisationState: initialisationState)
		}
	}

	private(set) var playerState: PlayerState = .pause {
		didSet {
			delegate?.propagate(playerState: playerState)
		}
	}

	var currentSongFetcher: CurrentSongFetcherInterface
	private let configFileFetcher: ConfigFileFetcherInterface
	private let configFileURL: URL
	weak var delegate: PlayerViewModelDelegate?

	init(
		currentSongFetcher: CurrentSongFetcherInterface = CurrentSongFetcher(),
		configFileFetcher: ConfigFileFetcherInterface = ConfigFileFetcher(),
		configFileURL: URL = URL(string: "https://annino.dev/radiouciConfigV2.json")!
	) {
		self.currentSongFetcher = currentSongFetcher
		self.configFileFetcher = configFileFetcher
		self.configFileURL = configFileURL
	}

	func fetchConfigFile() {
		guard case .initial = initialisationState else {
			return
		}
		initialisationState = .loading
		configFileFetcher.fetchConfig(url: configFileURL) { [weak self] result in
			switch result {
			case .success(let configFile):
				self?.initialisationState = .loaded(configFile)
			case .failure(let error):
				os_log(.error, "Unable to fetch remote config file. Error: @s", error.localizedDescription)
				self?.initialisationState = .loaded(ConfigFile.default)
			}
		}
	}

	func fetchCurrentPlaying() {
		switch initialisationState {
		case .initial, .loading:
			return
		case .loaded(let configFile):			
			currentSongFetcher.set(
				radioServerURLString: configFile.serverURL,
				fetchingInterval: Double(configFile.fetchingIntervalSeconds)
			)

			currentSongFetcher.fetchCurrentSong { [weak self] result in
				guard case .success(let newSongName) = result else {
					return
				}

				let songAndArtistArray = newSongName.split(separator: "-")

				guard songAndArtistArray.count == 2 else {
					self?.delegate?.newTrackIsPlaying(artists: nil, songName: nil)
					return
				}

				let artistString = String(songAndArtistArray[0])
				let songString = String(songAndArtistArray[1])
				
				self?.delegate?.newTrackIsPlaying(
					artists: artistString.stringByDecodingHTMLEntities.capitalized,
					songName: songString.stringByDecodingHTMLEntities.capitalized
				)
			}
		}
	}

	func togglePlayerState() {
		playerState.toggle()
	}

	func setNewPlayerStateIfNeeded(_ newPlayerState: PlayerState) {
		guard newPlayerState != playerState else {
			return
		}

		togglePlayerState()
	}
}
