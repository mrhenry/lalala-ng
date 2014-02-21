class Lalala::AssetsController < ApplicationController

  def list
    list = Lalala::Assets::List.build(params)
    render json: list.to_json
  end

end
