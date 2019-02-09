class Movie < ActiveRecord::Base
   def sort_by_title(movies)
    for i in 0 .. movies.length
    for j in i .. movies.length
        if(movies[i].title < movies[j].title)
            string temp;
            temp = movies[i].title;
            movies[i].title=movies[j].title;
            movies[j].title=temp;
        end
    end
    end
   end
end
