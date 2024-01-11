//
//  Common.swift
//  LinkIDSDK
//
//  Created by ThanhNTH on 11/01/2024.
//

import UIKit


public class CommonFuction {
    
    public static func openScreen() {
        let bundle = Bundle(identifier: "com.test.linkid.sdk")
        let story = UIStoryboard(name: "Main", bundle:bundle)
        let vc = story.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
