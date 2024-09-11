//
//  AppDelegate.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/08.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // UserDefaultにクッキーを保存するメソッド
    private func storeCookies() {
        // 現在保持されているクッキーを取り出します
        guard let cookies = HTTPCookieStorage.shared.cookies else { return }
        // UserDefaultsに保存できるデータ型に変換していきます
        var cookieDictionary = [String : AnyObject]()
        for cookie in cookies {
            cookieDictionary[cookie.name] = cookie.properties as AnyObject?
        }
        // UserDefaultsに保存します
        UserDefaults.standard.set(cookieDictionary, forKey: "cookie")
    }
    
    // UserDefaultからクッキーを取得するメソッド
    private func retrieveCookies() {
        // UserDefaultsに保存してあるクッキー情報を取り出します。（この時はまだ[String : AnyObject]型）
        guard let cookieDictionary = UserDefaults.standard.dictionary(forKey: "cookie") else { return }
        // HTTPCookie型に変換していきます
        for (_, cookieProperties) in cookieDictionary {
                if let cookieProperties = cookieProperties as? [HTTPCookiePropertyKey : Any] {
                if let cookie = HTTPCookie(properties: cookieProperties ) {
                    // クッキーをメモリ内にセットします
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
            }
        }
    }

    
    // 起動時
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // クッキー取得
        retrieveCookies()
        return true
    }

    // バックグラウンドに入った時
    func applicationDidEnterBackground(_ application: UIApplication) {
        // クッキー保存
        storeCookies()
        print("store Cookie")
    }

    // アプリがkillされた時
    func applicationWillTerminate(_ application: UIApplication) {
        // クッキー保存
        storeCookies()
        print("store Cookie")
    }
}
