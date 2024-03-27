//
//  Dashboard_ViewController.swift
//  RaoVat2020
//
//  Created by Khoa Pham on 8/29/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit

class Dashboard_ViewController: UIViewController {

    
    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var lbl_HoTen: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img_Avatar.layer.cornerRadius = img_Avatar.frame.size.width/2
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // Check login
        
        if let UserToken = defaults.string(forKey: "UserToken") {
    
            // Verify
            let url = URL(string: Config.ServerURL +  "/verifyToken")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            let sData = "Token=" + UserToken
            
            
            let postData = sData.data(using: .utf8)
            request.httpBody = postData
            
            let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data , response, error in
                guard error == nil else { print("error"); return }
                guard let data = data else { return }
                
                do{
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else { return }
                    
                    if( json["kq"] as! Int == 1 ){
                        print("Okay")
                        let user = json["User"] as?  [String:Any]
                        let imgString = user!["Image"] as? String
                        let urlHinh = Config.ServerURL + "/upload/" + imgString!
                        DispatchQueue.main.async {
                            do {
                                DispatchQueue.main.async {
                                    let imgData = try! Data(contentsOf: URL(string: urlHinh)!)
                                    self.img_Avatar.image = UIImage(data: imgData)
                                }
                            } catch {}
                            
                            self.lbl_HoTen.text = user!["Name"] as? String
                            self.lbl_Email.text = user!["Address"] as? String
                        }
                    } else {
                        DispatchQueue.main.async {
                           let sb = UIStoryboard(name: "Main", bundle: nil)
                           let login_VC = sb.instantiateViewController(identifier: "LOGIN") as! Login_ViewController
                           self.navigationController?.pushViewController(login_VC, animated: false)
                        }
                    }
                    
                }catch let error { print(error.localizedDescription) }
            })
            taskUserRegister.resume()
            
        }else{
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let login_VC = sb.instantiateViewController(identifier: "LOGIN") as! Login_ViewController
            self.navigationController?.pushViewController(login_VC, animated: false)
        }
        
    }
    
    @IBAction func Logout(_ sender: Any) {
        if let UserToken = defaults.string(forKey: "UserToken") {
                let url = URL(string: Config.ServerURL +  "/logout")
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
            
                  let sData = "Token=" + UserToken
                   
                   let postData = sData.data(using: .utf8)
                   request.httpBody = postData
                   
                   let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data , response, error in
                       guard error == nil else { print("error"); return }
                       guard let data = data else { return }
                       
                       do{
                           guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else { return }
            
                           if( json["kq"] as! Int == 1 ){
                               // Thanh cong
                            
                            self.defaults.removeObject(forKey: "UserToken")
                            
                            DispatchQueue.main.async {
                                let sb = UIStoryboard(name: "Main", bundle: nil)
                                let login_VC = sb.instantiateViewController(identifier: "LOGIN") as! Login_ViewController
                                self.navigationController?.pushViewController(login_VC, animated: false)
                            }
                               
                           } else {
                               DispatchQueue.main.async {
                                   let alertView = UIAlertController(title: "Thong bao", message: (json["errMsg"] as! String), preferredStyle: .alert)
                                   alertView.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                   self.present(alertView, animated: true, completion: nil)
                               }
                           }
                           
                       }catch let error { print(error.localizedDescription) }
                   })
                   taskUserRegister.resume()
            
        }else{
            
        }
            
               
        
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
