//
//  APIManager.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import Foundation
import UIKit

protocol CanRemoveCustomLoadingDelegate {
    func removeCustomLoading()
}

class APIManager {
    
    static let shared = APIManager()
    
    private let timeout = 15.0
    private let session = URLSession(configuration: .default)
    
    private var cacheImage = NSCache<NSURL, UIImage>()
    var allPlayersArray = [Player]()
    var delegate: CanRemoveCustomLoadingDelegate? = nil
    
    var allPlayersLoaded = false {
        didSet {
            guard allPlayersLoaded else {return}
            self.delegate?.removeCustomLoading()
        }
    }
    
    private var observer: NSObjectProtocol?
    private init(delegate: CanRemoveCustomLoadingDelegate? = nil) {
        self.delegate = delegate
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { [weak self] notification in
            self?.cacheImage.removeAllObjects()
        }
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        self.delegate = nil
    }
    
    //MARK: APIs
    func getAllPlayersFromBE() {
        var page = 1
        var totalPages = 0
        
        func reiterate() {
            DispatchQueue.main.async {
                self.getAllPlayers(page: page) { [weak self] (data) in
                    
                    guard let self = self else { return }
                    
                    if totalPages == 0 { totalPages = data.meta.totalPages }
                    guard totalPages != 0 else {return}
                    
                    if let players = data.data {
                        self.allPlayersArray+=players
                    }
                    
                    guard let nextPage = data.meta.nextPage else {
                        self.allPlayersLoaded = true
                        self.allPlayersArray = Array(Set(self.allPlayersArray))
                        return
                    }
                    
                    page = nextPage
                    reiterate()
                } failure: { (error) in
                    NSLog(error.message ?? "error")
                }
            }
        }
        
        reiterate()
        
    }
    
    func getAllPlayers(page: Int, success:@escaping(ResultData<Player>) -> Void,  failure:@escaping(ErrorMessage) -> Void) {
        
        guard
            let link = ResourcePath.getAllPlayers.add(values: ["\(page)", "\(100)"], suffixs: [.page, .perPage]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let urlOK = URL(string: link) else
        {
            let errorMessage = ErrorMessage(customMessage: "The link provided is invalid")
            failure(errorMessage)
            return
        }
        
        callAPI(method: .get, url: urlOK) { (players) in
            success(players)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getSpecificPlayer(id: String, success:@escaping(Player) -> Void,  failure:@escaping(ErrorMessage) -> Void) {
        
        guard
            let link = ResourcePath.getSpecificPlayer.add(values: [id], suffixs: [.id]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let urlOK = URL(string: link) else
        {
            let errorMessage = ErrorMessage(customMessage: "The link provided is invalid")
            failure(errorMessage)
            return
        }
        
        callAPI(method: .get, url: urlOK) { (player) in
            success(player)
        } failure: { (error) in
            failure(error)
        }
        
    }
    
    func getAllTeams(page: Int, success:@escaping(ResultData<Team>) -> Void,  failure:@escaping(ErrorMessage) -> Void) {
        
        guard
            let link = ResourcePath.getAllTeams.add(values: ["\(page)"], suffixs: [.page]) .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let urlOK = URL(string: link) else
        {
            let errorMessage = ErrorMessage(customMessage: "The link provided is invalid")
            failure(errorMessage)
            return
        }
        
        callAPI(method: .get, url: urlOK) { (teams) in
            success(teams)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getSpecificTeam(id: String, success:@escaping(Team) -> Void,  failure:@escaping(ErrorMessage) -> Void) {
        
        guard
            let link = ResourcePath.getSpecificTeam.add(values: [id], suffixs: [.id]).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let urlOK = URL(string: link) else
        {
            let errorMessage = ErrorMessage(customMessage: "The link provided is invalid")
            failure(errorMessage)
            return
        }
        
        callAPI(method: .get, url: urlOK) { (team) in
            success(team)
        } failure: { (error) in
            failure(error)
        }
        
    }
    
    func getTeamLogo(abbreviation: String, completion:@escaping(UIImage?) -> Void) {
        
        guard
            let link = ResourcePath.teamLogo.getTeamLogo(from: abbreviation.lowercased()).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
        {
            completion(nil)
            return
        }
        
        self.downloadMedia(link: link, completion: completion)
    }
    
    
    //MARK: Call function
    private func callAPI<T: Decodable>(method: Methods, url: URL, success:@escaping(T) -> Void,  failure:@escaping(ErrorMessage) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let headers = Constants.headers
        request.allHTTPHeaderFields = headers
        
        request.timeoutInterval = self.timeout
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let errorOK = error {
                let errorMessage = ErrorMessage(customMessage: errorOK.localizedDescription)
                failure(errorMessage)
                return
            }
            
            guard let data = data else {
                let errorMessage = ErrorMessage(customMessage: "No data available")
                failure(errorMessage)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let errorMessage = ErrorMessage(customMessage: "Response error")
                failure(errorMessage)
                return
            }
            
            NSLog("URL: %@, Status Code: %d", url.absoluteString, httpResponse.statusCode)
            
            switch httpResponse.statusCode {
            case 200...299:
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    success(decodedData)
                } catch (let error) {
                    let errorMessage = ErrorMessage(customMessage: error.localizedDescription)
                    failure(errorMessage)
                }
                
            default:
                do {
                    let error = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    failure(error)
                } catch (let error) {
                    let errorMessage = ErrorMessage(customMessage: error.localizedDescription)
                    failure(errorMessage)
                }
            }
            
        }
        task.resume()
        
    }
    
}

//MARK: Endpoint
extension APIManager {
    
    private struct Constants {
        static let baseURL = "https://free-nba.p.rapidapi.com/"
        static let teamsLogoURL = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/"
        static let headers = ["x-rapidapi-key":"63ef1fa9c5mshf6d16c8cb5a9045p1ea31fjsn39178b3f323a"]
    }
    
    private enum ResourcePath: String {
        case getSpecificPlayer = "players/<id>"
        case getAllPlayers = "players?page=<page>&per_page=<per_page>"
        case getSpecificTeam = "teams/<id>"
        case getAllTeams = "teams?page=<page>"
        case teamLogo = "<abbreviation>"
        
        var path: String {
            return Constants.baseURL + rawValue
        }
        
        var pathTeamLogo: String {
            return Constants.teamsLogoURL + rawValue
        }
        
        func getTeamLogo(from abbreviation:String) -> String {
            var result = Constants.teamsLogoURL + rawValue
            result = result.replacingOccurrences(of: ResourcePath.teamLogo.rawValue, with: abbreviation)
            return result + ".png"
        }
        
        func add(values:[String], suffixs:[Parameters]) -> String {
            var result = Constants.baseURL + rawValue
            for (index, value) in values.enumerated() {
                let suffix = suffixs[index]
                result = result.replacingOccurrences(of: suffix.rawValue, with: value)
            }
            return result
        }
        
        enum Parameters: String {
            case id = "<id>"
            case page = "<page>"
            case perPage = "<per_page>"
            case abbreviation = "<abbreviation>"
        }
    }
    
}

//MARK: Utilities
extension APIManager {
    
    private enum Methods: String {
        case get = "GET"
        case post = "POST"
    }
    
    private func downloadMedia(link: String?, completion:@escaping(UIImage?) -> Void) {
        guard let linkOK = link, let url = URL(string: linkOK) else {completion(nil); return}
        
        func urlSession() -> URLSession {
            let config = URLSessionConfiguration.ephemeral
            return  URLSession(configuration: config)
        }
        
        if let imageCache = self.cacheImage.object(forKey: url as NSURL) {
            completion(imageCache)
        } else {
            urlSession().dataTask(with: url) { [weak self] (data, response, error) in
                
                guard let responseData = data, let image = UIImage(data: responseData), error == nil else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                self?.cacheImage.setObject(image, forKey: url as NSURL, cost: responseData.count)
                DispatchQueue.global().async {
                    completion(image)
                }
                
            }.resume()
            
        }
          
    }
    
}
