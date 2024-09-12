//
//  CookieManager.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/08.
//

import Foundation

class CookieManager {
    // HTTPURLResponseから特定のCookieを探し、HTTPCookieStorageに保存する
    func loadCookie(name: String, response: HTTPURLResponse) {
        if let fields = response.allHeaderFields as? [String: String], let url = response.url {
            for cookie in HTTPCookie.cookies(withResponseHeaderFields: fields, for: url) {
                if (cookie.name == name) {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
            }
        }
    }

    // Url, Key, ValueからCookie文字列を生成し、HTTPCookieStrageに保存する
    func setCookie(url: URL, key: String, value: String) {
        let cookieStr = key + "=" + value + ";"
        let cookieHeaderField = ["Set-Cookie": cookieStr]
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url)

        HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: url)
    }

    // HTTPCookieStorageから特定のCookieを取得する
    func getCookie(name: String, url: URL) -> String? {
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            for cookie in cookies {
                if (cookie.name == name) {
                    return cookie.value
                }
            }
        }

        return nil
    }

    // HTTPCookieStorageに特定のCookieが保存されているかを調べる
    func isCookieSet(name: String, url: URL) -> Bool {
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            for cookie in cookies {
                if (cookie.name == name) {
                    return true
                }
            }
        }

        return false
    }

    // HTTPCookieStorageから特定のCookieを削除する
    func removeCookie(name: String, url: URL) {
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            for cookie in cookies {
                if (cookie.name == name) {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
        }
    }
}
