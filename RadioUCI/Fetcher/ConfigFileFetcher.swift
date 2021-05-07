//
//  ConfigFileFetcher.swift
//  Radio UCI
//
//  Created by Annino De Petra on 09/04/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

import Foundation

protocol ConfigFileFetcherInterface {
	func fetchConfig(url: URL, completion: @escaping CompletionWithResult<ConfigFile>)
}

final class ConfigFileFetcher: ConfigFileFetcherInterface {
	enum FetcherError: Error {
		case internalError
	}

	private let session: URLSession
	private lazy var jsonDecoder = JSONDecoder()

	init(
		session: URLSession = .shared
	) {
		self.session = session
	}

	func fetchConfig(url: URL, completion: @escaping CompletionWithResult<ConfigFile>) {
		session.dataTask(with: url) { [weak self] (data, _, error) in
			guard let _self = self else {
				return
			}

			let completionBlock: (CompletionWithResult<ConfigFile>) = { result in
				DispatchQueue.main.async {
					completion(result)
				}
			}

			guard let data = data else {
				if let error = error {
					completionBlock(.failure(error))
				} else {
					completionBlock(.failure(FetcherError.internalError))
				}
				return
			}

			do {
				let configFile = try _self.jsonDecoder.decode(ConfigFile.self, from: data)
				completionBlock(.success(configFile))
			} catch {
				completionBlock(.failure(error))
				return
			}
		}.resume()
	}
}
