class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # to make things as minimally brittle as we can
    # while providing the basic access control we require
    # (only company admin users can modify (nearly) all records owned
    # by the company, ordinary users can only modify records they own)
    # we've generally adopted a proxying pattern below for checking permissions
    # (where we climb up the relation tree from <record> to company and
    # check user permissions on the company)

    can [:admin, :modify], Company do |company|
      company.admin_users.include?(user)
    end

    can :read, Company do |company|
      if company.site_public == true
        true
      else
        user.id && company.team_members.map(&:user_id).include?(user.id)
      end
    end

    can :view_settings, Company do |company|
      user.id && company.team_members.map(&:user_id).include?(user.id)
    end    

    can :modify, Question do |question|
      question.user == user || can?(:modify, question.company)
    end

    can :admin, Question do |question|
      can?(:admin, question.company)
    end    

    can :read, Question do |question|
      if question.private?
        question.user == user || question.company.team_members.map(&:user_id).include?(user.id)
      else
        true
      end
    end

    can :modify, Answer do |answer|
      answer.user == user || can?(:modify, answer.question)
    end

    can :read, Answer do |answer|
      can?(:read, answer.question)
    end

    can :modify, Comment do |comment|
      comment.user == user || can?(:modify, comment.company)
    end

    can :read, Comment do |comment|
      can?(:read, comment.answer)
    end

    ## ":post" permissions - delegate to ":read" ability on associated Question

    can :post, Answer do |answer|
      can?(:read, answer.question)
    end

    can :post, Comment do |comment|
      can?(:post, comment.answer)
    end

    can :post, Vote do |vote|
      can?(:read, vote.votable)
    end

    ## end ":post" permissions

    can :modify, Tag do |tag|
      can?(:modify, tag.company)
    end

    can :modify, TeamMember do |team_member|
      team_member.user == user || can?(:modify, team_member.company)
    end

    can :modify, Vote do |vote|
      vote.user == user
    end

    # read permissions
    can :read, Question do |question|

    end

    can :modify, Link do |link|
      can?(:modify, link.company)
    end

    can :modify, User do |u|
      u == user
    end
  end
end
