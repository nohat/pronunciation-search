Welcome to Pron
===============

Pron is a Rails application for a site that allows searching for pronunciations
of words. 

It currently uses the [CMU Pronouncing dictionary](http://www.speech.cs.cmu.edu/cgi-bin/cmudict)
(cmudict) as its data source and displays pronunciations using cmudict's native
format ARPAbet as well as using the International Phonetic Alphabet.

The app contains functionality to find syllable boundaries in English words
and it uses this functionality to convert cmudict pronunciations to IPA with
correctly-placed stress markers.

That's about all it does for now. It is not deployed anywhere public nor does the search
interface do very much other than substring matching on words and pronunciations.