//
//  EventFromURL.swift
//  CollectionViewLayout
//
//  Created by David Perez on 1/9/19.
//  Copyright © 2019 David Perez P. All rights reserved.
//

import Foundation
import UIKit

struct EventFromURL {
    
    fileprivate mutating func ftchJSON(){
        var event: EventModel!
        let urlString = "https://my-json-server.typicode.com/DavidPerezP124/EventJSON/posts"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("URL fecth error", err)
                    return
                }
                guard let data = data else {return}
                do {
                    let decoder = JSONDecoder()
                   event = try decoder.decode(EventModel.self, from: data)
                } catch let jsonError {
                    print("Decode failure", jsonError)
                }
            }
        }.resume()
    }
    
}
