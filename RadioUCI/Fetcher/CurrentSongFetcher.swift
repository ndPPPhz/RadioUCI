//
//  CurrentSongFetcher.swift
//  Radio UCI
//
//  Created by Annino De Petra on 09/04/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

import Foundation

protocol CurrentSongFetcherInterface {
	func fetchCurrentSong(completion: @escaping (Result<String, Error>) -> Void)
	func set(radioServerURLString: String, fetchingInterval: Double)
}

final class CurrentSongFetcher: CurrentSongFetcherInterface {
	private struct ServerInfo: Decodable {
		var currentSong: String

		enum CodingKeys: String, CodingKey {
			case icestats
			case source
			case title
		}

		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			let iceStatsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .icestats)
			let sourceContainer = try iceStatsContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .source)
			self.currentSong = try sourceContainer.decode(String.self, forKey: .title)
		}
	}

	enum FetcherError: Error {
		case invalidURL
		case internalError
	}

	private var radioServerURLString: String?
	private var fetchingInterval: Double?

	private let session: URLSession
	private var timer: Timer?

	init(
		session: URLSession = .shared
	) {
		self.session = session
	}

	func set(radioServerURLString: String, fetchingInterval: Double) {
		self.radioServerURLString = radioServerURLString
		self.fetchingInterval = fetchingInterval
	}

	func fetchCurrentSong(completion: @escaping (Result<String, Error>) -> Void) {
		guard
			let fetchingInterval = fetchingInterval,
			let radioServerURLString = radioServerURLString
		else {
			return
		}

		timer = Timer.scheduledTimer(withTimeInterval: fetchingInterval, repeats: true) { [weak self]  _ in
			guard let _self = self else {
				return
			}

			let completionBlock: (Result<String, Error>) -> Void = { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}

			guard let radioServerURL = URL(string: radioServerURLString) else {
				completionBlock(.failure(FetcherError.invalidURL))
				return
			}

			_self.session.dataTask(with: radioServerURL) { (data, response, error) in
				guard let data = data else {
					if let error = error {
						completionBlock(.failure(error))
					} else {
						completionBlock(.failure(FetcherError.internalError))
					}
					return
				}

				do {
					let serverInfo = try JSONDecoder().decode(ServerInfo.self, from: data)
					completionBlock(.success(serverInfo.currentSong))
				} catch {
					completionBlock(.failure(error))
					return
				}
			}.resume()
		}
		timer?.fire()
	}
}
