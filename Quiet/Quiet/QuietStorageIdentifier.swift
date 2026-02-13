//
//  QuietStorageIdentifier.swift
//  Quiet
//
//  Created by Aliaksandr Dvoineu on 4.05.23.
//  Copyright © 2023 Quiet Inc. All rights reserved.
//

public struct QuietStorageIdentifier {
    
    private init() {}
    
    static let keychainId = "com.example.quiet.tunnels"
    static let userDefaultsId = "group.com.example.quiet"
    static let contentBlockerId = "com.example.quiet.Quiet-Blocker"
}
