//
//  Place_CreatePost_ViewController.swift
//  RaoVat2020
//
//  Created by Khoa Pham on 8/30/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit

protocol  City_Delegate {
    func chon_City(_id:String, Name:String)
}

class Place_CreatePost_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tbv_City: UITableView!
    
    var arrCity:[City] = []
    
    var delegate:City_Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tbv_City.dataSource = self
        tbv_City.delegate = self
        
        //load City
        let url = URL(string: Config.ServerURL +  "/city")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data , response, error in
            guard error == nil else { print("error"); return }
            guard let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            let listCity = try? jsonDecoder.decode(CityPostRoute.self, from: data)
            
            self.arrCity = listCity!.list
            
            DispatchQueue.main.async {
                self.tbv_City.reloadData()
            }
            
        })
        taskUserRegister.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityCell = tbv_City.dequeueReusableCell(withIdentifier: "CITY_CELL")
        cityCell?.textLabel?.text = arrCity[indexPath.row].Name
        return cityCell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.chon_City(_id: arrCity[indexPath.row]._id, Name: arrCity[indexPath.row].Name)
    }

}
