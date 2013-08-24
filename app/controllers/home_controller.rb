class HomeController < ApplicationController
  def show
    @player = Player.first
  end
end
