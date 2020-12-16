//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Ashish Katiyar on 11/12/20.
//  Copyright © 2020 Ashish Katiyar. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping ((Error?, HTTPURLResponse?)->Void))
}

public class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL = URL(string: "http://a-URL.com")!, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error)->Void) {
        client.get(from : url) {error, httpResponse in
            if error != nil {
                completion(.connectivity)
            } else {
                completion(.invalidData)
            }
        }
    }
}
