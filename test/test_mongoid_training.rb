require 'helper'

class TestMongoidTraining < Test::Unit::TestCase

  def setup
    Mongoid.default_session.collections.select {|c| c.name !~ /system/ }.each(&:drop)
    #clear out mongo
  end

  should "handle basic training" do
    mm = BayesMotel::Persistence::MongoidInterface.new("test-basic")
    c = BayesMotel::Corpus.new(mm)

    c.train({ :something => 'foo' }, :ham)
    c.train({ :something => 'foo' }, :spam)

    results = c.score({ :something => 'foo' })
    assert results

    assert_equal 2, results.size
    assert_equal results[:spam], results[:ham]
  end

  should "not care about extra variables" do
    m = [ BayesMotel::Persistence::MongoidInterface.new("test-extra"),
          BayesMotel::Persistence::MemoryInterface.new("test-extra")
        ]
    results = {}

    m.each do |i|
      c = BayesMotel::Corpus.new(i)
      c.train({ :something => 'foo' }, :ham)
      c.train({ :something => 'foo', :fubwhiz => 'oh noes' }, :spam)

      res = c.score({ :something => 'foo' })
      results[i.class.name.split("::").last] = res

      assert res
      assert_equal 2, res.size

      assert_equal res[:spam], res[:ham]
    end

    assert_equal results['MongoidInterface'], results["MemoryInterface"]
  end

  should "give same results as memory interface" do
    m = [ BayesMotel::Persistence::MongoidInterface.new("test-weight"),
          BayesMotel::Persistence::MemoryInterface.new("test-weight")
        ]

    results = {}
    m.each do |i|
        c = BayesMotel::Corpus.new i
        c.train({ :something => 'foo' }, :ham)
        c.train({ :something => 'foo' }, :spam)
        c.train({ :something => 'foo', :fubwhiz => 'oh noes' }, :spam)

        doc = { :something => 'foo' }
        res = c.score(doc)
        assert_equal 2, res.size
        assert res[:spam] > res[:ham]
        assert_equal :spam, c.classify(doc).first

        results[i.class.name.split("::").last] = res
    end

    assert_equal results['MongoidInterface'], results["MemoryInterface"]
  end

  should "calculate score for nested documents" do
    mm = BayesMotel::Persistence::MongoidInterface.new("test-score")
    c = BayesMotel::Corpus.new(mm)
    c.train({ :something => 'foo', :kids => { :bar => 'whiz', :id => 123 } }, :ham)
    c.train({ :something => 'foo', :kids => { :bar => 'gee', :id => 145 } }, :spam)

    doc = { :something => 'foo', :kids => { :bar => 'gee', :id => 167, :ack => 'blag' }}
    results = c.score(doc)
    assert results
    assert_equal 2, results.size

    assert_equal results[:spam], 2*results[:ham]

    assert_equal :spam, c.classify(doc).first
  end
end
