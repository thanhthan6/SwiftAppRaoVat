//
//  CreatePoost_ViewController.swift
//  RaoVat2020
//
//  Created by Khoa Pham on 8/30/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit

extension CreatePoost_ViewController:Category_Delegate {
    func chonNhom(idNhom:String, tenNhom:String){
        self.navigationController?.popViewController(animated: true)
        lbl_Nhom.text = tenNhom
        idNhom_Update = idNhom
    }
}

extension CreatePoost_ViewController:City_Delegate{
    func chon_City(_id:String, Name:String){
        self.navigationController?.popViewController(animated: true)
        lbl_NoiBan.text = Name
        idCity_Update = _id
    }
}

class CreatePoost_ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lbl_Nhom: UILabel!
    @IBOutlet weak var lbl_NoiBan: UILabel!
    @IBOutlet weak var txt_TieuDe: UITextField!
    @IBOutlet weak var txt_Gia: UITextField!
    @IBOutlet weak var txt_DienThoai: UITextField!
    var idNhom_Update:String?
    var idCity_Update:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Tap_Image(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            imgPost.image = image
        }else{  }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chon_NHOM(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var chonCate_VC = sb.instantiateViewController(identifier: "CATE_CREATE_POST")
            as! Category_CreatePost_ViewController
        chonCate_VC.delegate = self
        self.navigationController?.pushViewController(chonCate_VC, animated: true)
    }
    
    @IBAction func Chon_Noi_Ban(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let place_createPost_VC = sb.instantiateViewController(identifier: "PLACE_CREATEPOST") as!  Place_CreatePost_ViewController
        place_createPost_VC.delegate = self
        self.navigationController?.pushViewController(place_createPost_VC, animated: true)
    }
    
    
    @IBAction func DangTin(_ sender: Any) {
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
        data.append((imgPost.image?.pngData())!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json  = jsonData as? [String: Any]{
                    if(json["kq"] as! Int == 1){
                        let urlFile = json["urlFile"] as? [String:Any]
                        
                        DispatchQueue.main.async {
                            
                            url = URL(string: Config.ServerURL +  "/post/add")
                            var request = URLRequest(url: url!)
                            request.httpMethod = "POST"
                            
                            let fileName = urlFile!["filename"] as! String
                            
                            var sData = "TieuDe=" + self.txt_TieuDe.text!
                            sData += "&Gia=" + self.txt_Gia.text!
                            sData += "&DienThoai=" +  self.txt_DienThoai.text!
                            sData += "&Image=" + fileName
                            sData += "&Nhom=" + self.idNhom_Update!
                            sData += "&NoiBan=" + self.idCity_Update!
                            
                            let postData = sData.data(using: .utf8)
                            request.httpBody = postData
                            
                            let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data , response, error in
                                guard error == nil else { print("error"); return }
                                guard let data = data else { return }
                                
                                do{
                                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else { return }
            
                                    if( json["kq"] as! Int == 1 ){
                                        DispatchQueue.main.async {
                                            let alertView = UIAlertController(title: "Thong bao", message: "Post thanh cong", preferredStyle: .alert)
                                            alertView.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
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
                        
                        
                     }else{
                        print("Upload failed!")
                    }
                }
            }
        }).resume()
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

