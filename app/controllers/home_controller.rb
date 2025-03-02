class HomeController < ApplicationController
  before_action :authenticate_user!  # Gunakan Devise untuk autentikasi

  def index
  end
end
