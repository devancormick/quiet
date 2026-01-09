//
//  WhitelistUtilities.swift
//  Quiet
//
//  Created by Johnny Lin on 8/7/19.
//  Copyright © 2019 Quiet Inc. All rights reserved.
//

import Foundation
import NetworkExtension

// MARK: - Constants

func getAllWhitelistedDomains() -> Array<String> {
    let lockdownWhitelistedDomains = getQuietWhitelistedDomains()
    let userWhitelistedDomains = getUserWhitelistedDomains()
    
    var allWhitelistedDomains = Array<String>()
    
    for (key, value) in lockdownWhitelistedDomains {
        if (value as AnyObject).boolValue {
            allWhitelistedDomains.append(key)
        }
    }
    for (key, value) in userWhitelistedDomains {
        if (value as AnyObject).boolValue {
            allWhitelistedDomains.append(key)
        }
    }
    
    return allWhitelistedDomains
}

// MARK: - User blocked domains

func getUserWhitelistedDomains() -> Dictionary<String, Any> {
    if let domains = defaults.dictionary(forKey: kUserWhitelistedDomains) {
        return domains
    }
    return Dictionary()
}

func addUserWhitelistedDomain(domain: String) {
    var domains = getUserWhitelistedDomains()
    domains[domain] = NSNumber(value: true)
    defaults.set(domains, forKey: kUserWhitelistedDomains)
}

func setUserWhitelistedDomain(domain: String, enabled: Bool) {
    var domains = getUserWhitelistedDomains()
    domains[domain] = NSNumber(value: enabled)
    defaults.set(domains, forKey: kUserWhitelistedDomains)
}

func deleteUserWhitelistedDomain(domain: String) {
    var domains = getUserWhitelistedDomains()
    domains[domain] = nil
    defaults.set(domains, forKey: kUserWhitelistedDomains)
}

// MARK: - Quiet whitelisted domains

func setupQuietWhitelistedDomains() {
    addQuietWhitelistedDomainIfNotExists(domain: "3stripes.net")
    addQuietWhitelistedDomainIfNotExists(domain: "aiv-cdn.net")
    addQuietWhitelistedDomainIfNotExists(domain: "akamaihd.net")
    addQuietWhitelistedDomainIfNotExists(domain: "akamaized.net")
    addQuietWhitelistedDomainIfNotExists(domain: "ally.com")
    addQuietWhitelistedDomainIfNotExists(domain: "amazon.com") // This domain is not used for tracking (the tracker amazon-adsystem.com is blocked), but it does sometimes stop Secure Tunnel VPN users from viewing Amazon reviews. Users may un-whitelist this if they wish.
    addQuietWhitelistedDomainIfNotExists(domain: "americanexpress.com")
    addQuietWhitelistedDomainIfNotExists(domain: "api.twitter.com")
    addQuietWhitelistedDomainIfNotExists(domain: "apple-cloudkit.com")
    addQuietWhitelistedDomainIfNotExists(domain: "apple.com")
    addQuietWhitelistedDomainIfNotExists(domain: "apple.news")
    addQuietWhitelistedDomainIfNotExists(domain: "archive.is")
    addQuietWhitelistedDomainIfNotExists(domain: "att.com")
    addQuietWhitelistedDomainIfNotExists(domain: "att.com.edgesuite.net")
    addQuietWhitelistedDomainIfNotExists(domain: "att.net")
    addQuietWhitelistedDomainIfNotExists(domain: "bamgrid.com")
    addQuietWhitelistedDomainIfNotExists(domain: "bestbuy.com")
    addQuietWhitelistedDomainIfNotExists(domain: "bitwarden.com")
    addQuietWhitelistedDomainIfNotExists(domain: "brightcove.com")
    addQuietWhitelistedDomainIfNotExists(domain: "cbs.com")
    addQuietWhitelistedDomainIfNotExists(domain: "cbsaavideo.com")
    addQuietWhitelistedDomainIfNotExists(domain: "cbsi.com")
    addQuietWhitelistedDomainIfNotExists(domain: "cbsi.video")
    addQuietWhitelistedDomainIfNotExists(domain: "cbsnews.com")
    addQuietWhitelistedDomainIfNotExists(domain: "cdn-apple.com")
    addQuietWhitelistedDomainIfNotExists(domain: "chase.com")
    addQuietWhitelistedDomainIfNotExists(domain: "citi.com")
    addQuietWhitelistedDomainIfNotExists(domain: "cloudfront.net")
    addQuietWhitelistedDomainIfNotExists(domain: "coinbase.com")
    addQuietWhitelistedDomainIfNotExists(domain: "comcast.net")
    addQuietWhitelistedDomainIfNotExists(domain: "example.com")
    addQuietWhitelistedDomainIfNotExists(domain: "creditkarma.com")
    addQuietWhitelistedDomainIfNotExists(domain: "cwtv.com")
    addQuietWhitelistedDomainIfNotExists(domain: "digicert.com")
    addQuietWhitelistedDomainIfNotExists(domain: "disney-plus.net")
    addQuietWhitelistedDomainIfNotExists(domain: "disneyplus.com")
    addQuietWhitelistedDomainIfNotExists(domain: "ebtedge.com")
    addQuietWhitelistedDomainIfNotExists(domain: "espn.com")
    addQuietWhitelistedDomainIfNotExists(domain: "fastly.com")
    addQuietWhitelistedDomainIfNotExists(domain: "fastly.net")
    addQuietWhitelistedDomainIfNotExists(domain: "firstdata.com")
    addQuietWhitelistedDomainIfNotExists(domain: "fubo.tv")
    addQuietWhitelistedDomainIfNotExists(domain: "gamestop.com")
    addQuietWhitelistedDomainIfNotExists(domain: "go.com")
    addQuietWhitelistedDomainIfNotExists(domain: "googlevideo.com")
    addQuietWhitelistedDomainIfNotExists(domain: "grindr.com")
    addQuietWhitelistedDomainIfNotExists(domain: "hbc.com")
    addQuietWhitelistedDomainIfNotExists(domain: "hbo.com")
    addQuietWhitelistedDomainIfNotExists(domain: "hbomax.com")
    addQuietWhitelistedDomainIfNotExists(domain: "hotstar.com")
    addQuietWhitelistedDomainIfNotExists(domain: "houzz.com")
    addQuietWhitelistedDomainIfNotExists(domain: "hopper.com")
    addQuietWhitelistedDomainIfNotExists(domain: "hulu.com")
    addQuietWhitelistedDomainIfNotExists(domain: "huluim.com")
    addQuietWhitelistedDomainIfNotExists(domain: "icloud-content.com")
    addQuietWhitelistedDomainIfNotExists(domain: "icloud.com")
    addQuietWhitelistedDomainIfNotExists(domain: "kroger.com")
    addQuietWhitelistedDomainIfNotExists(domain: "letsencrypt.org")
    addQuietWhitelistedDomainIfNotExists(domain: "livenation.com")
    addQuietWhitelistedDomainIfNotExists(domain: "lowes.com")
    addQuietWhitelistedDomainIfNotExists(domain: "lync.com")
    addQuietWhitelistedDomainIfNotExists(domain: "m.twitter.com")
    addQuietWhitelistedDomainIfNotExists(domain: "marcopolo.me")
    addQuietWhitelistedDomainIfNotExists(domain: "mastercard.ca")
    addQuietWhitelistedDomainIfNotExists(domain: "mastercard.com")
    addQuietWhitelistedDomainIfNotExists(domain: "mastercard.us")
    addQuietWhitelistedDomainIfNotExists(domain: "mbanking-services.mobi")
    addQuietWhitelistedDomainIfNotExists(domain: "me.com")
    addQuietWhitelistedDomainIfNotExists(domain: "meijer.com")
    addQuietWhitelistedDomainIfNotExists(domain: "microsoft.com")
    addQuietWhitelistedDomainIfNotExists(domain: "microsoftonline.com")
    addQuietWhitelistedDomainIfNotExists(domain: "mobile.twitter.com")
    addQuietWhitelistedDomainIfNotExists(domain: "movetv.com")
    addQuietWhitelistedDomainIfNotExists(domain: "mzstatic.com")
    addQuietWhitelistedDomainIfNotExists(domain: "nba.com")
    addQuietWhitelistedDomainIfNotExists(domain: "nbcuni.com")
    addQuietWhitelistedDomainIfNotExists(domain: "netflix.com")
    addQuietWhitelistedDomainIfNotExists(domain: "neulion.com")
    addQuietWhitelistedDomainIfNotExists(domain: "nflxvideo.net")
    addQuietWhitelistedDomainIfNotExists(domain: "nike.com")
    addQuietWhitelistedDomainIfNotExists(domain: "office.com")
    addQuietWhitelistedDomainIfNotExists(domain: "office.net")
    addQuietWhitelistedDomainIfNotExists(domain: "office365.com")
    addQuietWhitelistedDomainIfNotExists(domain: "opentable.com")
    addQuietWhitelistedDomainIfNotExists(domain: "outlook.com")
    addQuietWhitelistedDomainIfNotExists(domain: "peacocktv.com")
    addQuietWhitelistedDomainIfNotExists(domain: "personalcapital.com")
    addQuietWhitelistedDomainIfNotExists(domain: "philo.com")
    addQuietWhitelistedDomainIfNotExists(domain: "quibi.com")
    addQuietWhitelistedDomainIfNotExists(domain: "quickplay.com")
    addQuietWhitelistedDomainIfNotExists(domain: "researchgate.net")
    addQuietWhitelistedDomainIfNotExists(domain: "saks.com")
    addQuietWhitelistedDomainIfNotExists(domain: "saksfifthavenue.com")
    addQuietWhitelistedDomainIfNotExists(domain: "scholar.google.com")
    addQuietWhitelistedDomainIfNotExists(domain: "skype.com")
    addQuietWhitelistedDomainIfNotExists(domain: "skypeforbusiness.com")
    addQuietWhitelistedDomainIfNotExists(domain: "slickdeals.net")
    addQuietWhitelistedDomainIfNotExists(domain: "sling.com")
    addQuietWhitelistedDomainIfNotExists(domain: "southwest.com")
    addQuietWhitelistedDomainIfNotExists(domain: "spotify.com")
    addQuietWhitelistedDomainIfNotExists(domain: "stan.com.au")
    addQuietWhitelistedDomainIfNotExists(domain: "stan.video")
    addQuietWhitelistedDomainIfNotExists(domain: "stripe.com")
    addQuietWhitelistedDomainIfNotExists(domain: "syncbak.com")
    addQuietWhitelistedDomainIfNotExists(domain: "t.co")
    addQuietWhitelistedDomainIfNotExists(domain: "tapbots.com")
    addQuietWhitelistedDomainIfNotExists(domain: "tapbots.net")
    addQuietWhitelistedDomainIfNotExists(domain: "telegram.com")
    addQuietWhitelistedDomainIfNotExists(domain: "teslamotors.com")
    addQuietWhitelistedDomainIfNotExists(domain: "ticketmaster.com")
    addQuietWhitelistedDomainIfNotExists(domain: "ttvnw.net")
    addQuietWhitelistedDomainIfNotExists(domain: "twimg.com")
    addQuietWhitelistedDomainIfNotExists(domain: "twitter.com")
    addQuietWhitelistedDomainIfNotExists(domain: "uplynk.com")
    addQuietWhitelistedDomainIfNotExists(domain: "usbank.com")
    addQuietWhitelistedDomainIfNotExists(domain: "verisign.com")
    addQuietWhitelistedDomainIfNotExists(domain: "visa.ca")
    addQuietWhitelistedDomainIfNotExists(domain: "visa.com")
    addQuietWhitelistedDomainIfNotExists(domain: "vudu.com")
    addQuietWhitelistedDomainIfNotExists(domain: "xfinity.com")
    addQuietWhitelistedDomainIfNotExists(domain: "youtube.com")
    addQuietWhitelistedDomainIfNotExists(domain: "zoom.us")
    
    setAsFalseQuietWhitelistedDomain(domain: "nianticlabs.com")
}

func addQuietWhitelistedDomainIfNotExists(domain: String) {
    // only add it if it doesn't exist, and add it as true
    var domains = getQuietWhitelistedDomains()
    if domains[domain] == nil {
        domains[domain] = NSNumber(value: true)
    }
    defaults.set(domains, forKey: kQuietWhitelistedDomains)
}

func setAsFalseQuietWhitelistedDomain(domain: String) {
    var domains = getQuietWhitelistedDomains()
    domains[domain] = NSNumber(value: false)
    defaults.set(domains, forKey: kQuietWhitelistedDomains)
}

func getQuietWhitelistedDomains() -> Dictionary<String, Any> {
    if let domains = defaults.dictionary(forKey: kQuietWhitelistedDomains) {
        return domains;
    }
    return Dictionary()
}

func setQuietWhitelistedDomain(domain: String, enabled: Bool) {
    var domains = getQuietWhitelistedDomains()
    domains[domain] = NSNumber(value: enabled)
    defaults.set(domains, forKey: kQuietWhitelistedDomains)
}
