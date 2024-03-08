# frozen_string_literal: true

module CacheHelper
  def with_caching
    original_cache_store = Rails.configuration.cache_store

    change_cache_store(:memory_store)

    yield

    Rails.cache.clear
    change_cache_store(original_cache_store)
  end

  private

  def change_cache_store(store)
    Rails.configuration.cache_store = store
    Rails.cache = ActiveSupport::Cache.lookup_store(store)
  end
end
