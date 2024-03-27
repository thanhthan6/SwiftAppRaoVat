//
//  Register_ViewController.swift
//  RaoVat2020
//
//  Created by Khoa Pham on 8/17/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit


class Register_ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var txt_Username: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var txtHoTen: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_DiaChi: UITextField!
    @IBOutlet weak var txt_DienThoai: UITextField!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySpinner.isHidden = true
//        txt_Username.text = "demo"
//        txt_Password.text = "123"
//        txtHoTen.text = "Tran Demo"
//        txt_Email.text = "demo@gmail.com"
//        txt_DiaChi.text = "123 Abc"
//        txt_DienThoai.text = "098123123"
        
        
    }
    
    @IBAction func RegisterNewUser(_ sender: Any) {
        
        mySpinner.isHidden = false
        mySpinner.startAnimating()
        
        // Upload Avatar
        var url = URL(string: Config.ServerURL + "/uploadFile")
        let boundary = UUID().uuidString
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"hinhdaidien\"; filename=\"avatar.png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append((imgAvatar.image?.pngData())!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json  = jsonData as? [String: Any]{
                    if(json["kq"] as! Int == 1){
                        let urlFile = json["urlFile"] as? [String:Any]
                        
                        DispatchQueue.main.async {
                            
                            url = URL(string: Config.ServerURL +  "/register")
                            var request = URLRequest(url: url!)
                            request.httpMethod = "POST"
                            
                            let fileName = urlFile!["filename"] as! String
                            var sData = "Username=" + self.txt_Username.text!
                            sData += "&Password=" + self.txt_Password.text!
                            sData += "&Name=" +  self.txtHoTen.text!
                            sData += "&Image=" + fileName
                            sData += "&Email=" + self.txt_Email.text!
                            sData += "&Address=" + self.txt_DiaChi.text!
                            sData += "&PhoneNumber=" + self.txt_DienThoai.text!
                            
                            let postData = sData.data(using: .utf8)
                            request.httpBody = postData
                            
                            let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data , response, error in
                                guard error == nil else { print("error"); return }
                                guard let data = data else { return }
                                
                                do{
                                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else { return }
                                    
                                    DispatchQueue.main.async {
                                        self.mySpinner.isHidden = true
                                    }
                                    
                                    
                                    if( json["kq"] as! Int == 1 ){
                                        // Thanh cong
                                        // Push to Login Scene
                                        DispatchQueue.main.async {
                                            let alertView = UIAlertController(title: "Thông báo", message: ("Đăng ký thành công!"), preferredStyle: .alert)
                                            alertView.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                            self.present(alertView, animated: true, completion: nil)
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            let alertView = UIAlertController(title: "Thông báo", message: (json["errMsg"] as! String), preferredStyle: .alert)
                                            alertView.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                            self.present(alertView, animated: true, completion: nil)
                                        }
                                    }
                                    
                                }catch let error { print(error.localizedDescription) }
                            })
                            taskUserRegister.resume()
                        }
                        
                        
                     }else{
                        print("Upload failed!")
                    }
                }
            }
        }).resume()
    }
    
    
    @IBAction func ChooseImageFromPhotoGallery(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let login = sb.instantiateViewController(identifier: "LOGIN") as! Login_ViewController
        
        self.navigationController?.pushViewController(login, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            imgAvatar.image = image
        }else{  }
        self.dismiss(animated: true, completion: nil)
    }
    

}
