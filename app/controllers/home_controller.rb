class HomeController < ApplicationController

  def intro

  end

  def show
    @player = Player.first
  end
end
