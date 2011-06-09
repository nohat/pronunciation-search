desc "Imports words and pronunciations from CMUdict"
task :import_cmudict => :environment do
  # svn checkout https://cmusphinx.svn.sourceforge.net/svnroot/cmusphinx/trunk/cmudict/
  puts "importing cmudict"
  ActiveRecord::Base.transaction do
    File.open('tmp/cmudict/cmudict.0.7a', 'r').each_line do |line|
      next if line =~ /^;;;/
      input_word, pronunciation = line.chomp.split('  ')
      input_word.sub! /\(\d\)$/, ''
      word = Word.find_by_name(input_word) || Word.create(:name => input_word)
      word.pronunciations.create(:arpabet => pronunciation)
    end
  end
end