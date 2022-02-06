import Foundation

class CacheController {
    let cache = NSCache<NSString, NSArray>()
    static let shared = CacheController()
    private var articles = [Article]()

    
    // Function that goes to the APICaller and get the articles
    
    func setArticlesToCache(completion: @escaping (_ article: [Article]) -> ()) {
        APICaller.shared.getTopNews { [weak self] articles in
            self?.articles = articles
            self?.cache.setObject(articles as NSArray, forKey: "Articles")
           DispatchQueue.main.async {
               completion(self?.cache.object(forKey: "Articles") as! [Article])
           }
       }
    }
    // Function that handle the Cache if it needs to be updated or not
    func getArticlesByCache(completion: @escaping (_ article: [Article]) -> ()) {
        
        if self.cache.object(forKey: "Articles") == nil {
            NotificationController.shared.notification()
            self.setArticlesToCache { article in
                completion(article)
            }
        } else {
            NotificationController.shared.notification()
            
            let cachedArticles = self.cache.object(forKey: "Articles") as! [Article]
            completion(self.cache.object(forKey: "Articles") as! [Article])
            
            self.setArticlesToCache { article in
                if article[0].id > cachedArticles[0].id {
                    completion(article)
                }
            }
        }
    }
}
