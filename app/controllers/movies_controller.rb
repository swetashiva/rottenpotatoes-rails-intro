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
    @movies = Movie.all
    
    #sorting the rating parameters
    if params[:ratings]
      @ratings_params = params[:ratings].keys
    else
      if session[:ratings]
        @ratings_params = session[:ratings]
      else
        @all_ratings ['G'] =1
        @all_ratings ['PG'] =1
        @all_ratings ['PG-13'] =1
        @all_ratings ['R'] =1
        @ratings_params = @all_ratings
      end
    end
    
    if @ratings_params!=session[:ratings]
      session[:ratings] = @ratings_params
    end
    
    @movies = @movies.where('rating in (?)', @ratings_params)
    
    #storing the sorting parameters
    if params[:sort]
      @sorting_params = params[:sort]
    else
      @sorting_params = session[:sort]
    end
    
    if @sorting_params!=session[:sort]
      session[:sort] = @sorting_params
    end
    
    if @sorting_params == 'title'
          @movies = @movies.order(@sorting_params)
          @sort_by_title = 'hilite'
    elsif @sorting_params == 'release_date'
          @movies = @movies.order(@sorting_params)
          @sort_by_release_date = 'hilite'
    else  @movies= Movie.all
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
