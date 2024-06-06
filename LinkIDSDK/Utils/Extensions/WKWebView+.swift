//
//  WKWebView+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 21/05/2024.
//

import WebKit

extension WKWebView {
    //// - Parameters:
    ///   - content: HTML content which we need to load in the webview.
    ///   - baseURL: Content base url. It is optional.
    func loadHTMLStringWith(content: String, baseURL: URL?) {
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        loadHTMLString(headerString + content, baseURL: baseURL)
    }
}
