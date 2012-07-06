class PronunciationsController < ApplicationController
  def index
    if params[:q]
      @query_string = params[:q]
      matches = Pronunciation.search(@query_string, @left_anchored, @right_anchored)
      @pronunciations = Kaminari.paginate_array(matches).page params[:page]
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
