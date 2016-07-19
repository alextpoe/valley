require 'csv'

class UsersController < ApplicationController
  attr_accessor :new_string

  def index

    @users = params["user"] || []

  end

  def new
    render :new
  end

  def create
    string = params["user"]["name"]
    new_string = ""

    string = string.each_char do |char|
      char = "%20" if char == " "
      new_string << char
    end

    page = HTTParty.get("https://medium.com/search/users?q=#{new_string}")

    parse_page = Nokogiri::HTML(page)

    users_array = []

    parse_page.css(".js-userResultsList").css(".card-user").css(".card-content").css(".card-name").css(".link").each do |obj|
      users_array << obj.attributes["href"].value
    end

    user = User.new(users_array)

    @new_string = {user: user.users}

    redirect_to users_url(@new_string)
  end

end
