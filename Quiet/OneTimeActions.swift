//
//  OneTimeActions.swift
//  Quiet
//
//  Created by Oleg Dreyman on 28.05.2020.
//  Copyright © 2020 Quiet Inc. All rights reserved.
//

import Foundation

enum OneTimeActions {
    
    enum Flag: String {
        case welcomeScreen = "QuietHasSeenWelcomePopup"
        case notificationAuthorizationRequestPopup = "QuietHasSeenNotificationAuthorizationRequestPopup"
        case oneHundredTrackingAttemptsBlockedNotification = "QuietHasScheduledOneHundredTrackingAttemptsBlockedNotification"
        case newEnableNotificationsController = "QuietHasSeenNewEnableNotificationsController"
    }
    
    static func hasSeen(_ flag: Flag) -> Bool {
        return defaults.bool(forKey: flag.rawValue)
    }
    
    static func markAsSeen(_ flag: Flag) {
        defaults.set(true, forKey: flag.rawValue)
    }
    
    static func performOnce(ifHasNotSeen flag: Flag, action: () -> ()) {
        if hasSeen(flag) {
            return
        } else {
            markAsSeen(flag)
            action()
        }
    }
}
