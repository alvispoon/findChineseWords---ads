import Foundation

extension UserDefaults {
  enum Key: String {
    case reviewWorthyActionCount
    case lastReviewRequestAppVersion
    case passLevel
  }

  func integer(forKey key: Key) -> Int {
    return integer(forKey: key.rawValue)
  }

  func string(forKey key: Key) -> String? {
    return string(forKey: key.rawValue)
  }

  func set(_ integer: Int, forKey key: Key) {
    set(integer, forKey: key.rawValue)
  }

  func set(_ object: Any?, forKey key: Key) {
    set(object, forKey: key.rawValue)
  }
    
    
    func convertLevelScoresToDictionaries(levelScores: [LevelScore]) -> [[String: Any]] {
        return levelScores.map { ["key": $0.key, "value": $0.value] }
    }
    
}

struct LevelScore {
    var key: String
    var value: Int
}

struct ScoreManager {
    static func convertLevelScoresToDictionaries(levelScores: [LevelScore]) -> [[String: Any]] {
        return levelScores.map { ["key": $0.key, "value": $0.value] }
    }

    static func saveLevelScoresToUserDefaults(levelScores: [LevelScore]) {
        let dictionaries = convertLevelScoresToDictionaries(levelScores: levelScores)
        UserDefaults.standard.set(dictionaries, forKey: "levelScoresKey")
    }

    static func retrieveLevelScoresFromUserDefaults() -> [LevelScore] {
        guard let storedDictionaries = UserDefaults.standard.array(forKey: "levelScoresKey") as? [[String: Any]] else {
            return []
        }

        return storedDictionaries.map { LevelScore(key: $0["key"] as! String, value: $0["value"] as! Int) }
    }
}
