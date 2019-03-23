require 'helper'

class TestTraining < MiniTest::Test

  should "handle basic training" do
    c = BayesMotel::Corpus.new('test')
    c.train({ :something => 'foo' }, :ham)
    c.train({ :something => 'foo' }, :spam)

    results = c.score({ :something => 'foo' })
    assert results
    assert_equal 2, results.size
    assert_equal results[:spam], results[:ham]
  end

  should "not care about extra variables" do
    c = BayesMotel::Corpus.new('test')
    c.train({ :something => 'foo' }, :ham)
    c.train({ :something => 'foo', :fubwhiz => 'oh noes' }, :spam)

    results = c.score({ :something => 'foo' })
    assert results
    assert_equal 2, results.size
    assert_equal results[:spam], results[:ham]
  end

  should "give more weight with more appearances" do
    c = BayesMotel::Corpus.new('test')
    c.train({ :something => 'foo' }, :ham)
    c.train({ :something => 'foo' }, :spam)
    c.train({ :something => 'foo', :fubwhiz => 'oh noes' }, :spam)

    doc = { :something => 'foo' }
    results = c.score(doc)
    assert results
    assert_equal 2, results.size
    assert_equal results[:spam], 2*results[:ham]
    assert_equal [:spam, 2.0/3], c.classify(doc)
  end

  should "calculate score for nested documents" do
    c = BayesMotel::Corpus.new('test')
    c.train({ :something => 'foo', :kids => { :bar => 'whiz', :id => 123 } }, :ham)
    c.train({ :something => 'foo', :kids => { :bar => 'gee', :id => 145 } }, :spam)

    doc = { :something => 'foo', :kids => { :bar => 'gee', :id => 167, :ack => 'blag' }}
    results = c.score(doc)
    assert results
    assert_equal 2, results.size
    assert_equal results[:spam], 2*results[:ham]

    assert_equal [:spam, 1.0], c.classify(doc)
  end
end
