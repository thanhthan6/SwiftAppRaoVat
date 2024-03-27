//
//  Login_ViewController.swift
//  RaoVat2020
//
//  Created by Khoa Pham on 8/29/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit

class Login_ViewController: UIViewController {

    @IBOutlet weak var txt_Username: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Login(_ sender: Any) {
        
        // send Un/Pww
        let url = URL(string: Config.ServerURL +  "/login")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        var sData = "Username=" + self.txt_Username.text!
        sData += "&Password=" + self.txt_Password.text!
        
        let postData = sData.data(using: .utf8)
        request.httpBody = postData
        
        let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data , response, error in
            guard error == nil else { print("error"); return }
            guard let data = data else { return }
            
            do{
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else { return }
 
                if( json["kq"] as! Int == 1 ){
                    // Thanh cong
                    
                    let defaults = UserDefaults.standard
                    defaults.set(json["Token"], forKey: "UserToken");
                    DispatchQueue.main.async {
                        let alertView = UIAlertController(title: "Thong bao", message: "Login successfully", preferredStyle: .alert)
                        alertView.addAction(UIAlertAction(title: "Okay", style: .default,
                                                          handler:{(action:UIAlertAction!) in
                                                            
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let dashboard_VC = sb.instantiateViewController(identifier: "DASHBOARD") as! Dashboard_ViewController
                            self.navigationController?.pushViewController(dashboard_VC, animated: false)
                                                            
                        }))
                        self.present(alertView, animated: true, completion: nil)
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        let alertView = UIAlertController(title: "Thong bao", message: (json["errMsg"] as! String), preferredStyle: .alert)
                        alertView.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(alertView, animated: true, completion: nil)
                    }
                }
                
            }catch let error { print(error.localizedDescription) }
        })
        taskUserRegister.resume()
        
    }
    
    @IBAction func Register(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let register = sb.instantiateViewController(identifier: "Register") as! Register_ViewController
        
        self.navigationController?.pushViewController(register, animated: true)
    }
}
