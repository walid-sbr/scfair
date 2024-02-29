class ExploreController < ApplicationController
  helper_method [:ontology_link_generator, :generate_url]
  @@current_params = {
    source: nil
  }

  def show
    # update current parameters
    update_current_params

    # pages handling
    @page_number = params[:page].to_i || 1
    @per_page = 5
    offset = (@page_number - 1) * @per_page

    # Let ease the way to display some fields with a loop
    @fields = {
      "Number of Cells": :number_of_cells,
      "Organisms": :organisms,
      "Disease": :disease,
      "Assay Info": :assay_info,
      "Cell Types": :cell_types,
      "Sex": :sex,
      "Tissue": :tissue,
      "Tissue UBERON": :tissue_uberon,
      "Developmental Stage": :developmental_stage,
      "Developmental Stage ID": :developmental_stage_id,
  }

    # Used to display the different possibilities of filters in the UI
    @sources = Dataset.distinct.pluck(:source)


    @source = @@current_params[:source]
    @selected_source = @source == "all" ? Dataset.all : Dataset.where(source: @source)
    @datasets = @selected_source.limit(@per_page).offset(offset)
    @number_of_rows = @selected_source.count
  end

  def ontology_link_generator(type, id)
    id = id.sub ":", "_" # necessary beacause the url uses _ instead of : in the id
    url = "https://www.ebi.ac.uk/ols4/ontologies/#{type}/classes/http%253A%252F%252Fpurl.obolibrary.org%252Fobo%252F#{id}"
    return(url)
  end

  def generate_url(page)
    url = "#{explore_path(page)}?"
    @@current_params.each do |key, value|
        url += "#{key}=#{value}"
    end
    return url
  end

  def update_current_params
    @@current_params.each do |key, value|
      if value == params[key]
        next
      else
        @@current_params[key] = params[key]
      end
    end
  end
end
