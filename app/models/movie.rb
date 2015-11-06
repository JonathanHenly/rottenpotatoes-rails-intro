class Movie < ActiveRecord::Base
  
  def self.get_ratings
    ['G', 'PG', 'PG-13', 'R']
  end
  
  def self.get_all_ratings_selected
    {"G" => "1", "PG" => "1", "PG-13" => "1", "R" => "1"}
  end
  
end
