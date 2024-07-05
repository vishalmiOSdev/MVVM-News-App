//
//  NewsListCell.swift
//  Quick App
//
//  Created by Vishal Manhas on 04/07/24.
//

import UIKit

class NewsListCell: UITableViewCell {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
   
    var urlString = ""
    func configure(with article: Article) {
        
        
        self.urlString = article.url
        authorLabel.text = article.author ?? "Unknown"
        titleLabel.text = article.title
        descriptionLabel.text = article.description ?? ""
        urlLabel.text = article.url
        publishedAtLabel.text = article.publishedAt
        
        urlLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openURL))
        urlLabel.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func openURL() {
        if let url = URL(string: self.urlString) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
      }
   
}
