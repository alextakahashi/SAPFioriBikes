//
//  ViewController.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/14/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var model: [Station] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let jsonURLString: URL = URL(string: "https://gbfs.fordgobike.com/gbfs/en/station_information.json")else { return }
        URLSession.shared.dataTask(with: jsonURLString) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                guard let strongSelf = self else { return }
                let request = try JSONDecoder().decode(APIRequest.self, from: data)
                guard let stations = request.data?.stations else { return }
                strongSelf.model = stations.compactMap({return $0})
                for station in strongSelf.model {
                    print(station.name)
                }
            } catch let jsonError {
                print("❌ \(jsonError)")
            }
        }.resume()
    }
}

