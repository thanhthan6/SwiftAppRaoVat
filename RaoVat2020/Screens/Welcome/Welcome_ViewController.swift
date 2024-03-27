//
//  Welcome_ViewController.swift
//  RaoVat2020
//
//  Created by Khoa Pham on 8/29/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit

class Welcome_ViewController: UIViewController {

    @IBOutlet weak var img_BG: UIImageView!
    @IBOutlet weak var img_Logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img_BG.frame.size.width = self.view.frame.size.width *  3
        img_BG.frame.size.height = self.view.frame.size.height * 3
        img_BG.frame.origin = CGPoint(x: 0, y: 0)
        img_BG.alpha = 0
        
        UIView.animate(withDuration: 6, animations: {
            self.img_BG.alpha = 0.7
            self.img_BG.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        }, completion: nil)

        img_Logo.frame.origin.x = 0 - img_Logo.frame.size.width
        
        UIView.animate(withDuration: 3, animations: {
            self.img_Logo.frame.origin = CGPoint(
                x: self.view.frame.size.width/2 - self.img_Logo.frame.size.width/2,
                y: self.view.frame.size.height/2 - self.img_Logo.frame.size.height/2
            )
        }, completion: nil)
        
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
