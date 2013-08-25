class MonstersController < ApplicationController
  def index
    render :json => Monster.all
  end
end
