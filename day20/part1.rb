#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

replacement = File.read(file_path).split("\n\n").first.chars
image = File.read(file_path).split("\n\n").last.split("\n").map(&:chars)

change_edge = replacement.first == '#'
edge = '.'

2.times do
  h = image.size + 8
  w = image.size + 8

  image = image.map { |r| [edge, edge, edge, edge] + r + [edge, edge, edge, edge] }

  image.unshift(Array.new(w, edge))
  image.push(Array.new(w, edge))
  image.unshift(Array.new(w, edge))
  image.push(Array.new(w, edge))
  image.unshift(Array.new(w, edge))
  image.push(Array.new(w, edge))
  image.unshift(Array.new(w, edge))
  image.push(Array.new(w, edge))

  new_image = Array.new(h) { Array.new(w) }

  cnt = 0
  (0..(h - 1)).each do |i|
    (0..(w - 1)).each do |j|
      code = []

      if i.positive? && j.positive?
        code.push(image[i - 1][j - 1] == '#' ? '1' : '0')
      else
        code.push('0') if edge == '.'
        code.push('1') if edge == '#'
      end

      if i.positive?
        code.push(image[i - 1][j] == '#' ? '1' : '0')
      else
        code.push('0') if edge == '.'
        code.push('1') if edge == '#'
      end

      if i.positive? && (j < w - 1)
        code.push(image[i - 1][j + 1] == '#' ? '1' : '0')
      else
        code.push('0') if edge == '.'
        code.push('1') if edge == '#'
      end

      if j.positive?
        code.push(image[i][j - 1] == '#' ? '1' : '0')
      else
        code.push('0') if edge == '.'
        code.push('1') if edge == '#'
      end

      code.push(image[i][j] == '#' ? '1' : '0')

      if j < w - 1
        code.push(image[i][j + 1] == '#' ? '1' : '0')
      else
        code.push('0') if edge == '.'
        code.push('1') if edge == '#'
      end

      if (i < h - 1) && j.positive?
        code.push(image[i + 1][j - 1] == '#' ? '1' : '0')
      else
        code.push('0') if edge == '.'
        code.push('1') if edge == '#'
      end

      if i < h - 1
        code.push(image[i + 1][j] == '#' ? '1' : '0')
      else
        code.push('0') if edge == '.'
        code.push('1') if edge == '#'
      end

      if (i < h - 1) && (j < w - 1)
        code.push(image[i + 1][j + 1] == '#' ? '1' : '0')
      else
        code.push('0') if edge == '.'
        code.push('1') if edge == '#'
      end

      s = replacement[code.join.to_i(2)]

      new_image[i][j] = s
    end
  end

  image = new_image

  next unless change_edge

  edge = if edge == '#'
           '.'
         else
           '#'
         end
end

print image.flatten.select { |c| c == '#' }.size
