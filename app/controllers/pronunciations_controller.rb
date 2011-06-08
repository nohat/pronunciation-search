class PronunciationsController < ApplicationController
  
  def create
    @word = Word.find(params[:word_id])
    @pronunciation = @word.pronunciations.create(params[:pronunciation])
    redirect_to word_path(@word)
  end
  
  def destroy
    @word = Word.find(params[:word_id])
    @pronunciation = @word.pronunciations.find(params[:id])
    @pronunciation.destroy
    redirect_to word_path(@word)
  end
end
