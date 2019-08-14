//
//  Config.swift
//  Radio UCI
//
//  Created by Annino De Petra on 09/04/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

import Foundation

struct ConfigFile: Decodable {
	var serverURL: String
	var streamURL: String
	var fetchingIntervalSeconds: Int
	var title: String
	var description: String
	var share: [ShareOption]
}

extension ConfigFile {
	static let `default` = ConfigFile(
		serverURL: "http://nrf1.newradio.it:19902/status-json.xsl",
		streamURL: "http://nrf1.newradio.it:19902/stream.m3u",
		fetchingIntervalSeconds: 15,
		title: "Radio UCI",
		description: "La nostra musica ed i nostri servizi",
		share: [
			ShareOption(name: "Sito web", image: "LogoRadioUCI", url: URL(string: "http://radiouci.it")!),
			ShareOption(name: "Facebook", image: "facebook", url: URL(string: "https://www.facebook.com/radiouciweb/")!),
			ShareOption(name: "Whatsapp", image: "whatsapp", url: URL(string: "https://api.whatsapp.com/send?phone=393335483725&text=Salve%2C%20sono%20un%20vostro%20radio%20ascoltatore.%20Vorrei%20dirvi%20che")!),
			ShareOption(name: "Instagram", image: "instagram", url: URL(string: "https://instagram.com/radiouci")!),
		])
}
