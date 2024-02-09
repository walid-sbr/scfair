class ExploreController < ApplicationController
  helper_method :ontology_link_generator

  def show

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

    @page_number = params[:page].to_i || 1
    @per_page = 5
    offset = (@page_number - 1) * @per_page
    @number_of_rows = Dataset.count
    @datasets = Dataset.limit(@per_page).offset(offset)
  end

  def ontology_link_generator(type, id)
    id = id.sub ":", "_" # necessary beacause the url uses _ instead of : in the id
    url = "https://www.ebi.ac.uk/ols4/ontologies/#{type}/classes/http%253A%252F%252Fpurl.obolibrary.org%252Fobo%252F#{id}"
    return(url)
  end
end
