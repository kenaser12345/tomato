class ApplicationController < ActionController::Base
  before_action :nav_find_projects, :today_expect_time_of_tasks, :undo_tasks
  
  def nav_find_projects
    @projects = current_user.projects.includes(:user).order(updated_at: :desc) if user_signed_in?
  end

  def today_expect_time_of_tasks
    if user_signed_in?
      @expect_time = expect_time
    else
      @expect_time = 0
    end
  end

  def undo_tasks
    if user_signed_in?
      range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
      @undo_tasks = current_user.tasks.where(created_at: range).doing.count
    end
  end

  
  private
  def expect_time
    range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    tictac_hours = current_user.tasks.where(created_at: range).sum(:expect_tictacs) * 1500.0 / 3600 
    tictac_hours.round(tictac_hours % 10 == 0 ? 0 : 1)
  end

  def undoing_tasks
    range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    current_user.tasks.where(created_at: range).doing.count
  end

end