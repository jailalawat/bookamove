class TaxesController < ApplicationController
  before_filter :current_user
  before_action :set_tax, only: [:edit, :update, :destroy]

  def index
    @taxes = Tax.all
  end

  def new
    @tax = Tax.new
  end

  def create
    @tax = Tax.new(parameter_tax)
    respond_to do |format|
      if @tax.save
        format.html { redirect_to taxes_url }
        format.json { render json: @tax } #render :index }
      else
        format.html { render :new }
        format.json { render json: @tax.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @tax.update(parameter_tax)
        format.html { redirect_to taxes_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @tax.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tax.destroy
    respond_to do |format|
      format.html { redirect_to taxes_url, notice: 'Tax was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tax
    @tax = Tax.find_by_id(params[:id])
  end

  # Never trust taxs from the scary internet, only allow the white list through.
  def parameter_tax
    params.require(:tax).permit(:province, :gst, :pst, :calendar_truck_group_id)
  end
end