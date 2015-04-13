class WikiPolicy < ApplicationPolicy
  def show
    record.public? || user.present?
  end
end