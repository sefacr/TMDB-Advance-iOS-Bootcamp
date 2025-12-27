//
//  TMDBImageManager.swift
//  MovieMVC
//
//  Created by Seyfeddin Bassarac on 24.09.2025.
//

import UIKit

class TMDBImageManager {
    static let shared = TMDBImageManager()
    
    private let baseURL = "https://image.tmdb.org/t/p/"
    private init() {}
    
    func loadTMDBImage(filePath: String, size: String = "w500", completion: @escaping (UIImage?) -> Void) {
        let urlString = "\(baseURL)\(size)\(filePath)"
        
        if let cachedImage = ImageCacheManager.shared.image(forKey: urlString) {
             completion(cachedImage)
             return
         }
        
        guard let url = URL(string: urlString) else {
            print("Invalid image URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Image download failed: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                completion(nil)
                return
            }
            
            ImageCacheManager.shared.save(image, forKey: urlString)
            completion(image)
        }.resume()
    }
}

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {
        cache.countLimit = 50
        cache.totalCostLimit = 30 * 1024 * 1024 // 30 MB
    }
    
    private let cache = NSCache<NSString, UIImage>()
    
    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func save(_ image: UIImage, forKey key: String) {
        let cost = image.pngData()?.count ?? 0
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }
}

extension UIImageView {
    func setTMDBImage(filePath: String, size: String = "w500") {
        TMDBImageManager.shared.loadTMDBImage(filePath: filePath, size: size) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image ?? UIImage(named: "no-poster")
            }
        }
    }
}
