#!/usr/bin/env ruby
# frozen_string_literal: true

def breed(fish)
  new_fish = []

  fish.each do |f|
    if f.positive?
      new_fish.push(f - 1)
    else
      new_fish.push(6)
      new_fish.push(8)
    end
  end

  new_fish
end

def spawn(fish, generation)
  generation += 1
  if generation > 80
    puts fish.size
    exit(0)
  end

  spawn(breed(fish), generation)
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

fish = input.split(',').map(&:to_i)

spawn(fish, 0)
