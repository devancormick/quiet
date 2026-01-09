//
//  Defaults.swift
//  Quiet
//
//  Created by Radu Lazar on 08.08.2024.
//  Copyright © 2024 Quiet Inc. All rights reserved.
//

import Foundation

//MARK: Metrics
let kDayMetrics = "QuietDayMetrics"
let kWeekMetrics = "QuietWeekMetrics"
let kTotalMetrics = "QuietTotalMetrics"
let kTotalEnabledMetrics = "QuietTotalEnabledMetrics"
let kTotalDisabledMetrics = "QuietTotalDisabledMetrics"

let kActiveDay = "QuietActiveDay"
let kActiveWeek = "QuietActiveWeek"

//MARK: Firewall utils

let kQuietBlockedDomains = "lockdown_domains"
let kUserBlockedDomains = "lockdown_domains_user"
let kUserBlockedLists = "lockdown_lists_user"

//MARK: Whitelist 

let kQuietWhitelistedDomains = "whitelisted_domains"
let kUserWhitelistedDomains = "whitelisted_domains_user"

//MARK: Latest Knowledge

let kLatestKnowledgeIsFirewallEnabled = "kLatestKnowledgeIsFirewallEnabled"
let kLatestKnowledgeIsVPNEnabled = "kLatestKnowledgeIsVPNEnabled"

// MARK: - VPN Region

let kSavedVPNRegionServerPrefix = "vpn_region_server_prefix"

//MARK: Others

let kAPICredentialsQuiet = "APICredentialsQuiet"

let kUserWantsFirewallEnabled = "user_wants_firewall_enabled"
let kUserWantsVPNEnabled = "user_wants_vpn_enabled"

let kAllowNotificationsAfterDate = "QuietAllowNotificationsAfter"

let kQuietNotificationsEnergySavingCounter = "QuietNotificationsEnergySavingCounter"

let kAppActivateTime = "AppActivateTime"
let kOneTimeOfferShown = "OneTimeOfferShown"
let kSpecialOfferTimeDidReset = "SpecialOfferTimeDidReset_27_11_2024"
let kVersionOfLastRun = "VersionOfLastRun"
