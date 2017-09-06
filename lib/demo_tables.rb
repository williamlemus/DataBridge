require_relative 'sql_object'


class Team < SQLObject
  belongs_to :city
  has_many :players
  self.finalize!
end

class City < SQLObject
  has_many :teams
  self.finalize!
end

class Player < SQLObject
  belongs_to :team
  has_one_through :city, :team, :city
  self.finalize!
end
