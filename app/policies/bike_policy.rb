class BikePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
  
  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    record.owner == user
  end

  def destroy?
    record.owner == user
  end

end
