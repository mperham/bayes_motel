require 'helper'
require 'fileutils'

class TestPersistence < MiniTest::Test

  should "persist" do
    c1 = BayesMotel::Corpus.new('test1')
    c1.train({ :something => 'foo', :kids => { :bar => 'whiz', :id => 123 } }, :ham)
    c1.train({ :something => 'foo', :kids => { :bar => 'gee', :id => 145 } }, :spam)

    BayesMotel::Persistence.write(c1)
    c2 = BayesMotel::Persistence.read('test1')
    FileUtils.rm_f 'test1'
    assert c1 != c2
    c1.instance_variables.each do |var|
      v1 = c1.instance_variable_get(var)
      v2 = c2.instance_variable_get(var)
      assert_equal v1, v2
    end
  end

end
