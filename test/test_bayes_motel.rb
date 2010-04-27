require 'helper'

class TestBayesMotel < Test::Unit::TestCase
  
  should "allow basic training" do
    c = BayesMotel::Corpus.new('email')
    tweets.each do |tweet|
      c.train(tweet, :ham)
    end
    c.cleanup
    assert_equal tweets.size, c.total_count
  end
  
  should "allow big training" do
    c = BayesMotel::Corpus.new('email')
    tweets(2000).each do |tweet|
      c.train(tweet, :ham)
    end
    c.cleanup
    assert_equal tweets.size, c.total_count
  end
  
  private
  
  def tweets(n=100)
    @tweets ||= begin
      t = []
      Zlib::GzipReader.open("#{File.dirname(__FILE__)}/#{n}tweets.txt.gz") do |gz|
        gz.read.each_line do |line|
          hash = eval(line)
          hash.delete(:retweeted_status) if hash[:retweeted_status]
          t << hash
        end
      end
      t
    end
  end
end
