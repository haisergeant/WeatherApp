//
//  JSONDataRequestOperation.swift
//  WeatherApp
//
//  Created by Hai Le Thanh on 4/21/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation

class JSONDataRequestOperation<T: Decodable>: BaseOperation<T> {
        
    private let urlSession: URLSession
    private let url: URL
    private var dataTask: URLSessionDataTask?
    
    init(url: URL, urlSession: URLSession = .shared) {
        self.url = url
        self.urlSession = urlSession
    }
    
    override func main() {
        dataTask = urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            do {
                if let error = error {
                    self.complete(result: .failure(error))
                } else if let data = data {
                    let decoder = JSONDecoder()
                    
                    let string = String(data: data, encoding: .ascii)
                    guard let newData = string?.data(using: .utf8) else {
                        self.complete(result: .failure(APIError.jsonFormatError))
                        return
                    }
                    let result = try decoder.decode(T.self, from: newData)
                    self.complete(result: .success(result))
                }
            } catch {
                self.complete(result: .failure(APIError.jsonFormatError))
            }
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}

