//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Виктория Демченко on 06.04.24.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gameCount: Int { get }
    var bestGame: GameRecord { get }
}

class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gameCount
    }
    
    func store(correct count: Int, total amount: Int) {
        let newGameRecord = GameRecord(correct: count, total: amount, date: Date())
        
        if newGameRecord.isBestRecord(then: bestGame) {
            bestGame = newGameRecord
        }
        
        gameCount += 1
        totalAccuracy = (totalAccuracy + Double(amount / count)) / Double(gameCount)
    }
    
    var totalAccuracy: Double {
        get{
            return userDefaults.double(forKey: Keys.total.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    var gameCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gameCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gameCount.rawValue)
        }
    }
    var bestGame: GameRecord {
        get{
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return.init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        set{
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    private let userDefaults = UserDefaults.standard
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBestRecord (then anotherRecord: GameRecord) -> Bool {
        return self.correct > anotherRecord.correct
    }
}
