class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest
    @user.role ||= "guest"
    send(@user.role)
  end

  def guest
      can :read, Ad #for guest without roles
  end

  def user
    guest
    can :create, Ad
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
    can :destroy, Ad
  end
end
