class WordsController < ApplicationController
  def index
    if params[:q]
      matches = Word.matches(params[:q])
      @words = Kaminari.paginate_array(matches).page params[:page]
    elsif name = params[:word] && params[:word][:name]
      return redirect_to word_path Word.find(name).friendly_id
    else
      @words = Word.includes(:pronunciations).page params[:page]
    end

    respond_to do |format|
      format.html
#      format.js   { render :json => @words }
      format.js { render :json => @words.map{ |word| word.as_json({:only => [:name], :methods => :friendly_id}) } }
    end
  end

  def show
    @word = Word.find(params[:id], :include => :pronunciations)

    respond_to do |format|
      format.html # show.html.erb
      format.js  { render :json => @word }
      format.xml { render :xml => @word }
    end
  end
end
