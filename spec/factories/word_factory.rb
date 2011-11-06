Factory.define :word do |word|
  word.name 'testword'
end

Factory.define :word_with_pronunciation, :parent => :word do |word|
  word.pronunciations do
    [Factory(:pronunciation)]
  end
end
