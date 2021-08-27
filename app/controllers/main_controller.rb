class MainController < ApplicationController

  def home
    @towns = Town.includes(:category_counters).all
  end

  def contacts
  end

  def about
  end

  def admin
    unless current_user || current_user.admin?
      redirect_back(fallback_location: root_url)
    end
  end

  def privacy
  end
end
