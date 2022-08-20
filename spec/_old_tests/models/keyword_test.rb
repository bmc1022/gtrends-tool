# frozen_string_literal: true

require "test_helper"

class KeywordTest < ActiveSupport::TestCase
  test "has valid data" do
    keyword = build(:keyword)
    assert keyword.valid?
  end

  test "gtrend association" do
    keyword = create(:keyword)
    assert keyword.gtrend.present?
  end

  test "kw must be present" do
    keyword = build(:keyword, kw: "   ")
    assert keyword.invalid?
    assert keyword.errors[:kw].present?
  end

  test "kw must be unique" do
    trend = create(:gtrend)
    keyword_1 = create(:keyword, kw: "test", gtrend: trend)
    keyword_2 = build(:keyword, kw: "test", gtrend: trend)
    assert_equal keyword_1.kw, keyword_2.kw
    assert keyword_2.invalid?
    assert keyword_2.errors[:kw].present?
  end

  test "kw uniqueness should be scoped per gtrend" do
    trend_1 = create(:gtrend)
    trend_2 = create(:gtrend)
    keyword_1 = create(:keyword, kw: "test", gtrend: trend_1)
    keyword_2 = build(:keyword, kw: "test", gtrend: trend_2)
    assert_equal keyword_1.kw, keyword_2.kw
    assert keyword_1.valid?
    assert keyword_2.valid?
  end

  test "kw uniqueness should have custom error message" do
    trend = create(:gtrend)
    create(:keyword, kw: "test", gtrend: trend)
    keyword_2 = build(:keyword, kw: "test", gtrend: trend)
    assert keyword_2.invalid?
    assert_equal ["'test' has already been taken"], keyword_2.errors[:kw]
  end

  test "kw should be case insensitive" do
    trend = create(:gtrend)
    keyword_1 = create(:keyword, kw: "test", gtrend: trend)
    keyword_2 = build(:keyword, kw: "TEST", gtrend: trend)
    assert_equal keyword_1.kw, keyword_2.kw.downcase
    assert keyword_2.invalid?
    assert keyword_2.errors[:kw].present?
  end
end
