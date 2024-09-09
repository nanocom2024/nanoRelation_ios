//
//  Auth.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/08.
//

import Foundation

class Auth {
    static private let cookieManager = CookieManager()
    static private let url = URL(string: BaseUrl.url + "/auth")!
    
    static func getToken() -> String? {
        if cookieManager.isCookieSet(name: "authtoken", url: url) {
            return cookieManager.getCookie(name: "authtoken", url: url)
        }
        return nil
    }
    
    static func setToken(token: String) {
        cookieManager.setCookie(url: url, key: "authtoken", value: token)
    }
    
    static func deleteToken() {
        cookieManager.removeCookie(name: "authtoken", url: url)
    }
}
