//
//  MockURLSession.swift
//
//  Created by Hai Le Thanh.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import Foundation
import UIKit
@testable import WeatherApp

class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURLRequest: URLRequest?
    var data: Data?
    var error: Error?
    
    func successHttpURLResponse(_ url: URL) -> URLResponse {
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURLRequest = request
        DispatchQueue.global().async {
            completionHandler(self.data, self.successHttpURLResponse(request.url!), self.error)
        }
        return nextDataTask
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        DispatchQueue.global().async {
            completionHandler(self.data, self.successHttpURLResponse(url), self.error)
        }
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    private (set) var cancelWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
    
    func cancel() {
        cancelWasCalled = true
    }
}

class AppURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    var data: Data?
    var error: Error?
    
    var imageData: Data?
    var imageError: Error?
    
    func successHttpURLResponse(_ url: URL) -> URLResponse {
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        DispatchQueue.global().async {
            if request.url!.absoluteString.hasSuffix(".png") || request.url!.absoluteString.hasSuffix(".jpg") {
                completionHandler(self.imageData,
                                  self.successHttpURLResponse(request.url!),
                                  self.imageError)
            } else {
                completionHandler(self.data,
                                  self.successHttpURLResponse(request.url!),
                                  self.error)
            }
        }
        return nextDataTask
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return nextDataTask
    }
}
