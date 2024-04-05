//
//  Config.swift
//  SDKTest
//
//  Created by ThanhNTH on 04/04/2024.
//

import UIKit

public class Config {

    public static func initSDK(presentAction: ((_ vc: UIViewController) -> Void)) {
        let frameworkBundle = Bundle(identifier: "com.test.SDKTest")
        let storyboard = UIStoryboard(name: "Custom", bundle: frameworkBundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "Screen1ViewController")
        presentAction(vc)
    }
}
