desc '####################### load studies'
task load_studies: :environment do
  puts 'Executing...'


#  data_dir = Pathname.new(APP_CONFIG[:data_dir])

  all = 0
  found = 0

  list_dois = []

  list_dois = Dataset.all.map{|d| d.doi}.flatten.uniq #Study.all.map{|s| s.doi and s.status_id == 1 and s.first_author == nil}

  list_dois.each do |doi|

    h = CustomFetch.doi_info(doi)
    #        puts h.to_json                                                                                                                              
    all+=1
    if h.keys.size > 0 and h[:first_author] != nil and h[:title]
      
      found+=1
      s = Study.where(:doi => doi).first
      if !s
        h.delete(:title)
        s = Study.new(h)
        s.save
      else
        puts "Update study..."
        #            h[:key] = Basic.create_key(Study, 6) if !s.key                                                                                      
        s.update(h)
      end
    else
      puts "#{doi}: Not found"
    end
    
  end
  puts all
  puts found

end
