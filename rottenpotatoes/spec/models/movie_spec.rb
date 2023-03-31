# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie, type: :model do
  before(:all) do
    if described_class.where(title: 'Big Hero 6').empty?
      described_class.create(title: 'Big Hero 6',
                             rating: 'PG', release_date: '2014-11-07')
    end
    if described_class.where(title: 'Sully').empty?
      described_class.create(title: 'Sully',
                             rating: 'PG-13', release_date: '2016-11-02')
    end
    if described_class.where(title: 'Interstellar').empty?
      described_class.create(title: 'Interstellar',
                             director: 'Christopher Nolan',
                             rating: 'PG-13', release_date: '2014-10-26')
    end

    if described_class.where(title: 'Inception').empty?
      described_class.create(title: 'Inception',
                             director: 'Christopher Nolan',
                             rating: 'PG-13', release_date: '2013-07-13')
    end

    # TODO(student): add more movies to use for testing
  end

  describe 'others_by_same_director method' do
    it 'returns all other movies by the same director' do
      # TODO(student): implement this test
      movie = described_class.find_by(title: 'Inception')
      movies_by_the_same_director = movie.others_by_same_director
      expect(movies_by_the_same_director).to be_a_kind_of(Enumerable)
      expect(movies_by_the_same_director).to include(described_class.find_by(title: 'Inception'))
      expect(movies_by_the_same_director).to include(described_class.find_by(title: 'Interstellar'))
    end

    it 'does not return movies by other directors' do
      # TODO(student): implement this test
      movie = described_class.find_by(title: 'Interstellar')
      movies_by_the_same_director = movie.others_by_same_director

      expect(movies_by_the_same_director).not_to include(described_class.find_by(title: 'The Imitation Game'))
      expect(movies_by_the_same_director).not_to include(described_class.find_by(title: 'Sully'))
    end
  end
end
