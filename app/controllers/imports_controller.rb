class ImportsController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @imports = Import.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @imports }
    end
  end

  def edit
    @import = Import.find(params[:id])
  end

  def update
    @import = Import.find(params[:id])

    respond_to do |format|
      if @import.update_attributes(params[:import])
        format.html { redirect_to imports_path, notice: 'Import was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @import = Import.find(params[:id])
    @import.locations.each{ |l|
      l.locations_types.each{ |lt|
        LocationsType.delete(lt.id)
      }
      Location.delete(l.id)
    }
    @import.destroy
    respond_to do |format|
      format.html { redirect_to imports_url }
      format.json { head :no_content }
    end
  end
end
