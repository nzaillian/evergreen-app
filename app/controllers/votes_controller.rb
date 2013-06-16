class VotesController < ApplicationController
  def index
    votable_ids = params[:votable_ids].present? ? params[:votable_ids] : []

    votable_ids = votable_ids.delete_if(&:blank?) # filter out any blank

    if current_user
      voted_on = Vote.where("votable_id IN (?) AND user_id = ?", votable_ids, current_user.id)
                      .map { |v| {votable_id: v.votable_id, votable_type: v.votable_type} }
    else
      voted_on = []
    end

    render json: {voted_on: voted_on}
  end
end