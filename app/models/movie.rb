class Movie < ActiveRecord::Base

        def self.with_ratings(ratings_params)
         @movies.where('rating in (?)', @ratings_params)
        end
end
