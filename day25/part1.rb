#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
snail_map = File.read(file_path).split("\n").map(&:chars)

h = snail_map.size
w = snail_map.first.size

snails = []

(0..h - 1).each do |i|
  (0..w - 1).each do |j|
    next unless snail_map[i][j] != '.'

    snails.push(
      {
        'x' => j,
        'y' => i,
        'herd' => snail_map[i][j]
      }
    )
  end
end

cnt = 0

loop do
  new_snails = []
  new_snail_map = Array.new(h) { Array.new(w, '.') }
  # move left
  cnt += 1

  moves = false

  snails.each do |s|
    x = s['x']
    y = s['y']

    if s['herd'] == 'v'
      new_snail_map[y][x] = 'v'
      new_snails.push(
        {
          'x' => x,
          'y' => y,
          'herd' => 'v'
        }
      )
    end

    next unless s['herd'] == '>'

    next_x = x + 1
    next_x = 0 if next_x == w

    if snail_map[y][next_x] == '.'
      new_snail_map[y][next_x] = '>'
      new_snails.push(
        {
          'x' => next_x,
          'y' => y,
          'herd' => '>'
        }
      )
      moves = true
    else
      new_snail_map[y][x] = '>'
      new_snails.push(
        {
          'x' => x,
          'y' => y,
          'herd' => '>'
        }
      )
    end
  end

  snail_map = new_snail_map
  snails = new_snails

  new_snails = []
  new_snail_map = Array.new(h) { Array.new(w, '.') }

  snails.each do |s|
    x = s['x']
    y = s['y']

    if s['herd'] == '>'
      new_snail_map[y][x] = '>'
      new_snails.push(
        {
          'x' => x,
          'y' => y,
          'herd' => '>'
        }
      )
    end

    next unless s['herd'] == 'v'

    next_y = y + 1
    next_y = 0 if next_y == h

    if snail_map[next_y][x] == '.'
      new_snail_map[next_y][x] = 'v'
      new_snails.push(
        {
          'x' => x,
          'y' => next_y,
          'herd' => 'v'
        }
      )
      moves = true
    else
      new_snail_map[y][x] = 'v'
      new_snails.push(
        {
          'x' => x,
          'y' => y,
          'herd' => 'v'
        }
      )
    end
  end

  snails = new_snails
  snail_map = new_snail_map

  unless moves
    puts cnt
    exit
  end
end
