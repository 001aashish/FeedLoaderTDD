//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Ashish Katiyar on 11/12/20.
//  Copyright © 2020 Ashish Katiyar. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public init(url: URL = URL(string: "http://a-URL.com")!, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load() {
        client.get(from : url)
    }
}
