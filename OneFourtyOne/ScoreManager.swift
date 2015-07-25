//
//  ScoreManager.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/25/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import UIKit

class ScoreManager {
    
    static let goalTime = 1.41
    
    class func resetHighscores() -> () {
        AppDelegate.defaults.setDouble(0.0, forKey: "arcadeHighscore")
        AppDelegate.defaults.setDouble(1.42, forKey: "speedHighscore")
        AppDelegate.defaults.setDouble(0.0, forKey: "countdownHighscore")
    }
    
    class func getHighscoreForGameMode(mode: GameModes) -> (Double){
        return AppDelegate.defaults.doubleForKey("\(mode.rawValue)Highscore")
    }
    
    class func setHighscoreForGameMode(mode: GameModes, newScore: Double) -> () {
        AppDelegate.defaults.setDouble(newScore, forKey: "\(mode.rawValue)Highscore")
    }
    
    // Format the score to show it on the label
    class func formatScore(score: Double) -> (String) {
            let formatString = "%.3f"
            return String(format: formatString, arguments: [score])
    }
    
    class func calculateScoreForGameMode(mode: GameModes?, currentScore: Double, currentTime: NSTimeInterval?, startTime: NSTimeInterval?) -> (Double) {
        if let unwrappedMode = mode {
            switch unwrappedMode {
                case .Arcade:
                    return self.calculateArcadeScore(currentScore, currentTime: currentTime, startTime: startTime)
                case .Speed:
                    return self.calculateSpeedScore(currentScore, currentTime: currentTime, startTime: startTime)
                case .Countdown:
                    return self.calculateCountdownScore(currentScore, currentTime: currentTime, startTime: startTime)
            }
        }
        return currentScore
    }
    
    class private func calculateArcadeScore(currentScore: Double, currentTime: NSTimeInterval?, startTime: NSTimeInterval?) -> (Double) {
        let timeDelta = currentTime! - startTime!
        if timeDelta > self.goalTime {
            return currentScore
        }
        // I didn't just returned the expression because I'm sure the scoring system is due to changes
        let addition = Double(Int(timeDelta * 1000)) / 1000.0
        return addition + currentScore
    }
    
    class private func calculateSpeedScore(currentScore: Double, currentTime: NSTimeInterval?, startTime: NSTimeInterval?) -> (Double) {
        let timeDelta = currentTime! - startTime!
        if timeDelta > self.goalTime {
            return currentScore
        }
        else if currentScore == 0.0{
            return timeDelta
        }
        return min(currentScore, timeDelta)
        
    }
    
    class private func calculateCountdownScore(currentScore: Double, currentTime: NSTimeInterval?, startTime: NSTimeInterval?) -> (Double) {
        return calculateArcadeScore(currentScore, currentTime: currentTime, startTime: startTime)
    }
}