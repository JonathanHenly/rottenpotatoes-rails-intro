class Movie < ActiveRecord::Base
  
  def self.getRatings
    ['G', 'PG', 'PG-13', 'R']
  end
  
end
