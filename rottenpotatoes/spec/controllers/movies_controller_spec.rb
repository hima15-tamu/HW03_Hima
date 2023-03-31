# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  before(:all) do
    if Movie.where(title: 'Big Hero 6').empty?
      Movie.create(title: 'Big Hero 6',
                   rating: 'PG', release_date:  '2014-11-07')
    end
    if Movie.where(title: 'Sully').empty?
      Movie.create(title: 'Sully',
                   rating: 'PG-13',
                   release_date: '2016-11-02')
    end
    if Movie.where(title: 'Inception').empty?
      Movie.create(title: 'Inception',
                   director: 'Christopher Nolan',
                   rating: 'PG-13',
                   release_date: '2016-11-02')
    end
    if Movie.where(title: 'Interstellar').empty?
      Movie.create(title: 'Interstellar',
                   director: 'Christopher Nolan',
                   rating: 'PG-13',
                   release_date: '2016-11-02')
    end

    # TODO(student): add more movies to use for testing
  end

  describe 'when trying to find movies by the same director' do
    it 'returns a valid collection when a valid director is present' do
      # TODO(student): implement this test
      movie = Movie.find_by(title: 'Inception')
      get :show_by_director, params: { id: movie.id }
      expect(assigns(:movies)).to be_a_kind_of(Enumerable)
      # expect(assigns(:movies)).to eq Movie.where(director: movie.director)
      expect(assigns(:movies)).to include(Movie.find_by(title: 'Interstellar'))
      expect(assigns(:movies)).not_to include(Movie.find_by(title: 'Sully'))
    end

    it 'redirects to index with a warning when no director is present' do
      movie = Movie.find_by(title: 'Big Hero 6')
      get :show_by_director, params: { id: movie.id }
      expect(response).to redirect_to(movies_path)
      expect(flash[:warning]).to match(/'#{movie.title}' has no director info/)
      # expect(flash[:warning]).to match("No director info for: #{movie.title} !!!")
    end
  end

  describe 'creates' do
    it 'movies with valid parameters' do
      get :create, params: { movie: { title: 'Toucan Play This Game', director: 'Armando Fox',
                                      rating: 'G', release_date: '2017-07-20' } }
      expect(response).to redirect_to movies_path
      expect(flash[:notice]).to match(/Toucan Play This Game was successfully created./)
      Movie.find_by(title: 'Toucan Play This Game').destroy
    end
  end

  describe 'updates' do
    it 'redirects to the movie details page and flashes a notice' do
      movie = Movie.create(title: 'Outfoxed!', director: 'Nick Mecklenburg',
                           rating: 'PG-13', release_date: '2023-12-17')
      get :update, params: { id: movie.id, movie: { description: 'Critics rave about this epic new thriller. Watch as main characters Armando Fox ' \
                                                                 'and Michael Ball, alongside their team of TAs, battle against the challenges of ' \
                                                                 'a COVID-19-induced virtual semester, a labyrinthian and disconnected assignment ' \
                                                                 'stack, and the ultimate betrayal from their once-trusted ally: Codio exams.' } }

      expect(response).to redirect_to movie_path(movie)
      expect(flash[:notice]).to match(/Outfoxed! was successfully updated./)
      movie.destroy
    end

    it 'actually does the update' do
      movie = Movie.create(title: 'Outfoxed!', director: 'Nick Mecklenburg',
                           rating: 'PG-13', release_date: '2023-12-17')
      get :update, params: { id: movie.id, movie: { director: 'Not Nick!' } }

      expect(assigns(:movie).director).to eq('Not Nick!')
      movie.destroy
    end
  end
end
