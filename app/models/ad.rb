class Ad < ActiveRecord::Base
  validates :title, :text, :ad_type_id, :user_id, presence: true
  validates :price, numericality: { only_integer: true, less_than: 1_000_000 }
  belongs_to :ad_type, inverse_of: :ads
  counter_culture :ad_type, :column_name => Proc.new {|model| model.published? ? 'published_ads_count' : nil },
      :column_names => {["ads.status = ?", 'published'] => 'published_ads_count'}
  belongs_to :user
  has_many :images, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true
  scope :published, -> { where status: 'published' }
  scope :type, -> (type_id) { published.where ad_type_id: type_id }


  state_machine :status, :initial => :draft do

    event :moderating do
      transition :draft => :new
    end

    event :reject_ad do
      transition :new => :rejected
    end

    event :approve_ad do
      transition :new => :approved
    end

    event :publish do
      transition :approved => :published
    end

    event :in_archive do
      transition :published => :archive
    end

    event :make_draft do
      transition :archive => :draft
    end

    event :edit_rejected_ad do
      transition :rejected => :draft
    end
  end
end
