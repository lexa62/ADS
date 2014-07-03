class Ad < ActiveRecord::Base
  validates :title, :text, :ad_type_id, :user_id, presence: true
  validates :price, numericality: { only_integer: true, less_than: 1_000_000 }
  belongs_to :ad_type, inverse_of: :ads
  belongs_to :user
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true

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
