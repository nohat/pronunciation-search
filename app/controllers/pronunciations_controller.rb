class PronunciationsController < ApplicationController
  def index
    if params[:q]
      begin
        @query_string = params[:q]
        matches = Pronunciation.search(@query_string, @left_anchored, @right_anchored)
        @pronunciations = Kaminari.paginate_array(matches).page params[:page]
      rescue Pronunciation::Search::QueryException => e
        @error = e.message
        @pronunciations = []
      end
    else
      @pronunciations = Pronunciation.includes(:word).page params[:page]
    end

    respond_to do |format|
      format.html do
        if request.xml_http_request?
          render :partial => 'table'
        else
          render :html => @pronunciations
        end
      end
      format.js { render :json => @pronunciations }
    end
  end
end
