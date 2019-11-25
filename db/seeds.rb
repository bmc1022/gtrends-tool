class DataGenerator
  def trend_lists
    Gtrend.destroy_all
    
    pests = ['ant', 'fire ant', 'sugar ant', 'aphid', 'bed bug', 'bee', 'beetle', 
            'centipede', 'cricket', 'earwig', 'flea', 'gnat', 'millipede', 'mite', 
            'moth', 'scorpion', 'slug', 'snail', 'spider', 'springtail', 'stink bug', 
            'termite', 'tick', 'wasp']
    
    pests.each do |pest|
      kws = ["how to get rid of #{pest}s", "get rid of #{pest}s", "kill #{pest}s", 
             "#{pest} control", "#{pest} killer", "#{pest} bait", "#{pest} poison",
             "how to kill #{pest}s", "best #{pest} killer", "getting rid of #{pest}s", 
             "how to get rid of #{pest}s in the house", "natural #{pest} killer", 
             "get rid of #{pest}s in the house", "how do i get rid of #{pest}s", 
             "how to get rid of #{pest}s in the kitchen", "what kills #{pest}s", 
             "how do you get rid of #{pest}s", "get rid of #{pest}s naturally", 
             "best #{pest} bait", "homemade #{pest} killer", "diy #{pest} killer", 
             "what will keep #{pest}s away", "how to get rid of #{pest}s naturally", 
             "pet safe #{pest} killer", "how to get rid of #{pest}s in bedroom", 
             "how to get rid of #{pest}s outside", "best way to get rid of #{pest}s", 
             "natural #{pest} bait", "diy #{pest} control", "best #{pest} poison",
             "homemade #{pest} poison", "how to get rid of #{pest}s in the bathroom", 
             "getting rid of #{pest}s naturally", "natural #{pest} repellent", 
             "how to get rid of #{pest}s in yard", "what is best for killing #{pest}s",
             "home remedies to get rid of #{pest}s", "natural #{pest} control", 
             "how do i get rid of #{pest}s permanently", "natural #{pest} poison",
             "get rid of #{pest}s in the kitchen", "natural way to get rid of #{pest}s", 
             "how to get rid of #{pest}s in the garden", "homemade #{pest} bait",
             "how to get rid of #{pest}s permanently"]
      
      res = kws.shuffle.sample(rand(10..kws.size)).each_with_object({}) do |kw, hash|
        hash[kw] = weighted_rand
      end
      
      opts = {
        name: "#{pest.titleize}s",
        keywords: kws,
        results: res
      }
      Gtrend.create!(opts)
    end
  end
  
  def weighted_rand
    roll = rand(1..100)
    case roll
      when 1..80   then rand(1..6)
      when 81..95  then rand(7..20)
      when 96..100 then rand(30..40)
    end
  end
end

DataGenerator.new.trend_lists
