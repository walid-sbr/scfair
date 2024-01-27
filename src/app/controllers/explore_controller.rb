class ExploreController < ApplicationController

  def show
    @page_number = params[:page].to_i || 1
    @per_page = 5
    offset = (@page_number - 1) * @per_page
    @number_of_rows = Dataset.count
    @datasets = Dataset.limit(@per_page).offset(offset)
  end
end
