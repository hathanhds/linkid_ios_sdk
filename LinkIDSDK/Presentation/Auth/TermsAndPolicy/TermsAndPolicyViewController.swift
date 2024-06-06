//
//  TermsAndPolicyViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 14/03/2024.
//

import Foundation
import UIKit
import WebKit
import RxSwift


class TermsAndPolicyViewController: BaseViewController, ViewControllerType {
    typealias ViewModel = TermsAndPolicyViewModel

    static func create(with navigator: Navigator, viewModel: TermsAndPolicyViewModel) -> Self {
        let vc = UIStoryboard.auth.instantiateViewController(ofType: TermsAndPolicyViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    var viewModel: TermsAndPolicyViewModel!
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.webView.navigationDelegate = self
        viewModel.getTermsOrPolicy()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideNavigationBar()
    }

    override func initView() {
        webView.scrollView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        webView.scrollView.contentInsetAdjustmentBehavior = .never


    }

    override func bindToView() {
        viewModel.output.title.subscribe(
            onNext: { [weak self] title in
                guard let self = self else { return }
                self.title = title
            }).disposed(by: self.disposeBag)

        viewModel.output.htmlString.subscribe(
            onNext: { [weak self] htmlString in
                guard let self = self else { return }
                self.showLoading()
                self.webView.loadHTMLString(htmlString, baseURL: nil)
                self.webView.scrollView.showsVerticalScrollIndicator = false
            }).disposed(by: self.disposeBag)
    }
}

extension TermsAndPolicyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let css = "body { background-color : #ff0000 }"
//        let styles = """
//        <link rel="preconnect" href="https://fonts.googleapis.com">
//        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
//        <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
//        <style>
//          * {
//            all: revert !important;
//            margin: 0px !important;
//            text-align: justify !important;
//            line-height: 1.6 !important;
//            background-color: white !important;
//            font-family: 'Roboto' !important;
//            font-size: 14px !important;
//          }
//
//          img{
//          width:100%;
//          max-width:\(view.frame.width - 40)px !important;
//          }
//
//          body {
//            max-width: 100% !important;
//            width: \(view.frame.width - 30) px !important
//          }
//
//          p {
//            font-size: 14px !important;
//            font-family: 'Roboto' !important;
//          }
//
//          li, ol, ul {
//            list-style-type: none !important;
//            margin: 0 !important;
//            list-style-type: square !important;
//          }
//
//          img {
//            width: auto;
//            max-width: 80%;
//            margin-top: 14px !important;
//            margin-left: auto !important;
//            margin-right: auto !important;
//            display:block !important;
//          }
//          a {
//            text-decoration-line: underline !important;
//            color: blue !important;
//          }
//        </style>
//        """
//        let js = """
//        var style = document.createElement('style'); style.innerHTML = '\(styles)'; document.head.appendChild(style);
//        document.getElementsByTagName('body')[0].style.fontSize= '\(14)px'
//        """
//        self.webView.evaluateJavaScript(js)
        changeFontSize(20)
        self.hideLoading()
    }

    
    func changeFontSize(_ size: Int) {
            let js = "document.getElementsByTagName('body')[0].style.fontSize = '\(size)px';"
            webView.evaluateJavaScript(js) { (result, error) in
                if let error = error {
                    print("Failed to set font size: \(error)")
                } else {
                    print("Font size set successfully")
                }
            }
        }
}
