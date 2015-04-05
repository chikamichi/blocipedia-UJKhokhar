class Collaborator < ActiveRecord::Base
  has_many :wikis
  has_many :users, through: :wikis
end