class Obstacle < ApplicationRecord
  belongs_to :cell

  def is_hinder?
    false  #can't test now, so to write it later. it is the function to check if the obstacle hinder the path
  end
end
