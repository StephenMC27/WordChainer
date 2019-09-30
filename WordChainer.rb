require "Set"

class WordChainer

  attr_reader :dictionary

  def initialize(dictionary_file)
    words = File.readlines("dictionary.txt").map(&:chomp)
    @dictionary = Set.new(words)
  end

  def adjacent_words(word)
    adjacent = []
    @dictionary.each do |possible|
      letter_count = 0
      if possible.length == word.length
        possible.each_char.with_index { |letter, i| letter_count += 1 if letter != word[i] }
      end
      adjacent << possible if letter_count == 1
    end
    adjacent
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = { source: nil }
    while !@current_words.empty? && !@all_seen_words.include?(target)
      new_current_words = []
      @current_words.each do |word|
        new_current_words += explore_current_words(word)
      end
      @current_words = new_current_words
    end
    puts build_path(target)
  end

  def explore_current_words(current_word)
    explored = []
    adjacent_words(current_word).each do |adjacent|
      if !@all_seen_words.has_value?(adjacent)
        @all_seen_words[adjacent] = current_word
        explored << adjacent
      end
    end
    explored
  end

  def build_path(target)
    path = []
    current_word = target
    until current_word.nil?
      path << current_word
      current_word = @all_seen_words[current_word]
    end

    path.reverse
  end

end

words = WordChainer.new("dictionary.txt")
# #
# # p words.dictionary
words.run("ruby", "duck")
#words.explore_current_words("market")
