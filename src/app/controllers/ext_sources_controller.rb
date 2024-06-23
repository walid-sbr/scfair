class ExtSourcesController < ApplicationController
  before_action :set_ext_source, only: %i[ show edit update destroy ]

  # GET /ext_sources or /ext_sources.json
  def index
    @ext_sources = ExtSource.all
  end

  # GET /ext_sources/1 or /ext_sources/1.json
  def show
  end

  # GET /ext_sources/new
  def new
    @ext_source = ExtSource.new
  end

  # GET /ext_sources/1/edit
  def edit
  end

  # POST /ext_sources or /ext_sources.json
  def create
    @ext_source = ExtSource.new(ext_source_params)

    respond_to do |format|
      if @ext_source.save
        format.html { redirect_to ext_source_url(@ext_source), notice: "Ext source was successfully created." }
        format.json { render :show, status: :created, location: @ext_source }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ext_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ext_sources/1 or /ext_sources/1.json
  def update
    respond_to do |format|
      if @ext_source.update(ext_source_params)
        format.html { redirect_to ext_source_url(@ext_source), notice: "Ext source was successfully updated." }
        format.json { render :show, status: :ok, location: @ext_source }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ext_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ext_sources/1 or /ext_sources/1.json
  def destroy
    @ext_source.destroy

    respond_to do |format|
      format.html { redirect_to ext_sources_url, notice: "Ext source was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ext_source
      @ext_source = ExtSource.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ext_source_params
      params.fetch(:ext_source).permit(:name, :description, :url_mask, :id_regexp)
    end
end
