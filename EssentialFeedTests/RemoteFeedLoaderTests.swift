//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Ashish Katiyar on 10/12/20.
//  Copyright © 2020 Ashish Katiyar. All rights reserved.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")
    }
}

class HTTPClient {
    static let shared = HTTPClient()
    
    private init() {}
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        _ = RemoteFeedLoader()
        let client = HTTPClient.shared
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let sut = RemoteFeedLoader()
        let client = HTTPClient.shared
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
