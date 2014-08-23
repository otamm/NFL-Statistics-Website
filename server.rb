require 'sinatra'

#the team data is below; I could not find any decent CSV or JSON file within a quick internet search, but the
#program is supposed to work with an array of hashes of any size anyway.
$teams= [
  {
    home_team: "Patriots",
    away_team: "Broncos",
    home_score: 7,
    away_score: 3
  },
  {
    home_team: "Broncos",
    away_team: "Colts",
    home_score: 3,
    away_score: 0
  },
  {
    home_team: "Patriots",
    away_team: "Colts",
    home_score: 11,
    away_score: 7
  },
  {
    home_team: "Steelers",
    away_team: "Patriots",
    home_score: 7,
    away_score: 21
  }
]

#methods

#this one will determine the total points of each team, and the total wins/losses
def total_score(team)
  points = {name: team, total_scored: 0 , total_suffered: 0, point_balance: 0, wins: 0, losses: 0, victory_balance: 0}
  $teams.each do |game|
    if points[:name] == game[:home_team]
      points[:total_scored] += game[:home_score]
      points[:total_suffered] += game[:away_score]
      points[:wins] += 1 if game[:home_score] > game[:away_score]
      points[:losses] += 1 if game[:home_score] < game[:away_score]
    elsif points[:name] == game[:away_team]
      points[:total_scored] += game[:away_score]
      points[:total_suffered] += game[:home_score]
      points[:wins] += 1 if game[:home_score] < game[:away_score]
      points[:losses] += 1 if game[:home_score] > game[:away_score]
    end
  end
  points[:victory_balance] = points[:wins] - points[:losses]
  points[:point_balance] = points[:total_scored] - points[:total_suffered]

  return points
end


#this will return the total, ordered leaderboard.
def leaderboard()
  leaderboard = []
  $teams.each do |match|
    leaderboard << match[:home_team]
    leaderboard << match[:away_team]
  end

  leaderboard.uniq!
  leaderboard.each_with_index { |points,i| leaderboard[i] = total_score(points) }
  leaderboard = leaderboard.sort_by { |balance| balance[:victory_balance] }.reverse

  leaderboard
end

#returns an array of hashes of all the games this team has played.
def games_played(team)
  played = []
  $teams.each { |game| played << game if game[:home_team] == team || game[:away_team] == team }
  played
end

get '/' do
  @games_so_far = $teams
  erb :games_so_far
end



get '/leaderboards' do
  @leaderboards = leaderboard()
  erb :leaderboards
end

get '/teams/:team_name' do
  @team_page = params[:team_name]
  @total = total_score(@team_page)
  @participated = games_played(@team_page)
  erb :team_page
end


