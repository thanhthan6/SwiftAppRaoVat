//
//  Category_CreatePost_ViewController.swift
//  RaoVat2020
//
//  Created by Khoa Pham on 8/30/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit

protocol Category_Delegate {
    func chonNhom(idNhom:String, tenNhom:String)
}

class Category_CreatePost_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate:Category_Delegate?
    
    @IBOutlet weak var myTable_Cate: UITableView!
    
    var arr_Cate:[Category] = []
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.chonNhom(idNhom: arr_Cate[indexPath.row]._id, tenNhom: arr_Cate[indexPath.row].Name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable_Cate.dataSource = self
        myTable_Cate.delegate = self
        
        //load Cate
        let url = URL(string: Config.ServerURL +  "/category")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data , response, error in
            guard error == nil else { print("error"); return }
            guard let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            let listCate = try? jsonDecoder.decode(CategoryPostRoute.self, from: data)
            
            self.arr_Cate = listCate!.CateList
            
            DispatchQueue.main.async {
                self.myTable_Cate.reloadData()
            }
            
        })
        taskUserRegister.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Cate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cateCell = myTable_Cate.dequeueReusableCell(withIdentifier: "CATE_CELL") as! Cate_CreatePost_TableViewCell
        
        cateCell.lbl_CateName.text = arr_Cate[indexPath.row].Name
        
        let queueLoadCateImg = DispatchQueue(label: "queueLoadCateImg")
        queueLoadCateImg.async {
            
            let urlCateImmg = URL(string: Config.ServerURL +  "/upload/" +  self.arr_Cate[indexPath.row].Image)
            print(Config.ServerURL +  "/upload/" +  self.arr_Cate[indexPath.row].Image)
            do{
                let dataCateImg = try Data(contentsOf: urlCateImmg!)
                DispatchQueue.main.async {
                    cateCell.img_Cate.image = UIImage(data: dataCateImg)
                }
            }catch{ }
            
        }
        
        return cateCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height/4
    }


}
