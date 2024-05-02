class DatasetsController < ApplicationController
  before_action :set_dataset, only: %i[ show edit update destroy ]
  helper_method [:ontology_link_generator]

  def set_globals

    @sources_link = {
      "CELLxGENE" => 'https://cellxgene.cziscience.com/',
      "BGEE" => "https://www.bgee.org/",
      "ASAP" => "https://asap.epfl.ch/"
    }
    @fields = {
      "# Cells" => {
        name: :number_of_cells,
      },
      "Species" => {
        name: :organisms,
      },
      "Disease" => {
        name: :disease,
      },
      "Assays" => {
        name: :assay_info,
      },
      "Cell Type" => {
        name: :cell_types,
      },
      "Sex" => {
        name: :sex,
      },
      "Tissue" => {
        name: :tissue,
      },
      "Tissue ID" => {
        name: :tissue_uberon,
      },
      "Developmental Stage"=> {
        name: :developmental_stage,
      },
      "Developmental Stage ID" => {
        name: :developmental_stage_id,
      }
    }
    
  end
  
  # GET /datasets or /datasets.json
  def index
    set_globals()
    # Hash of source sites links
    
    #    @datasets = Dataset.all
  end


  def search

      @default_width = 80
      set_globals()

     q = params[:q].strip.gsub(/\$\{jndi\:/, '').gsub(/[\{\}\$\:\\]/, '')
     @datasets = []
     
     if q == ''
       @datasets = Dataset.all
     else
       query = Dataset.search do
         fulltext q
         paginate :page => 1, :per_page => Dataset.count
       end
       
       @total = query.total
       @datasets = query.results
     end
     
     render :partial => 'search_results'
    
  end
  
  # GET /datasets/1 or /datasets/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dataset
      @dataset = Dataset.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def dataset_params
      params.fetch(:dataset, {})
    end

    def ontology_link_generator(type, id)
      id = id.sub ":", "_" # necessary beacause the url uses _ instead of : in the id
      url = "https://www.ebi.ac.uk/ols4/ontologies/#{type}/classes/http%253A%252F%252Fpurl.obolibrary.org%252Fobo%252F#{id}"
      return(url)
    end
end
