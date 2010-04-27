bayes_motel
--------------

BayesMotel is a multi-variate Bayesian classification engine.  There are two steps to Bayesian classification:

1. Training
You provide a set of variables along with the proper classification for that set.
2. Runtime
You provide a set of variables and ask for the proper classification according to the training in Step 1.

Commonly this is used for spam detection.  You will provide a corpus of emails or other data along with a "Spam/NotSpam" classification.  The library will determine which variables affect the classification and use that to judge future data.


Usage
=============

Step one is to create a corpus that you can train with a set of previously classified documents:

    corpse = BayesMotel::Corpus.new('tweets')
    spam_tweets.each do |tweet|
      corpse.train(tweet, :spam)
    end
    good_tweets.each do |tweet|
      corpse.train(tweet, :ham)
    end
    corpse.cleanup

In this example, we have a set of spammy tweets and a set of known good tweets.  We pass in each tweet
to our train() method.  Once we have completed training, we call cleanup which will run through the
internal data structures and clean up any variables that are too 'unique' to make a difference in classification (for instance, an :id variable will be unique for each tweet and so will be removed in the cleanup since it does not repeat enough times).

Step two is to use the calculated corpus for the category scores or a classification for a given document:

    corpse.scores(new_tweet)
    => { :spam => 12.4, :ham => 15.25 }
    corpse.classify(new_tweet)
    => [:ham, 15.25]


Author
==============

Mike Perham, mperham AT gmail.com, @mperham, http://mikeperham.com


Copyright
==============

Copyright (c) 2010 Mike Perham. See LICENSE for details.
