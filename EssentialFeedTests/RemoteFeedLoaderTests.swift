//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Ashish Katiyar on 10/12/20.
//  Copyright © 2020 Ashish Katiyar. All rights reserved.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "http://a-givenURL.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_requestTwiceDataFromURLTwice() {
        let url = URL(string: "http://a-givenURL.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()
        sut.load()
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedError :RemoteFeedLoader.Error?
        sut.load {
            capturedError = $0
        }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.completions[0](clientError)
        XCTAssertEqual(capturedError, .connectivity)
    }
    
    //MARK:- Helpers
    private func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let loader = RemoteFeedLoader(url: url, client: client)
        return (loader, client)
    }

    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var completions = [(Error)->Void]()
        
        func get(from url: URL, completion: @escaping (Error)->Void) {
            completions.append(completion)
            requestedURLs.append(url)
        }
    }
}
