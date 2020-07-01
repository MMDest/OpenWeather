//
//  Extentions.swift
//  OpenWeather
//
//  Created by MineDest on 5/8/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit
import ImageIO

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


