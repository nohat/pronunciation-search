Factory.define :word do |word|
  word.name 'testword'
end

Factory.define :word_with_pronunciation, :parent => :word do |word|
  word.pronunciations = [Factory :pronunciation]
end

Factory.define :pronunciation do |pronunciation|
  pronunciation.arpabet 'P R OW0 N AH2 N S IY0 EY1 SH AH0 N'
end