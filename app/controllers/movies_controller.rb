class MoviesController < ApplicationController

enum all_ratings: [:'G',:'PG',:'PG-13',:'R']
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
    def index
    @movies = Movie.all
    
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
