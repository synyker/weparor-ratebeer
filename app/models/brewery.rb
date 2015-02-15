class Brewery < ActiveRecord::Base
  include RatingAverage
	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                   only_integer: true }
  validate :year_cannot_be_in_future

  def year_cannot_be_in_future
    if year > Time.now.year
      errors.add(:year, "can't be greater than #{Time.now.year}")
    end
  end

	def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2015
    puts "changed year to #{year}"
  end

  def to_s
    "#{name}"
  end

end
