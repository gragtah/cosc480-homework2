# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def self.getUniqueRatings
    Movie.uniq.pluck(:rating)
  end

  def index
    @all_ratings = MoviesController.getUniqueRatings
    if params[:sort_by] == "movie_title"
        @title_class = "hilite"
    end
    if params[:sort_by] == "release_date"
        @release_date_class = "hilite"
    end
    @chosen_ratings = params[:ratings]==nil ? @all_ratings : params[:ratings].keys
    @movies = Movie.where(:rating => @chosen_ratings).order(params[:sort_by])
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
    # will render app/views/movies/show.html.haml by default
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
