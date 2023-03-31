# frozen_string_literal: true

# Movie class is used in database tables
class Movie < ActiveRecord::Base
  def others_by_same_director
    if director.blank?
      ''
    else
      Movie.where(director:)
    end
  end
end
