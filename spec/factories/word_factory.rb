FactoryGirl.define do
  factory :word do
    name 'testword'

    factory :word_with_pronunciation do
      after_create do |word|
        FactoryGirl.create_list(:pronunciation, 1, word: word)
      end
    end
  end
end