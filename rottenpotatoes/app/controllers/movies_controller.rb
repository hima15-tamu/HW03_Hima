# frozen_string_literal: true

# MoviesControllerClass inherited from Application Controller class
class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
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
    @movie.update!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  # def destroy
  #  @movie = Movie.find(params[:id])
  #  @movie.destroy
  #  flash[:notice] = "Movie '#{@movie.title}' deleted."
  #  redirect_to movies_path
  # end

  def show_by_director
    @movie = Movie.find(params[:id])
    if @movie.director.blank?
      redirect_to movies_path
      # flash[:warning] ="No director info for: #{@movie.title} !!!"
      flash[:warning] = "'#{@movie.title}' has no director info"
    else
      @movies = @movie.others_by_same_director
      @director = @movie.director
    end
  end

  private

  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :director, :rating, :description, :release_date)
  end
end
