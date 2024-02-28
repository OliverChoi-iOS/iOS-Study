//
//  PaymentViewController.swift
//  CProject
//
//  Created by Choi Oliver on 2/22/24.
//

import UIKit
import WebKit

final class PaymentViewController: UIViewController {

    private var webView: WKWebView?
    private let getMessageScriptName: String = "receiveMessage"
    
    override func loadView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "receiveMessage")
        
        let config: WKWebViewConfiguration = .init()
        config.userContentController = contentController
        
        webView = .init(frame: .zero, configuration: config)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlRequest: URLRequest = .init(url: URL(string: "https://google.com")!)
        urlRequest.addValue("customValue", forHTTPHeaderField: "Header-Name")
        webView?.load(urlRequest)
        
        let button: UIButton = .init(frame: .init(x: 0, y: 400, width: 100, height: 100))
        button.setTitle("call javascript", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addAction(.init(handler: { [weak self] _ in
            self?.callJavaScript()
        }), for: .touchUpInside)
        view.addSubview(button)
    }
    
    private func setUserAgent() {
        webView?.customUserAgent = "CProject/1.0.0/iOS"
    }
    
    private func setCookie() {
        guard let cookie = HTTPCookie(
            properties: [
                .domain: "google.co.kr",
                .path: "/test",
                .name: "myCookie",
                .value: "value",
                .secure: "TRUE", // "TRUE" or "FALSE"
                .expires: NSDate(timeIntervalSinceNow: 3600) // 1 hour later
            ]
        ) else { return }
        
        webView?.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
    }
    
    private func callJavaScript() {
        webView?.evaluateJavaScript("javascriptFunction();")
    }
}

extension PaymentViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == getMessageScriptName {
            print("\(message.body)")
        }
    }
}

#Preview {
    PaymentViewController()
}
