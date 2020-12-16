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

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_requestTwiceDataFromURLTwice() {
        let url = URL(string: "http://a-givenURL.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedError :RemoteFeedLoader.Error?
        sut.load { capturedError = $0 }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        XCTAssertEqual(capturedError, .connectivity)
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        var capturedError = [RemoteFeedLoader.Error]()
        sut.load { capturedError.append($0) }
        
        client.complete(withStatusCode: 400)
        XCTAssertEqual(capturedError, [.invalidData])
    }
    
    //MARK:- Helpers
    private func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let loader = RemoteFeedLoader(url: url, client: client)
        return (loader, client)
    }

    private class HTTPClientSpy: HTTPClient {
        private var message = [(url: URL, completion: ((Error?, HTTPURLResponse?)->Void))]()

        var requestedURLs : [URL] {
            return message.map { $0.url }
        }
                
        func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?)->Void) {
            message.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            message[index].completion(error, nil)
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)
            message[index].completion(nil, response)
        }
    }
}
