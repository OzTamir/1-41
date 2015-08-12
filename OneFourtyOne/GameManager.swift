//
//  ScoreManager.swift
//  OneFourtyOne
//
//  Created by Oz Tamir on 7/25/15.
//  Copyright (c) 2015 Oz Tamir. All rights reserved.
//

import UIKit

enum GameModes : String {
    case Easy = "easy"
    case Hard = "hard"
    case Countdown = "countdown"
}

class GameManager {
    
    // Game settings
    static let thinkTime = 1.41
    static let goalTime = 1.41
    static var gameMode : GameModes?
    
    class func setGameMode(newMode: GameModes) -> () {
        GameManager.gameMode = newMode
        AppDelegate.defaults.setObject(newMode.rawValue, forKey: "gameMode")
    }
    
    class func resetHighscores() -> () {
        AppDelegate.defaults.setDouble(0.0, forKey: "easyHighscore")
        AppDelegate.defaults.setDouble(0.0, forKey: "hardHighscore")
        AppDelegate.defaults.setDouble(0.0, forKey: "countdownHighscore")
    }
    
    class func getInstructionText() -> (String){
        switch GameManager.gameMode! {
            case .Easy:
                return "Press the button that says:"
            case .Hard:
                return "Press the name of the color of this text:"
            case .Countdown:
                // TODO: Decide whice mode is the Countdown mode
                return "Press the name of the color of this text:"
        }
    }
    
    class func getHighscore() -> (Double) {
        return AppDelegate.defaults.doubleForKey("\(GameManager.gameMode!.rawValue)Highscore")
    }
    
    class func setHighscore(newScore: Double) -> () {
        AppDelegate.defaults.setDouble(newScore, forKey: "\(GameManager.gameMode!.rawValue)Highscore")
    }

    
    // Format the score to show it on the label
    class func formatScore(score: Double) -> (String) {
            let formatString = "%.3f"
            return String(format: formatString, arguments: [score])
    }
    
    class func calculateScore(currentScore: Double, currentTime: NSTimeInterval?, startTime: NSTimeInterval?) -> (Double) {
        if let unwrappedMode = GameManager.gameMode {
            switch unwrappedMode {
                case .Easy, .Hard:
                    return self.calculateRegularScore(currentScore, currentTime: currentTime, startTime: startTime)
                case .Countdown:
                    return self.calculateCountdownScore(currentScore, currentTime: currentTime, startTime: startTime)
                default:
                    break
            }
        }
        return currentScore
    }
    
    class private func calculateRegularScore(currentScore: Double, currentTime: NSTimeInterval?, startTime: NSTimeInterval?) -> (Double) {
        let timeDelta = currentTime! - startTime!
        if timeDelta > self.goalTime {
            return currentScore
        }
        // I didn't just returned the expression because I'm sure the scoring system is due to changes
        let addition = Double(Int(timeDelta * 1000)) / 1000.0
        return addition + currentScore
    }
    
    class private func calculateCountdownScore(currentScore: Double, currentTime: NSTimeInterval?, startTime: NSTimeInterval?) -> (Double) {
        return calculateRegularScore(currentScore, currentTime: currentTime, startTime: startTime)
    }
    
    // -- DEPRECATED -- //
    class func getHighscoreForGameMode(mode: GameModes) -> (Double){
        return AppDelegate.defaults.doubleForKey("\(mode.rawValue)Highscore")
    }
    
    class func setHighscoreForGameMode(mode: GameModes, newScore: Double) -> () {
        AppDelegate.defaults.setDouble(newScore, forKey: "\(mode.rawValue)Highscore")
    }
}