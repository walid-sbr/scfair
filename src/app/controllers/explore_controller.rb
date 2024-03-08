class ExploreController < ApplicationController
  helper_method [:ontology_link_generator, :generate_url]
    @@current_params = {
      source: "all",
    }
    @@current_array_params = {
      organisms: "all",
      disease: "all",
      assay_info: "all",
      cell_types: "all",
      sex: "all",
      tissue: "all",
      tissue_uberon: "all",
      developmental_stage: "all",
      developmental_stage_id: "all"
  }

  def show
    # update current parameters
    update_current_params
    update_params

    # pages handling
    @page_number = params[:page].to_i || 1
    @per_page = 50
    offset = (@page_number - 1) * @per_page

    # Hash of source sites links
    @sources_link = {
      "CELLxGENE": 'https://cellxgene.cziscience.com/',
      "BGEE": "https://www.bgee.org/"
    }

    # Let ease the way to display some fields with a loop
    @fields = {
      "Number of Cells": {
        name: :number_of_cells,
        distinct_values: Dataset.distinct.pluck(:number_of_cells).flatten.uniq
      },
      "Species": {
        name: :organisms,
        distinct_values: Dataset.distinct.pluck(:organisms).flatten.uniq
      },
      "Disease": {
        name: :disease,
        distinct_values: Dataset.distinct.pluck(:disease).flatten.uniq
      },
      "Assays": {
        name: :assay_info,
        distinct_values: Dataset.distinct.pluck(:assay_info).flatten.uniq
      },
      "Cell Type": {
        name: :cell_types,
        distinct_values: Dataset.distinct.pluck(:cell_types).flatten.uniq
      },
      "Sex": {
        name: :sex,
        distinct_values: Dataset.distinct.pluck(:sex).flatten.uniq
      },
      "Tissue": {
        name: :tissue,
        distinct_values: Dataset.distinct.pluck(:tissue).flatten.uniq
      },
      "Tissue ID": {
        name: :tissue_uberon,
        distinct_values: Dataset.distinct.pluck(:tissue_uberon).flatten.uniq
      },
      "Developmental Stage": {
        name: :developmental_stage,
        distinct_values: Dataset.distinct.pluck(:developmental_stage).flatten.uniq
      },
      "Developmental Stage ID": {
        name: :developmental_stage_id,
        distinct_values: Dataset.distinct.pluck(:developmental_stage_id).flatten.uniq
      }
    }


    # Used to display the different possibilities of filters in the UI
    @sources = Dataset.distinct.pluck(:source)

    if @@current_array_params.all? { |_, value| value == "all" }
      @selected = @@current_params[:source] == "all" ? Dataset.all : Dataset.where(source: @@current_params[:source])
    else
      values = @@current_array_params.select { |_, value| value != "all" }
      logger.info @@current_array_params
      query_string = ""
      values.each_with_index do |(key, value), index|
        if index == values.length
          break
        end
        parsed_value = value.gsub("'", "''")
        query_string += "'#{parsed_value}' = ANY(#{key}) #{index == (values.length - 1) ? "" : "AND "}"
      end
      @base = @@current_params[:source] == "all" ? Dataset.all : Dataset.where(source: @@current_params[:source])
      @selected = @base.where(query_string)
    end

    @datasets = @selected.limit(@per_page).offset(offset)
    @number_of_rows = @selected.count
  end

  def ontology_link_generator(type, id)
    id = id.sub ":", "_" # necessary beacause the url uses _ instead of : in the id
    url = "https://www.ebi.ac.uk/ols4/ontologies/#{type}/classes/http%253A%252F%252Fpurl.obolibrary.org%252Fobo%252F#{id}"
    return(url)
  end

  def generate_url(page)
    url = "#{explore_path(page, @@current_array_params)}"
    return url
  end

  def update_current_params
    @@current_array_params.each do |key, value|
      if (value == params[key])
        next
      elsif params[key].nil?
        @@current_array_params[key] = "all"
      else
        @@current_array_params[key] = params[key]
      end
    end
  end

  def update_params
    @@current_params.each do |key, value|
      if (value == params[key])
        next
      elsif params[key].nil?
        @@current_params[key] = "all"
      else
        @@current_params[key] = params[key]
      end
    end
  end
end
