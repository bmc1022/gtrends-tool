# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    authorize(:page, :home?)
  end
end
