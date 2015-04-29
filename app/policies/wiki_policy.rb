class WikiPolicy < ApplicationPolicy
  def show?
    record.public? || user.present?
  end

  def make_private?
    user_is?('premium', 'admin')
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      wikis = []
      if user.present? && user.role == 'admin'
        wikis = scope.all
      elsif user.present? && user.role == 'premium'
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if wiki.public? || wiki.user == user || wiki.user.include?(user)
            wikis << wiki
          end
        end
      else
        all_wikis = scope.all
        wikis = []
        all_wikis.each do |wiki|
          if wiki.public? || wiki.users.include?(user)
            wikis << wiki
          end
        end
      end
      wikis
    end
  end
end
