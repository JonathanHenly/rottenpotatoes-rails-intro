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
    
    @selected_ratings = params[:ratings]
    sorting = params[:sort_by]
    re_direct = false
    
    if session[:ratings] && !@selected_ratings then
      re_direct = true
      flash.keep
      @selected_ratings = session[:ratings]
    end
    
    if session[:sort_by] && !sorting then
      re_direct = true
      flash.keep
      sorting = session[:sort_by]
    end
    
    if re_direct then redirect_to movies_path(:ratings => @selected_ratings, :sort_by => sorting) end
    
    # if selected ratings is non-nil
    if @selected_ratings then
      # store the selected ratings in the session
      session[:ratings] = @selected_ratings
      @movies = (@movies ||= Movie).where(:rating => @selected_ratings.keys)
    else
      @selected_ratings = Movie.get_all_ratings_selected
    end
    
    # if the sort_by parameter is non-nil
    if sorting then
      # store the sorting in the session
      session[:sort_by] = sorting
      @movies = (@movies ||= Movie).order(sorting.to_sym)
      # check which header to highlight
      if sorting == 'title'
        @title_header = 'hilite'
      elsif sorting == 'release_date'
        @release_date_header = 'hilite'
      end
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
