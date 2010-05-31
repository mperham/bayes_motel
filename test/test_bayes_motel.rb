require 'helper'

class TestBayesMotel < Test::Unit::TestCase
  
  should "allow basic training" do
    mm = BayesMotel::Persistence::MemoryInterface.new("email")
    c = BayesMotel::Corpus.new(mm)
    tweets.each do |tweet|
      c.train(tweet, :ham)
    end
    
    assert_equal tweets.size, c.total_count
    c.cleanup
  end
  
  should "allow big training" do
    mm = BayesMotel::Persistence::MemoryInterface.new("email")
    c = BayesMotel::Corpus.new(mm)
    tweets(2000).each do |tweet|
      c.train(tweet, :ham)
    end
    
    assert_equal tweets.size, c.total_count
    c.cleanup
  end
  
  should "allow basic training using mongoid" do
    mm = BayesMotel::Persistence::MongoidInterface.new("email")
    c = BayesMotel::Corpus.new(mm)
    tweets.each do |tweet|
      c.train(tweet, :ham)
    end
    
    assert_equal tweets.size, c.total_count
    c.cleanup
  end
  
  should "allow big training using mongoid" do
    mm = BayesMotel::Persistence::MongoidInterface.new("email2")
    c = BayesMotel::Corpus.new(mm)
    tweets(2000).each do |tweet|
      c.train(tweet, :ham)
    end
    
    assert_equal tweets.size, c.total_count
    c.cleanup
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
          break if n > 10
        end
      end
      t
    end
  end
end
