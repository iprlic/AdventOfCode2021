#!/usr/bin/env ruby
# frozen_string_literal: true

def breed(fish)
  new_fish = {}

  fish.each do |f, v|
    if f.positive?
      new_fish.key?(f - 1) ? new_fish[f - 1] += v : new_fish[f - 1] = v
    else
      new_fish.key?(6) ? new_fish[6] += v : new_fish[6] = v
      new_fish[8] = v
    end
  end

  new_fish
end

def spawn(fish, generation)
  generation += 1

  if generation > 256
    sum = 0
    fish.each { |_k, v| sum += v }
    puts sum
    exit(0)
  end

  spawn(breed(fish), generation)
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

fish = input.split(',').map(&:to_i)
fish_by_age = {}

fish.each do |f|
  fish_by_age.key?(f) ? fish_by_age[f] += 1 : fish_by_age[f] = 1
end

spawn(fish_by_age, 0)
