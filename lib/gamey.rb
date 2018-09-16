require 'gosu'
require 'set'

require 'gamey/version'

module Gamey
  require 'gamey/core'
  require 'gamey/patch'
  require 'gamey/game'


  def self.clamp(n, a, b)
    if n > b
      b
    elsif n < a
      a
    else
      n
    end
  end
  
end
