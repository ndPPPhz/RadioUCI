//
//  CompletionWithResult.swift
//  Radio UCI
//
//  Created by Annino De Petra on 07/05/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

typealias CompletionWithResult<Success> = (Result<Success, Error>) -> Void
