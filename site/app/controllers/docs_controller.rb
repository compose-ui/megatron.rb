class DocsController < ApplicationController
  def show
    render action: "#{params[:page]}"
  end
end
