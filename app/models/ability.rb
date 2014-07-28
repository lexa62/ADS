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
    alias_action :ads, :moderating, :make_draft, :edit_rejected_ad, :to => :manipulate

    guest
    can :create, Ad
    can [:manipulate, :destroy], Ad, user_id: @user.id
    can :update, Ad, user_id: @user.id, status: 'draft'
  end

  def admin
    alias_action :approve_ad, :reject_ad, :approve_ads, :to => :moderate

    guest
    can :manage, [AdType, User]
    can [:moderate, :destroy], Ad
  end
end
