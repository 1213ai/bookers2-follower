class RanksController < ApplicationController
  
  def rank
  @month_user_post_ranks = User.where(id: Post.group(:user_id).where(created_at: Time.current.all_month).order('count(user_id) desc').pluck(:user_id))
  end
  
end
