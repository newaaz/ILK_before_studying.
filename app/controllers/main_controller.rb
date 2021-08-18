class MainController < ApplicationController

  def home
    @towns = Town.all
  end

  def contacts
  end

  def about
  end

  def admin
  end

  def privacy
  end
end
