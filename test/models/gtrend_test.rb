require 'test_helper'
require 'json'

class GtrendTest < ActiveSupport::TestCase
  
  test 'has valid data' do
    trend = build(:gtrend)
    assert trend.valid?
  end
  
  test 'keywords association' do
    keyword = create(:keyword)
    assert keyword.gtrend.present?
  end
  
  test 'associated keywords should be destroyed on gtrend deletion' do
    keyword = create(:keyword)
    trend = keyword.gtrend
    trend.destroy
    assert_raises(ActiveRecord::RecordNotFound) do
      keyword.reload
    end
  end
  
  test 'name must be present' do
    trend = build(:gtrend, name: '   ')
    assert trend.invalid?
    assert trend.errors[:name].present?
  end
  
  test 'name must be unique' do
    trend1 = create(:gtrend, name: 'test')
    trend2 = build(:gtrend, name: 'test')
    assert_equal trend1.name, trend2.name
    assert trend2.invalid?
    assert trend2.errors[:name].present?
  end
  
  test 'name should be case insensitive' do
    trend1 = create(:gtrend, name: 'test')
    trend2 = build(:gtrend, name: 'TEST')
    assert_equal trend1.name, trend2.name.downcase
    assert trend2.invalid?
    assert trend2.errors[:name].present?
  end
  
  test 'name should not be too short' do
    trend = build(:gtrend, name: 'a')
    assert trend.invalid?
    assert trend.errors[:name].present?
  end
  
  test 'name should not be too long' do
    trend = build(:gtrend, name: 'a'*101)
    assert trend.invalid?
    assert trend.errors[:name].present?
  end
  
  test 'kws must be present' do
    trend = build(:gtrend, kws: '   ')
    assert trend.invalid?
    assert trend.errors[:kws].present?
  end
  
  test 'kws should not be too long' do
    trend = build(:gtrend, kws: 'a'*5001)
    assert trend.invalid?
    assert trend.errors[:kws].present?
  end
  
  test 'kw count must not exceed 100' do
    trend = build(:gtrend, kws: 'a,'*101)
    assert trend.invalid?
    assert trend.errors[:kws].present?
  end
  
  test 'kws validation should be skipped on gtrend update' do
    trend = create(:gtrend)
    trend.reload
    trend.update(name: 'foo')
    assert trend.kws.nil?
    assert trend.valid?
  end
  
  test 'convert_kws_to_list method' do
    trend = create(:gtrend, kws: 'one
                                  two   , three,  ,    four   ')
    # kws data is saved as a string version of an array
    # parsing as json converts it back to an actual array
    assert_equal ['one', 'two', 'three', 'four'], JSON.parse(trend.kws)
  end
  
  test 'convert_kws_to_list should be skipped on gtrend update' do
    trend = create(:gtrend)
    trend.reload
    trend.update(kws: 'one, two, three')
    assert_equal 'one, two, three', trend.kws
  end
  
end
