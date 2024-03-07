module ExploreHelper

  def get_pagination(current_page, number_of_rows, per_page)
    if (current_page - per_page) <= 1
      return(1..10)
    elsif (current_page + per_page) > (number_of_rows / per_page)
      return((current_page - 10)..(current_page))
    else
      return((current_page - per_page)..(current_page + per_page))
    end
  end

end
