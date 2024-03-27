//
//  YourListis_ViewController.swift
//  RaoVat2020
//
//  Created by Khoa Pham on 8/29/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit

class YourListis_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func GoTo_CreatePost(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let createPost_VC = sb.instantiateViewController(identifier: "CREATE__POSTS") as! CreatePoost_ViewController
        self.navigationController?.pushViewController(createPost_VC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
