class MoviesController < ApplicationController
   
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
   
    @all_ratings = ['G','PG','PG-13','R']
    
    if params[:ratings]
      session[:ratings]=params[:ratings]
      @all_ratings = params[:ratings].keys
    elsif session[:ratings]
     if session[:sort_by].nil?
       redirect_to movies_path({:ratings => session[:ratings]})
     end
    end
    
    if (params[:sort_by])
      @sort_by =params[:sort_by]
      session[:sort_by]=@sort_by
      @movies =Movie.order(@sort_by)
      !(@all_ratings.nil?) ? @movies.finad_all_by_rating(@all_ratings): @movies
    elsif session[:sort_by]
      @sort_by = session[:sort_by]
      redirect_to movies_path({:sort_by => sort_by, :ratings => session[:ratings]})
    else 
      @movie=Movie.finad_all_by_rating(@all_ratings)
    end
  end
  

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
