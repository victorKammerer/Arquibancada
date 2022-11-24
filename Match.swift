import Foundation

struct Match : Codable{
    var status : String
    var gamedata : GameData
}

struct GameData : Codable{
    var _id : String
    var away_score : Int
    var away_scorers : [String]
    var away_team_id : String
    var finished : String
    var group : String
    var home_score : Int
    var home_scorers : [String]
    var home_team_id : String
    var id : String
    var local_date : String
    var matchday : String
    var persian_date : String
    var stadium_id : String
    var time_elapsed : String
    var type : String
    var home_team_fa : String
    var away_team_fa : String
    var home_team_en : String
    var away_team_en : String
    var home_flag : String
    var away_flag : String
}
