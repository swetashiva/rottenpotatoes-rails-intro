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
    @first=params[:ratings]
    there = false
    @all_ratings = Movie.distinct.pluck(:rating)
    @movies = Movie.all
    
    if params[:ratings].present?
      @current_ratings=params[:ratings].keys
      session[:ratings]=params[:ratings]
      @movies = @movies.where(rating: @current_ratings)
    elsif session[:ratings].present?
     params[:ratings]=session[:ratings]
     there=true
    else 
      @current_ratings=Movie.distinct.pluck(:rating)
    end
  
    if params[:sort_by].present?
      @sort_by=params[:sort_by]
      session[:sort_by]=params[:sort_by]
      @movies = @movies.order(@sort_by)
    elsif session[:sort_by].present?
     params[:sort_by]=session[:sort_by]
     there=true
    end
    
    if there
      flash.keep
      redirect_to movies_path(params.slice(:ratings, :sort_by))
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
