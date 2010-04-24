bayes_hotel
--------------

BayesHotel is a multi-variate Bayesian classification engine.  There are two steps to Bayesian classification:

1. Training
You provide a set of variables along with the proper classification for that set.
2. Runtime
You provide a set of variables and ask for the proper classification according to the training in Step 1.

Commonly this is used for spam detection.  You will provide a corpus of emails or other data along with a "Spam/NotSpam"
classification.  The library will determine which variables affect the classification and use that to judge future
data.


Author
==============

Mike Perham, mperham AT gmail.com, @mperham, http://mikeperham.com


Copyright
==============

Copyright (c) 2010 Mike Perham. See LICENSE for details.
