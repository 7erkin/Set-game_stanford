//
//  SubscriberList.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 23/02/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

class SubscriberList {
    private var subscribers = [Subscribing]()
    
    func add(_ subscriber: Subscribing) {
        if subscribers.contains(where: { $0 === subscriber }) { return }
        subscribers.append(subscriber)
    }
    
    func notifyAll() {
        DispatchQueue.main.async { [weak self] in
            self?.subscribers.forEach { $0.update() }
        }
    }
}
