class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest
    @user.role ||= "guest"
    send(@user.role)
  end

  def guest
      can :read, :all #for guest without roles
  end

  def user
    guest
    can :manage, Ad
  end

  def admin
    guest
    can :manage, :all
    cannot :create, :update, Ad
  end
end
