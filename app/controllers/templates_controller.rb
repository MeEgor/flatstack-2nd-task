class TemplatesController < ApplicationController
  layout :false

  def index
    render template: File.join('templates', params[:path])
  end
end
