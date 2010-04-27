require 'helper'

class TestTraining < Test::Unit::TestCase
  
  should "handle basic training" do
    c = BayesMotel::Corpus.new('test')
    c.train({ :something => 'foo' }, :ham)
    c.train({ :something => 'foo' }, :spam)
    
    results = c.odds({ :something => 'foo' })
    assert results
    assert_equal 2, results.size
    assert_equal results[:spam], results[:ham]
  end

  should "not care about extra variables" do
    c = BayesMotel::Corpus.new('test')
    c.train({ :something => 'foo' }, :ham)
    c.train({ :something => 'foo', :fubwhiz => 'oh noes' }, :spam)
    
    results = c.odds({ :something => 'foo' })
    assert results
    assert_equal 2, results.size
    assert_equal results[:spam], results[:ham]
  end

  should "give more weight with more appearances" do
    c = BayesMotel::Corpus.new('test')
    c.train({ :something => 'foo' }, :ham)
    c.train({ :something => 'foo' }, :spam)
    c.train({ :something => 'foo', :fubwhiz => 'oh noes' }, :spam)
    
    results = c.odds({ :something => 'foo' })
    assert results
    assert_equal 2, results.size
    assert_equal results[:spam], 2*results[:ham]
  end
  
  should "calculate odds for nested documents" do
    c = BayesMotel::Corpus.new('test')
    c.train({ :something => 'foo', :kids => { :bar => 'whiz', :id => 123 } }, :ham)
    c.train({ :something => 'foo', :kids => { :bar => 'gee', :id => 145 } }, :spam)

    results = c.odds({ :something => 'foo', :kids => { :bar => 'gee', :id => 167, :ack => 'blag' }})
    assert results
    assert_equal 2, results.size
    assert_equal results[:spam], 2*results[:ham]
  end
end