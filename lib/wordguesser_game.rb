class WordGuesserGame
  @@MAX_TRIES = 7

  attr_reader :word, :guesses, :wrong_guesses

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    letter = letter.to_s.downcase
    raise ArgumentError unless valid? letter
    upd_guesses = if @word.include? letter then @guesses else @wrong_guesses end
    already_guessed = upd_guesses.include? letter
    upd_guesses << letter unless already_guessed
    !already_guessed
  end

  def word_with_guesses
    @word.chars.map{|let| if @guesses.include?(let) then let else '-' end}.join('')
  end

  def check_win_or_lose
    return :win if win?
    return :lose if lose?
    return :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end

  private
  def win?
    @word.chars.all? {|letter| @guesses.include? letter}
  end

  def lose?
    not win? and @wrong_guesses.length >= @@MAX_TRIES
  end

  def valid?(x) 
    x.to_s.length == 1 && x >= 'a' && x <= 'z'  
  end
end
