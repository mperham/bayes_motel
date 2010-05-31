bayes_motel_aseever
--------------

This version of bayes_motel is initialized with a persistence object to interact with a data store of your choosing. 
In memory (BayesMotel::Persistence::MemoryInterface), Mongomapper (BayesMotel::Persistence::MongomapperInterface) and Mongoid (BayesMotel::Persistence::MongoidInterface) interfaces are provided.

This version also tracks a "document ID" if provided at training time. 
If an ID is provided, attempting to re-train on the same document and the same category will have no effect on the trainer.
Attempting to re-train with a different category will decrement the appropriate category scores and increment the new ones.
Destroying that document will remove its scores from the corpus.
Note that if an ID is not supplied, the ID will be set to the total_count incrementer, and if looked up can be supplied later for retraining. 

MemoryInterface.save_to_mongo can be used to create a batching operation by scoring in memory, then dumping the data to MongoDB. 

To use the MongoDB version, MongoDB and the MongoMapper or Mongoid gem are required.

BayesMotel is a multi-variate Bayesian classification engine.  There are two steps to Bayesian classification:

1. Training
You provide a set of variables along with the proper classification for that set.

2. Runtime
You provide a set of variables and ask for the proper classification according to the training in Step 1.

Commonly this is used for spam detection.  You will provide a corpus of emails or other data along with a "Spam/NotSpam" classification.  The library will determine which variables affect the classification and use that to judge future data.


Usage
=============

    require 'bayes_motel'
    a = {"a"=>1,"b"=>2}
    b = {"a"=>0,"b"=>1}

#Testing In Memory

    mm = BayesMotel::Persistence::MemoryInterface.new("spamfilter1")
    cmm = BayesMotel::Corpus.new(mm)
    cmm.train(a,:spam, 1)
    cmm.train(b,:ham, 2)
    cmm.score(a)
    cmm.score(b)

    mm.save_to_mongo

    cmm.train(a,:spam, 1) 
    cmm.score(a) 
    cmm.train(a,:ham, 1)
    cmm.score(a)  
    cmm.destroy_document(a, 1) 
    cmm.score(a)  

#Testing Mongo

    mo = BayesMotel::Persistence::MongomapperInterface.new("spamfilter2")

..or for mongoid support...

    mo = BayesMotel::Persistence::MongoidInterface.new("spamfilter2")


    cmo = BayesMotel::Corpus.new(mo)
    cmo.train(a,:spam, 1)
    cmo.train(b,:ham, 2)
    cmo.score(a)
    cmo.score(b)
    cmo.train(a,:spam, 1)
    cmo.score(a)
    cmo.train(a,:ham, 1)
    cmo.score(a)
    cmo.destroy_document(a, 1) 
    cmo.score(a) 

#Testing the save_to_mongo above

    smo = BayesMotel::Persistence::MongomapperInterface.new("spamfilter1")

..or again for mongoid support...

    smo = BayesMotel::Persistence::MongoidInterface.new("spamfilter1")

    scmo = BayesMotel::Corpus.new(smo)
    scmo.score(a)
    scmo.score(b)

Trivia
==============

Bates Motel is the motel in Alfred Hitchcock's masterpiece _Pyscho_.  Corpus is Latin for "body" but also means 'a canonical set of documents'.  I'm not crazy, I just like puns.


Author
==============

Mike Perham, mperham AT gmail.com, @mperham, http://mikeperham.com
Fork by Adam Seever, aseever AT gmail.com, @aseever, http://adamseever.com
Fork again by Hunter Nield, hunter AT infinite.ly, @hunternield, http://infinite.ly


Copyright
==============

Copyright (c) 2010 Mike Perham. See LICENSE for details.
