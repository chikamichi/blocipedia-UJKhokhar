class ApplicationPolicy
  attr_reader :user, :record

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    record_exists?
  end

  def create?
    user_exists?
  end

  def new?
    create?
  end

  def update?
    user_exists?
  end

  def edit?
    update?
  end

  def destroy?
    record_owned_by_user? || user_is?('admin')
  end

  def scope
    record.class
  end

  # --------------------------- Utility methods --------------------------------
  
  def record_exists?
    scope.where(:id => record.id).exists?
  end

  def record_owned_by_user?
    return false if record.user.nil?
    return false unless user_exists?
    record.user == user
  end

  def user_exists?
    user.present?
  end

  def user_is?(*roles)
    user_exists? && roles.any? { |role| user.send(:"#{role}?") }
  end

end

