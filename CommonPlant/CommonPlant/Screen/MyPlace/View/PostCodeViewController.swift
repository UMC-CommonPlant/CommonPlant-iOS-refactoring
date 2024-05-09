//
//  PostCodeViewController.swift
//  CommonPlant
//
//  Created by 이예원 on 3/2/24.
//

import UIKit
import WebKit

class PostCodeViewController: UIViewController {
    var webView: WKWebView?
    let contentController = WKUserContentController()
    let indicator = UIActivityIndicatorView(style: .medium)
    var address = ""
    var onAddressSelect: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        setAttributes()
        setConstraints()
    }
    
    private func setAttributes() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView?.navigationDelegate = self
        
        guard let url = URL(string: "https://yaewonlee.github.io/Kakao-Postcode/"), let webView = webView else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
    }
    
    private func setConstraints() {
        guard let webView = webView else { return }
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(5)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        webView.addSubview(indicator)
        
        indicator.snp.makeConstraints { make in
            make.centerX.equalTo(webView.snp.centerX)
            make.centerY.equalTo(webView.snp.centerY)
        }
    }
}

extension PostCodeViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: Any] {
            address = data["roadAddress"] as? String ?? ""
        }
        onAddressSelect?(address)
        self.dismiss(animated: true)
    }
}

extension PostCodeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
