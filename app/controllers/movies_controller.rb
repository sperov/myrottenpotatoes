class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # figure out all the sessions business first
    redirect_parameters = {}

    if params[:commit] || params[:ratings]
      session[:ratings] = params[:ratings] 
    elsif session[:ratings]
      redirect = true
    end
    redirect_parameters[:ratings] = session[:ratings]

    if params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      redirect = true
    end
    redirect_parameters[:sort] = session[:sort]

    redirect_to movies_path :ratings => session[:ratings], :sort => session[:sort] if redirect

    #this logic is now unchanged
    @all_ratings = Movie.ratings
    @movies = []

    @ratings = {}
    if params[:ratings] 
      @ratings = params[:ratings]
    else 
      @all_ratings.each do |rating|
        @ratings[rating] = 1
      end
    end

    # @movies = Movie.where(:rating => params[:ratings].keys) if params[:ratings]
    @movies = Movie.where(:rating => @ratings.keys)
    if @movies.any? && params[:sort]
      @movies = @movies.order(params[:sort])
      @title_highlight_class = "hilite" if params[:sort] == "title"
      @release_date_highlight_class = "hilite" if params[:sort] == "release_date"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
