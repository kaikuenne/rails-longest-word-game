class GamesController < ApplicationController
  require 'open-uri'

  def new
    @letters = ('A'..'Z').to_a.shuffle[0,10]
    @user_word = params[:user_word]
  end

  def score

    @user_word = params[:user_word]
    @user_word_a = @user_word.upcase.split("")
    @letters = params[:letters].split(" ")
    @answer = Hash.new

    url = "https://wagon-dictionary.herokuapp.com/" + @user_word
    serialized = open(url).read
    json = JSON.parse(serialized)

    if @user_word_a.select { |letter| @letters.include?(letter) } == @user_word_a
      if json["found"] == true
        @answer[:comment] = "Yay!"
        @answer[:score] = (json["length"] * 10 / 3.14).round.to_s

        if session[:grand_score].nil?
          session[:grand_score] = 0 + @answer[:score].to_i
        else
          session[:grand_score] += @answer[:score].to_i
        end
        @answer[:grand] = session[:grand_score]

        return @answer
      else
        @answer[:comment] = "Not a valid english word, you suck."
        @answer[:score] = "0"
        @answer[:grand] = session[:grand_score]

        return @answer
      end
    else
      @answer[:comment] = "Nope, not even close!"
      @answer[:score] = "0"
      @answer[:grand] = session[:grand_score]

      return @answer
    end
  end
end
