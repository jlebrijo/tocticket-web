class HomeController < ApplicationController
  def index
  end
  def how_it_works
    # binding.pry
    render "how_it_works_#{I18n.locale}"
  end
end
