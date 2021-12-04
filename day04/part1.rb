#!/usr/bin/env ruby
# frozen_string_literal: true

def draw(nums, deck)
  current = nums.shift

  deck.each do |c|
    mark(c, current)
  end
  draw(nums, deck)
end

def score(deck, num)
  puts deck.sum { |d| d.sum { |x| x != 'x' ? x.to_i : 0 } } * num.to_i
end

def mark(deck, num)
  (0..4).each do |i|
    (0..4).each do |j|
      next unless num == deck[i][j]

      deck[i][j] = 'x'
      if check(deck, i, j)
        score(deck, num)
        exit(0)
      end
    end
  end
end

def check(deck, row, column)
  rows_check = check_direction(deck, row, true)
  return true if rows_check

  check_direction(deck, column, false)
end

def check_direction(deck, line, row)
  cnt = 0
  (0..4).each do |i|
    if row
      cnt += 1 if deck[line][i] == 'x'
    elsif deck[i][line] == 'x'
      cnt += 1
    end
  end

  return true if cnt == 5

  false
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

cards = input.split("\n\n")

draws = cards.shift.split(',')

cards = cards.map { |c| c.split("\n").map(&:split) }

draw(draws, cards)
