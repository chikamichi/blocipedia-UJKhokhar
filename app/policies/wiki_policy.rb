class WikiPolicy < ApplicationPolicy
  def show?
    record.public? || user.present?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    # Note: Although Rails 3 & 4 provide "merge" to mix several scopes:
    #
    #   # Just an example--imagine the "public" and "owned_by" scopes exist:
    #   Wiki.public.merge(Wiki.owned_by(User.last))
    #
    # it does an AND:
    #
    #   Wiki.public.merge(Wiki.owned_by(User.last)).to_sql
    #     User Load (0.3ms)  SELECT  "users".* FROM "users"  ORDER BY "users"."id" DESC LIMIT 1
    #     => SELECT "wikis".* FROM "wikis" WHERE "wikis"."public" = 't' AND "wikis"."user_id" = 7
    #
    # We would like to an OR instead. This is not possible… yet.
    #
    # Rails 5 will support mixing several scopes with OR:
    #
    #   @see https://github.com/rails/rails/pull/16052
    #   @see https://github.com/rails/rails/commit/9e42cf019f2417473e7dcbfcb885709fa2709f89
    #
    # In the meantime, we will need to use a trick, stepping one level down in
    # the abstraction stack: using Arel (https://github.com/rails/arel).
    def resolve
      # 0. Anonymous users don't see blah.
      return scope.none unless user.present?

      wiki = Wiki.arel_table

      # 1. User is an admin, sees all wikis.
      if user.admin?
        wikis = scope.all

      # 2. User has a premium account, sees public wikis, own wikis and
      # private wikis he's been invited to.
      elsif user.premium?
        #wikis = scope.publ.or(scope.owned_by(user)).or(scope.invited_as(user)) # NOT POSSIBLE YET (RAILS 5 ONLY)
        # FIXME: need to add the .or for private wikis user is a collaborator on.
        wikis = Wiki.where(wiki[:public].eq('t').or(wiki[:user_id].eq(user.id)))

      # 3. User has default access, sees publics wikis and own wikis.
      else
        #wikis = scope.publ.or(scope.owned_by(user)) # NOT POSSIBLE YET (RAILS 5 ONLY)
        wikis = Wiki.where(wiki[:public].eq('t').or(wiki[:user_id].eq(user.id)))
      end

      wikis
    end
  end
end
