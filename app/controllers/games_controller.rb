require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters]
    @answer = params[:answer]
    @break_answer = @answer.upcase.split('').sort
    if included?(@break_answer, @letters)
      if english_word?(@answer)
        @final_input = 'Well done player, this is a valid word !'
      else
        @final_input = 'Well, this is not an english word. Try again !'
      end
      else
        @final_input = 'The letters you used are not in the grid. Try again !'
      end
  end

  private

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def included?(sequence, input)
    sequence.all? { |letter| sequence.count(letter) <= input.count(letter) }
  end
end
