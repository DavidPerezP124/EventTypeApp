//
//  EventsViewModel.swift
//  CollectionViewLayout
//
//  Created by David Perez on 2/13/19.
//  Copyright © 2019 David Perez P. All rights reserved.
//

import Foundation
import CoreData

protocol EventsViewDelegate: class {
    func reloadData()
    func setupEvents()
}

protocol EventsView {
    func viewWillLoad()
    func checkSaved() -> [EventEntity]?
}

class EventsViewModel: EventsView {
    
    
    private  var savedEvents: [EventEntity] = []
    private var events: [EventModel?] = []
    
    weak var delegate: EventsViewDelegate?
    
    
    init(delegate: EventsViewDelegate, savedEvents: [EventEntity]) {
        self.delegate = delegate
        self.savedEvents = savedEvents
    }
    
    
    func viewWillLoad(){
        ftchJSON()
    }
    
    
    
    
    fileprivate func createEventArray(){
        let eventData = EventEntity(context: PersitanceService.context)
        
        for evnts in events {
            print(events)
            let imgFromURl = URL(string: evnts!.img ?? "")
            let data = try? Data(contentsOf: imgFromURl!)
            eventData.entityImage = NSData(data: data!)
            eventData.entityCost = evnts!.cost ?? 0.0
            eventData.entityTime = evnts!.time
            eventData.entityNameString = evnts!.name
            savedEvents.append(eventData)
            PersitanceService.saveContext()
            
        }
        
        defer {
            self.delegate?.setupEvents()
            self.delegate?.reloadData()
        }
        
    }
    
    fileprivate func ftchJSON(){
        
        let urlString = "https://my-json-server.typicode.com/DavidPerezP124/EventJSON/posts"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("URL fecth error", err.localizedDescription)
                }
                
                guard let data = data else {return}
                do {
                    let decoder = JSONDecoder()
                   let events = try decoder.decode([EventModel].self, from: data)
                    print(events)
                    defer {
                        self.createEventArray()
                    }
                    for evnt in events {
                        self.events.append(evnt)
                         self.createEventArray()
                    }
                    
                } catch let jsonError {
                    print("Decode failure", jsonError)
                }
            }
        }.resume()
    }
    
    func checkSaved() -> [EventEntity]?{
        
        let ftchRequest: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
        do {
            defer{self.delegate?.reloadData()}
            let savedEvents = try PersitanceService.context.fetch(ftchRequest)
            return savedEvents
            
        } catch {
            print("fetch error")
            return nil
        }
        
    }
    
    
    
}
