require './lib/boardgame.rb'
require './lib/scraper.rb'
require 'nokogiri'
require 'colorize'

class CommandLineInterface

  def run
    make_boardgames
    add_attributes_to_boardgames
    call
  end

  def make_boardgames
    boardgame_array = Scraper.scrape_top_50
    Boardgame.create_from_collection(boardgame_array)
  end

  def add_attributes_to_boardgames
    Boardgame.all.each do |boardgame|
      attributes = Scraper.scrape_boardgame_attributes(boardgame.url)
      boardgame.add_boardgame_attributes(attributes)
    end
  end

  def display_info(boardgame)
    puts "#{boardgame.name.upcase}".colorize(:red)
    puts "  URL:".colorize(:blue) + " #{boardgame.url}"
    puts "  Description:".colorize(:blue) + " #{boardgame.description}"
    puts "  Price:".colorize(:blue) + " #{boardgame.price}"
    puts "  Ages:".colorize(:blue) + " #{boardgame.ages}"
    puts "  Players:".colorize(:blue) + " #{boardgame.players}"
    puts "  Play Time:".colorize(:blue) + " #{boardgame.play_time}"
    puts "  Mechanics:".colorize(:blue) + " #{boardgame.mechanics}"
    puts "--------------------------------------------------------------------".colorize(:green)
  end

  def display_all
    Boardgame.all.each do |boardgame|
      display_info(boardgame)
    end
  end

  def call
    puts "--------------------------------------------------------------------".colorize(:green)
    puts "Welcome to the Top 50 Boardgame Catalog!".colorize(:red)
    puts "--------------------------------------------------------------------".colorize(:green)
    input = ""
    while input != "exit"
      puts "To list all boardgames, enter 'list all'.".colorize(:yellow)
      puts "To quit, type 'exit'.".colorize(:yellow)
      print "What would you like to do? "

      input = gets.strip
      case input
        when "list all"
          display_all
        when "exit"
        else
          puts "I did not recognize that command, please try again"
      end
    end
  end

end