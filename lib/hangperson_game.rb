class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_reader :guesses, :wrong_guesses, :word

  NUM_OF_GUESS = 7

  def initialize(word)
    raise ArgumentError.new('invalid word') unless word.is_a?(String)
    @word = word
    @wrong_guesses = ''
    @guesses = ''
  end

  def guess(letter)
    raise ArgumentError.new('invalid letter') unless (letter.is_a?(String) and letter.match?(/^[^\W\d]+/))
    val = letter.downcase
    return false if losed?
    if (@guesses+@wrong_guesses).downcase.include?(val)
      false
    elsif @word.include?(val)
      @guesses += val
      true
    else
      @wrong_guesses += val
      true
    end
  end



  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def word_with_guesses
    @word.gsub(/[^#{@guesses}\s]/i,'-')
  end

  def check_win_or_lose
    if @word.gsub(/[#{@guesses}\s]/i,'').length == 0
      :win
    elsif losed?
      :lose
    else
      :play
    end
  end

  private

  def losed?
    @wrong_guesses.length >= NUM_OF_GUESS
  end

end
