class Gtrend < ApplicationRecord
  serialize :keywords, Array
  serialize :results, Hash
end
