class SubjectSuggestionsController < ApplicationController
  before_filter :current_user
  before_action :set_subject_suggestion, only: [:edit, :update, :destroy]

  def index
    @subject_suggestions = SubjectSuggestion.where(account_id: @current_user.account_id)
  end

  def new
    @subject_suggestion = SubjectSuggestion.new
  end

  def create
    @subject_suggestion = SubjectSuggestion.new(subject_suggestion_params)
    @subject_suggestion.account_id = @current_user.account_id
    respond_to do |format|
      if @subject_suggestion.save
        format.html { redirect_to subject_suggestions_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @subject_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @subject_suggestion.update(subject_suggestion_params)
        format.html { redirect_to subject_suggestions_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @subject_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @subject_suggestion.destroy
    respond_to do |format|
      format.html { redirect_to subject_suggestions_url, notice: 'Move Type alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subject_suggestion
    @subject_suggestion = SubjectSuggestion.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def subject_suggestion_params
    params.require(:subject_suggestion).permit(
        :description,
        :active,
        :account_id
    )
  end
end
