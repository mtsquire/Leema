class Product < ActiveRecord::Base

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :ratings

  validates :title, presence: true,
                    length: { minimum: 0, maxmimum: 140 }
  validates :price, presence: true
  validates :description, presence: true,
                  length: { minimum: 5 }
  has_attached_file :photo, :styles => { :small => "120x120>"}
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates :photo, :attachment_presence => true

  def avg_rating
    average_rating = 0.0
    count = 0
    ratings.each do |rating| 
      average_rating += rating.score
      count += 1
    end
                
    if count != 0
      (average_rating / count)
    else
      count
    end
  end
  
end
