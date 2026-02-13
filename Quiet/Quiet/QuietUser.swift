//
//  QuietUser.swift
//  Quiet
//
//  Created by Aliaksandr Dvoineu on 4.05.23.
//  Copyright © 2023 Quiet Inc. All rights reserved.
//

import Foundation

final class QuietUser {
    private(set) var currentSubscription: Subscription?
    
    @CodableUserDefaults(key: "cahedUsedSubscription")
    private var cachedUserSubscription: Subscription?
        
    func updateSubscription(to newSubscription: Subscription?) {
        currentSubscription = newSubscription
        updateCachedSubscription(to: newSubscription)
    }
    
    private func updateCachedSubscription(to newSubscription: Subscription?) {
        guard let newSubscription else {
            return
        }
        
        cachedUserSubscription = newSubscription
    }
    
    func cachedSubscription() -> Subscription? {
        guard let subscription = cachedUserSubscription else {
            return nil
        }
        
        guard subscription.expirationDate > Date() else {
            cachedUserSubscription = nil
            return nil
        }
        return subscription
    }
    
    func resetCache() {
        cachedUserSubscription = nil
    }
}
