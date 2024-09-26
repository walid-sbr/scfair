class DatasetsController < ApplicationController
  before_action :set_dataset, only: %i[ show edit update destroy ]
  helper_method [:ontology_link_generator]

  def set_globals

    @sources = {
      "CELLxGENE" => ['https://cellxgene.cziscience.com/', 30],
      "BGEE" => ["https://www.bgee.org/", 60],
      "ASAP" => ["https://asap.epfl.ch/", 30]
    }

    @explore_sources_url = {
      "CELLxGENE" => "https://cellxgene.cziscience.com/e/\#ID.cxg/"
    }
    @fields = {
      :number_of_cells => {:label => "# Cells"},
      :organisms => {:label => "Species"},
      :disease => {:label => "Disease"},
      :assay_info => {:label => "Assays"},
      :cell_types => {:label => "Cell Type"},
      :sex => {:label => "Sex"},
      :tissue => {:label => "Tissue"},
      :tissue_uberon => {:label => "Tissue ID"},
      :developmental_stage => {:label => "Developmental Stage"},
      :developmental_stage_id => {:label => "Developmental Stage ID"}
    }

    @fields_without_autocomplete_filter = [:number_of_cells, :tissue_uberon, :developmental_stage_id]

  end

  def index2
  end
  
  def set_search_session
    [:dataset_search_type].each do |e|
      session[:dataset_settings][e] ||= params[e] if params[e]
    end
  end

  def search2
    session[:dataset_settings][:search_view_type] ||= 'list'
    session[:dataset_settings][:free_text] = params[:free_text] if params[:free_text]
    if params[:nolayout] == "1"
      render :layout => nil
    else
      render :layout => 'welcome'
    end
  end

  def do_search
    set_globals()
    session[:dataset_settings][:search_view_type]= 'list'
    session[:dataset_settings][:search_view_type] = params[:search_view_type] if params[:search_view_type] and params[:search_view_type] != ''
    session[:dataset_settings][:free_text] ||= ''
    session[:dataset_settings][:free_text] = params[:free_text] if params[:free_text]
    session[:dataset_settings][:search_type] ||= 'public'

    session[:dataset_settings]["per_page".to_sym]||=50 #if !session[:settings][(prefix + "_per_page").to_sym] or session[:settings][(prefix + "_per_page").to_sym]== 0                               
    session[:dataset_settings]["page".to_sym]||=1
    ['per_page', 'page'].each do |e|
      session[:dataset_settings][e.to_sym] = params[e.to_sym].to_i if params[e.to_sym] and params[e.to_sym].to_i != 0
    end


    free_text = session[:dataset_settings][:free_text]

    free_text.strip!

    words = free_text.split(/\s*[; ]\s*/)

#    @workspace = Workspace.where(:key => params[:workspace_key]).first if params[:workspace_key]

    @datasets = []

    @h_counts = {
      :all => Dataset.count
    }

    @query = Dataset.search do
      fulltext words.join(" ").gsub(/\$\{jndi\:/, '').gsub(/[\{\}\$\:\\]/, '')    
      order_by(:id, :asc)
      paginate :page => session[:dataset_settings][:page], :per_page => session[:dataset_settings][:per_page]
    end

    @datasets= @query.results


    studies = Study.where(:doi => @datasets.map{|d| d.doi}.flatten).all
    @h_studies = {}
    studies.map{|s| @h_studies[s.doi] = s}
    @h_ext_sources = {}
    ExtSource.all.map{|es| @h_ext_sources[es.id] = es}

    
    now = Time.now

    render :partial => 'do_search' 
                           
  end
  
  # GET /datasets or /datasets.json
  def index
    set_globals()
    # Hash of source sites links

    #    @datasets = Dataset.all
  end

  def search

    @default_width = 250
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

    studies = Study.where(:doi => @datasets.map{|d| d.doi}.flatten).all
    @h_studies = {}
    studies.map{|s| @h_studies[s.doi] = s}
    @h_ext_sources = {}
    ExtSource.all.map{|es| @h_ext_sources[es.id] = es}
    
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
