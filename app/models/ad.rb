class Ad < ActiveRecord::Base
	#enumerize :status, :in => [:draft, :new, :rejected, :approved, :published, :archive], scope: true
	belongs_to :ad_type, inverse_of: :ads
	belongs_to :user

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
