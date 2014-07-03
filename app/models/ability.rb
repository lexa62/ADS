class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest
    @user.role ||= "guest"
    send(@user.role)
  end

  def guest
    can :read, Ad
  end

  def user
    alias_action :users_ads, :moderating, :make_draft, :edit_rejected_ad, :to => :manipulate

    guest
    can :create, Ad
    can :manipulate, Ad do |ad|
      ad.user_id == @user.id
    end

    can :update, Ad do |ad|
      ad.draft? && ad.user_id == @user.id
    end

    can :destroy, Ad do |ad|
      ad.user_id == @user.id
    end
  end

  def admin
    guest
    can :manage, :AdminSection
    can :manage, AdType
    can :manage, User
    can :destroy, Ad do |ad|
      !ad.draft?
    end
  end
end
