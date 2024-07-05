//
//  PostViewModel.swift
//  MindPause
//
//  Created by Vishal Manhas on 23/04/24.
//

import Foundation


protocol PostViewModelDelegate: AnyObject {
    func didFetchNews(posts: NewsResponse)
    func failedToFetchNews(error: NetworkError)
}

@MainActor
class PostViewModel {
    
    weak var delegate: PostViewModelDelegate?
    
    func fetchPosts() async {
        
        guard let url = URL(string: "\(URLAsset.baseURLString())\(APIServices.newsURl.rawValue)") else {
            delegate?.failedToFetchNews(error: .badURL)
            return
        }
        
        do{
            let response = try await  Webservice.shared.doRequestAsync(url, type: .get, responseFromServer: NewsResponse.self)
                self.delegate?.didFetchNews(posts: response)
        }catch{
            delegate?.failedToFetchNews(error: .invaildResponse)
            
        }
        
    }
}





// Mark: - legacy call using completion handler

/*   Webservice.shared.doRequest(url, type: .get, responseFromServer:[SudhrshanResponse].self) {
            [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFetchNews(posts: response)
                }
            case .failure(let error):

                DispatchQueue.main.async { [weak self] in

                        self?.delegate?.failedToFetchNews(error: error as! NetworkError )
                }
            }
        }

*/

