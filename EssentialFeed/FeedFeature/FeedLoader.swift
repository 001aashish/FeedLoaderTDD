//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Ashish Katiyar on 10/12/20.
//  Copyright © 2020 Ashish Katiyar. All rights reserved.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
