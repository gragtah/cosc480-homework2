# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def self.getUniqueRatings
    Movie.uniq.pluck(:rating)
  end

  def index
    @all_ratings = MoviesController.getUniqueRatings
    if params[:sort_by] == "title"
        @title_class = "hilite"
    elsif params[:sort_by] == "release_date"
        @release_date_class = "hilite"
    end
    if !session.has_key?(:ratings)
        @all_ratings.each { |rating| session[:ratings][rating] = 1}
    end
    if !params[:ratings] and session[:ratings]
        flash.keep
        return redirect_to movies_path(@movies, params.merge({:ratings => session[:ratings]}))
    end
    if !params[:sort_by] and session[:sort_by]
        flash.keep
        return redirect_to movies_path(@movies, params.merge({:sort_by => session[:sort_by]}))
    end
    session[:ratings] = @chosen_ratings = params[:ratings]
    session[:sort_by] = params[:sort_by] if Movie.column_names.include?(params[:sort_by])
    @movies = Movie.where(:rating => session[:ratings].keys).order(session[:sort_by])
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
