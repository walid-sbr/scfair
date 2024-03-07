module ExploreHelper

  def get_pagination(current_page, number_of_rows, per_page)
    if (number_of_rows <= (per_page * 10))
      return(1..((number_of_rows / per_page) + 1))
    elsif (current_page - 5) <= 1
      return(1..10)
    elsif (current_page + 5) > (number_of_rows / per_page)
      return(current_page - 10)..(current_page)
    else
      return((current_page - 5)..(current_page + 5))
    end
  end

end
