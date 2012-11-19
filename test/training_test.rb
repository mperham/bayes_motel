require 'helper'

class TrainingTest < Test::Unit::TestCase

  should "handle basic training" do
    mm = BayesMotel::Persistence::MemoryInterface.new("test")
    c = BayesMotel::Corpus.new(mm)
    c.train({ :something => 'foo' }, :ham)
    c.train({ :something => 'foo' }, :spam)

    results = c.score({ :something => 'foo' })
    assert results
    assert_equal 2, results.size
    assert_not_equal results[:spam], nil
    assert_equal results[:spam], results[:ham]
  end

  should "handle complex training" do
    mm = BayesMotel::Persistence::MemoryInterface.new("test")
    c = BayesMotel::Corpus.new(mm)
    c.train({ :body => 'foo biz', :title => "zag zoop" }, :ham)
    c.train({ :body => 'biz blang bloop beep', :title => "bloom blip" }, :spam)

    doc = { :body => 'foo biz'}
    results = c.score(doc)
    #ham

    assert results[:ham] > results[:spam]
    assert_equal :ham, c.classify(doc).first

    doc = { :title => 'bloom'}
    results = c.score(doc)
    assert results[:spam] > results[:ham]
    assert_equal :spam, c.classify(doc).first

  end


  should "not care about extra variables" do
    mm = BayesMotel::Persistence::MemoryInterface.new("test")
    c = BayesMotel::Corpus.new(mm)
    c.train({ :something => 'foo' }, :ham)
    c.train({ :something => 'foo', :fubwhiz => 'oh noes' }, :spam)

    results = c.score({ :something => 'foo' })
    assert results
    assert_equal 2, results.size
    assert_equal results[:spam], results[:ham]
  end

  should "give more weight with more appearances" do
    mm = BayesMotel::Persistence::MemoryInterface.new("test")
    c = BayesMotel::Corpus.new(mm)
    c.train({ :something => 'foo' }, :ham)
    c.train({ :something => 'foo' }, :spam)
    c.train({ :something => 'foo', :fubwhiz => 'oh noes' }, :spam)

    doc = { :something => 'foo' }
    #should be spam

    results = c.score(doc)
    assert results
    assert_equal 2, results.size

    assert results[:spam] > results[:ham]

    assert_equal :spam, c.classify(doc).first
  end

  should "calculate score for nested documents" do
    mm = BayesMotel::Persistence::MemoryInterface.new("test")
    c = BayesMotel::Corpus.new(mm)
    c.train({ :something => 'foo', :kids => { :bar => 'whiz', :id => 123 } }, :ham)
    c.train({ :something => 'foo', :kids => { :bar => 'gee', :id => 145 } }, :spam)

    doc = { :something => 'foo', :kids => { :bar => 'gee', :id => 167, :ack => 'blag' }}
    #should be spam

    results = c.score(doc)

    assert results
    assert_equal 2, results.size
    assert results[:spam] > results[:ham]

    assert_equal :spam, c.classify(doc).first
  end
end
