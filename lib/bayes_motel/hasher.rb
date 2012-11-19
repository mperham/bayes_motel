require 'fast_stemmer'

module BayesMotel

  class TextHash < Hash
    attr_reader :word_count

    def initialize(text=nil, stem=true)
      super 0
      @word_count = 0
      @stem = stem
      add_text(text) unless text.nil?
    end

    def self.atomize(text)
      text.to_s.downcase.to_ascii.tr('-', ' ').gsub(/[^\w\s]/," ").split
    end

    # word should be only alphanum chars at this point
    def self.valid_word?(word)
      not (STOPWORDS.include?(word) || word.length < 3 || word.numeric?)
    end

    def add_text(text)
      if text.instance_of? Array
        text.each { |t| add_text t }
      else
        # replace dashes with spaces, then get rid of non-word/non-space characters,
        # then split by space to get words
        words = TextHash.atomize text
        words.each { |word| add_word(word) if TextHash.valid_word?(word) }
      end
      self
    end

    protected

    def add_word(word)
      @word_count += 1
      word = word.stem if @stem
      key = word.intern
      store key, fetch(key, 0)+1
    end
  end

end


require 'iconv'

class String
  def numeric?
    true if Float(self) rescue false
  end

  def to_ascii
    # from http://www.jroller.com/obie/tags/unicode
    converter = Iconv.new('ASCII//IGNORE//TRANSLIT', 'UTF-8')
    converter.iconv(self).unpack('U*').select { |cp| cp < 127 }.pack('U*') rescue ""
  end
end
