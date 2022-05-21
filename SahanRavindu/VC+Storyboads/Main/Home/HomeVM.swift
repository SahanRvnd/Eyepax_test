//
//  HomeVM.swift
//  SahanRavindu
//
//  Created by Sahan Ravindu on 2022-05-21.
//

import Foundation


class HomeVM: BaseVM {
    //MARK: Variables
    var headlinePage = 1
    var everithingPage = 1
    var newsItems: [NewsItem] = []
    var headline: News?
    var everything: News?
    
    var titleHeader = NewsItem(title: ["Latest News"], news: [])
    var cateoryHeader = NewsItem(title: [], news: [])
    
    var selectedCategory: String = ""
    
    
    
}

extension HomeVM {
    func getHeadlines(isLoardMore: Bool = false, q: String, from: String, to: String, sortBy: String, perpage: Int, page: Int, completion: @escaping CompletionHandler) {
        guard NetworkReachability.isConnectedToNetwork() else {
            completion(false, 503, .InternetConnectionOffline)
            return
        }
        
        NewsApi.shared.getHeadings(q: q, from: from, to: to, sortBy: sortBy, perpage: perpage, page: page, completion:  { [weak self] (result, data)  in
            switch result {
            case .success(let responseModel):
                //                print(true, responseModel)
                self?.headline = nil
                self?.headline = responseModel
                
                if self?.headline?.articles?.count ?? 0 > 0 {
                    if isLoardMore {
                        self?.titleHeader.news?.append(contentsOf: self?.headline?.articles ?? [])
                    } else {
                        self?.titleHeader.news = self?.headline?.articles ?? []
                    }
                    
                    self?.addNewsList(newsItem: self?.titleHeader ?? NewsItem(title: [], news: []))
                    completion(true, 200, "")
                } else {
                    completion(false, 200, "There are no news reguarding this filters")
                }
                
            case .failure(let error):
                print(false, "Log in failed \(error.localizedDescription)")
                completion(true, 401, "Log in failed \(error.localizedDescription)")
            }
        })
        
    }
    
    func getEverything(isLoardMore: Bool = false, country: String, category: String, q: String, perpage: Int, page: Int, completion: @escaping CompletionHandler) {
        guard NetworkReachability.isConnectedToNetwork() else {
            completion(false, 503, .InternetConnectionOffline)
            return
        }
        
        NewsApi.shared.getEverything(country: country, category: category, q: q, perpage: perpage, page: page, completion:  { [weak self] (result, data)  in
            switch result {
            case .success(let responseModel):
                //                print(true, responseModel)
                self?.everything = nil
                self?.everything = responseModel
                
                if self?.everything?.articles?.count ?? 0 > 0 {
                    if isLoardMore {
                        self?.cateoryHeader.news?.append(contentsOf: self?.everything?.articles ?? [])
                    } else {
                        self?.cateoryHeader.news = self?.everything?.articles ?? []
                    }
                    
                    self?.addNewsList(newsItem: self?.cateoryHeader ?? NewsItem(title: [], news: []))
                    completion(true, 200, "")
                } else {
                    completion(false, 200, "There are no news reguarding this filters")
                }
                
            case .failure(let error):
                print(false, "Log in failed \(error.localizedDescription)")
                completion(true, 401, "Log in failed \(error.localizedDescription)")
            }
        })
        
    }
    
    func addNewsList(newsItem: NewsItem) {
        
        print("Item Count \(newsItem.title)")
        newsItems.append(newsItem)
        if newsItems.count ?? 0 > 0 {
        }
    }
    
}