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
    @all_ratings = Movie.get_ratings
    ratings = params[:ratings] ||= session[:ratings]
    sorting = params[:sort_by] ||= session[:sort_by]
    
    @movies = Movie.all unless ratings || sorting
    
    if ratings then
      session[:ratings] = ratings
      @movies = Movie.where(:rating => ratings.keys)
    end
    
    # if the sort_by or session sort_by parameter is non-nil
    if sorting then
      session[:sort_by] = sorting
      @movies = @movies.order(sorting.to_sym)
      # check which header to highlight
      if sorting == 'title'
        @title_header = 'hilite'
      elsif sorting == 'release_date'
        @release_date_header = 'hilite'
      end
    end
    #request.session.each {|key, value| puts key.to_s + " --> " + value.to_s }
    
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
