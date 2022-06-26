//
//  Config.swift
//  Radio UCI
//
//  Created by Annino De Petra on 09/04/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

import Foundation

protocol Configuration {
	var serverURL: String { get }
	var radioURL: String { get }
	var fetchingIntervalSeconds: Int { get }
	var title: String { get }
	var description: String { get }
	var share: [ShareOption] { get }
}

struct ConfigFile: Configuration, Decodable {
	var serverURL: String
	var streamURL: String
	var streamURL_backup: String
	var streamFromDefault: Bool
	var fetchingIntervalSeconds: Int
	var title: String
	var description: String
	var share: [ShareOption]
	var radioURL: String {
		streamFromDefault ? streamURL : streamURL_backup
	}
}

extension ConfigFile {
	static let `default` = ConfigFile(
		serverURL: "http://nrf1.newradio.it:19902/status-json.xsl",
		streamURL: "https://nrf1.newradio.it:9902/stream",
		streamURL_backup: "https://nr9.newradio.it:19423/stream",
		streamFromDefault: true,
		fetchingIntervalSeconds: 15,
		title: "Radio UCI",
		description: "La nostra musica ed i nostri servizi",
		share: [
			ShareOption(name: "Sito web", image: "LogoRadioUCI", url: URL(string: "https://radiouci.it")!),
			ShareOption(name: "TikTok", image: "tiktok", url: URL(string: "https://www.tiktok.com/@radiouci")!),
			ShareOption(name: "Podcast", image: "podcast", url: URL(string: "https://www.spreaker.com/user/radiouci")!),
			ShareOption(name: "Youtube", image: "youtube", url: URL(string: "https://www.youtube.com/channel/UCAHqbzKMJGA5Al5Dyv1Y_EA")!),
		])
}
