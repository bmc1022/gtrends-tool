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
    keyword1 = create(:keyword, kw: "test", gtrend: trend)
    keyword2 = build(:keyword, kw: "test", gtrend: trend)
    assert_equal keyword1.kw, keyword2.kw
    assert keyword2.invalid?
    assert keyword2.errors[:kw].present?
  end

  test "kw uniqueness should be scoped per gtrend" do
    trend1 = create(:gtrend)
    trend2 = create(:gtrend)
    keyword1 = create(:keyword, kw: "test", gtrend: trend1)
    keyword2 = build(:keyword, kw: "test", gtrend: trend2)
    assert_equal keyword1.kw, keyword2.kw
    assert keyword1.valid?
    assert keyword2.valid?
  end

  test "kw uniqueness should have custom error message" do
    trend = create(:gtrend)
    create(:keyword, kw: "test", gtrend: trend)
    keyword2 = build(:keyword, kw: "test", gtrend: trend)
    assert keyword2.invalid?
    assert_equal ["'test' has already been taken"], keyword2.errors[:kw]
  end

  test "kw should be case insensitive" do
    trend = create(:gtrend)
    keyword1 = create(:keyword, kw: "test", gtrend: trend)
    keyword2 = build(:keyword, kw: "TEST", gtrend: trend)
    assert_equal keyword1.kw, keyword2.kw.downcase
    assert keyword2.invalid?
    assert keyword2.errors[:kw].present?
  end
end
