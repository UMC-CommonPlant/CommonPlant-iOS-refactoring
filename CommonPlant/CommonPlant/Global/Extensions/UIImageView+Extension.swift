//
//  UIImageView+Extension.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/02.
//

import UIKit

extension UIImageView {
    func load(url: URL, completion: @escaping () -> Void = {}) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completion()
                    }
                }
            }
        }
    }
}
