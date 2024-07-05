//
//  ViewController.swift
//  MindPause
//
//  Created by Vishal Manhas on 22/04/24.
//

import UIKit

class NewsListVC: UIViewController {
    
    let viewModel = PostViewModel()
    
    var article:[Article]?
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTable()
        
        Task{
            await viewModel.fetchPosts()
            
        }
        viewModel.delegate = self
        
    }
    
    
    func configureTable(){
        self.title = "News"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNIBs(identifiers: [CellId.newsListCell])
    }
    
}

extension NewsListVC :UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        article?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellId.newsListCell, for: indexPath) as? NewsListCell {
            
            if let article = article{
                cell.configure(with: article[indexPath.row])
            }
            
            return cell
            
        }
        return UITableViewCell()
    }
}

extension NewsListVC: PostViewModelDelegate{
    func didFetchNews(posts: NewsResponse) {
        self.article = posts.articles
        self.tableView.reloadData()
    }
    
    func failedToFetchNews(error: NetworkError) {
        self.showStatus(title: "NetworkError.decodingError", description: "NetworkError.decodingError" )
    }
    
}
