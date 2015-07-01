class Matchup < ActiveRecord::Base
  belongs_to :competition

  def self.generate_matches(round, lower, teams, size, comp_id)
    if !lower && round == 1
      match = 1
      teams_used = 0

      (0..size/2).each do
        teams_to_use = []

        (0..1).each do
          if teams_used < teams.length
            teams_to_use.push(teams[teams_used].id)
            teams_used += 1
          else
            teams_to_use.push(0)
          end
        end
        if match <= size/2
          Matchup.new(team1_id: teams_to_use[0], team2_id: teams_to_use[1], round_number: round, match_number: match, lower_bracket: lower, competition_id: comp_id).save
          match += 1
        end
      end
    else
      match = 1
      puts size
      if size == 2
        size = 0
      end
      (0..(size/2)).each do |i|
        puts i
        Matchup.new(round_number: round, match_number: match, lower_bracket: lower, competition_id: comp_id).save
        match += 1
      end
    end
  end
#  create_table "matchups", force: :cascade do |t|
#    t.integer  "team1_id"
#    t.integer  "team2_id"
#    t.datetime "start_time"
#    t.integer  "round_number"
#    t.integer  "match_number"
#    t.boolean  "lower_bracket"
#    t.integer  "competition_id"
#    t.integer  "result_id"
#    t.datetime "created_at",     null: false
#    t.datetime "updated_at",     null: false
#  end
end
