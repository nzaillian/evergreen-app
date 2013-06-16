class Admin::TeamMembersController < Admin::AdminController
  prepend_before_filter :find_company, only: collection_actions(:batch_update)
  before_filter :find_team_member, only: member_actions
  layout "settings"
  set_tab :team_members

  def index
    load_team_members
    @team_member = @company.team_members.new
  end  

  def create
    @team_member = @company.team_members.new(team_member_params)

    authorize! :modify, @team_member

    if @team_member.save
      TeamMemberMailer.invitation(@team_member.id).deliver
      flash[:notice] = "Team invitation sent to \"#{@team_member.email}\""
      redirect_to action: "index", company_id: @company.id
    else
      load_team_members
      render action: "index"
    end
  end

  def edit
  end

  def update
    @team_member.attributes = team_member_params

    authorize! :modify, @team_member

    if @team_member.save
      flash[:notice] = "Settings updated successfully"

      if params[:from].present?
        redirect_to(url_for(params[:from]) + (params[:section] || ""))
      else
        redirect_to(url_for(action: "index", company_id: @company.id) + (params[:section] || ""))
      end

    else

      if params[:from].present?
        render("/#{params[:from][:controller]}/#{params[:from][:action]}")
      else
        render "edit", layout: "settings"
      end

    end
  end  

  def batch_update
    @team_members = params[:team_members]

    if @team_members
      @team_members.each_pair do |key, val|
        team_member = TeamMember.find(key)
        authorize! :modify, team_member
        team_member.attributes = batch_params(val)
        team_member.save!
      end
    end

    flash[:notice] = "Settings updated successfully"
    redirect_to(url_for(action: "index", company_id: @company.id) + (params[:section] || ""))
  end

  def destroy
    authorize! :modify, @team_member

    if @team_member.destroy
      flash[:warning] = "Team member successfully removed from company"
    else
      flash[:warning] = @team_member.errors.full_messages.first
    end

    redirect_to action: "index", company_id: @company.id
  end

  private

  def team_member_params
    params.require(:team_member).permit(:email, :title, :notify_of_new_questions, 
      :notify_of_new_answers_or_comments, :featured, :sort_order, :role)
  end

  def batch_params(params_hash)
    filter_hash(params_hash, :featured, :sort_order)
  end

  def load_team_members
    @team_members = @company.team_members.order("created_at DESC")
  end

  def find_team_member
    @team_member = TeamMember.find(params[:id])
    @company = @team_member.company
    @user = @team_member.user
    authorize! :modify, @team_member
  end
end