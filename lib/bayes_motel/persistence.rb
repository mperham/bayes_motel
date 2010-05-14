module BayesMotel
  module Persistence
    # TODO Make this a little more Ruby idiomatic and pluggable
    # for filesystems, databases, etc.
    def self.write(corpus)
      File.open("#{corpus.name}", 'w') do |file|
        Marshal.dump(corpus, file)
      end
    end
    def self.read(name)
      Marshal.load(File.read("#{name}"))
    end
  end
end