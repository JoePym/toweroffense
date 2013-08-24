class PlayersController < ApplicationController

  def show
    render :json => Player.find(1)
  end

  private

  def default_serializer_options
    {
      root: false
    }
  end

end