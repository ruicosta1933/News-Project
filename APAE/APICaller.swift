import Foundation

final class APICaller {
    static let shared = APICaller()

    struct Constants {
        static let toHeadlinesURL = URL(string: "https://api.spaceflightnewsapi.net/v3/articles")
        
        static let searchUrlString = "https://api.spaceflightnewsapi.net/v3/articles?title_contains="
        
        static let topBlogs = URL(string: "https://api.spaceflightnewsapi.net/v3/blogs")
    }
    
    private init() {}
    
    public func getTopNews(completion: @escaping (Result<[Article], Error>) -> Void) {
        
        guard let url = Constants.toHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    
                    let result = try JSONDecoder().decode([Article].self, from: data)
                    
                   
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func getBlog(completion: @escaping (Result<[Article], Error>) -> Void) {
        
        guard let url = Constants.topBlogs else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    
                    let result = try JSONDecoder().decode([Article].self, from: data)
                    
                   
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return 
        }
        
        
        
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode([Article].self, from: data)
                    
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
}

// Modules

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let id : Int
    let title: String
    let url: String?
    let imageUrl: String?
    let newsSite: String?
    let summary: String?
    let publishedAt: String?
   
}

