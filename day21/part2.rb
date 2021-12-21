#!/usr/bin/env ruby
# frozen_string_literal: true
require 'memoist'

file_path = File.expand_path('input.txt', __dir__)

players = File.read(file_path).split("\n").map{ |p| { 'pos' => p.chars.drop(28).join.to_i, 'score' => 0 }}

class Game
  extend Memoist

  def outcomes(r=3, fq = {0 => 1})
    return fq if r == 0

    new_fq = {}
    [1,2,3].each do |t|
      fq.each do |k,v|
        x = k + t
        new_fq[x] = 0 if !new_fq.key?(x)
        
        new_fq[x] += v
      end
    end

    return outcomes(r-1, new_fq)
  end

  def move(pos, moves)
    pos += moves
    pos = (pos % 10) if pos > 10
    pos = 10 if pos == 0
    
    pos
  end

  def roll(players, turn)
    wins = [0,0]
    p1 = players[0]
    p2 = players[1]

    return [1, 0] if p1['score'] >= 21 
    return [0, 1] if p2['score'] >= 21
      
    outcomes.each do |k,v|
      if turn == 0
        new_pos = move(p1['pos'], k)
        new_p1 = {
          'pos' => new_pos,
          'score' => (p1['score'] + new_pos)
        }
        new_p2 = p2
      else
        new_pos = move(p2['pos'], k)
        new_p2 = {
          'pos' => new_pos,
          'score' => (p2['score'] + new_pos)
        }
        new_p1 = p1
      end

      t_wins = roll([new_p1, new_p2], (turn + 1) % 2)

      wins[0] += t_wins[0] * v
      wins[1] += t_wins[1] * v
    end
    
    return wins

  end

  memoize :roll
end

g = Game.new

puts g.roll(players, 0)
