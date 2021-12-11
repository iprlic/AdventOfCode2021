#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

field =  input.split("\n").map { |c| c.chars.map(&:to_i) }

x = field.first.size - 1
y = field.size - 1

flashes = 0

def check_flash(field, i, j, x, y)
  sum = 0

  if field[i][j] > 9
    sum += 1
    field[i][j] = -1

    if i.positive? && (field[i - 1][j] != -1)
      field[i - 1][j] += 1
      sum += check_flash(field, i - 1, j, x, y)
    end

    if j.positive? && (field[i][j - 1] != -1)
      field[i][j - 1] += 1
      sum += check_flash(field, i, j - 1, x, y)
    end

    if (j < x) && (field[i][j + 1] != -1)
      field[i][j + 1] += 1
      sum += check_flash(field, i, j + 1, x, y)
    end

    if (i < y) && (field[i + 1][j] != -1)
      field[i + 1][j] += 1
      sum += check_flash(field, i + 1, j, x, y)
    end

    if i.positive? && j.positive? && (field[i - 1][j - 1] != -1)
      field[i - 1][j - 1] += 1
      sum += check_flash(field, i - 1, j - 1, x, y)
    end

    if (i < x) && (j < y) && (field[i + 1][j + 1] != -1)
      field[i + 1][j + 1] += 1
      sum += check_flash(field, i + 1, j + 1, x, y)
    end

    if (i < x) && j.positive? && (field[i + 1][j - 1] != -1)
      field[i + 1][j - 1] += 1
      sum += check_flash(field, i + 1, j - 1, x, y)
    end

    if i.positive? && (j < y) && (field[i - 1][j + 1] != -1)
      field[i - 1][j + 1] += 1
      sum += check_flash(field, i - 1, j + 1, x, y)
    end

  end

  sum
end

100.times do
  (0..y).each do |i|
    (0..x).each do |j|
      field[i][j] += 1 if field[i][j] > -1
      flashes += check_flash(field, i, j, x, y)
    end
  end

  (0..y).each do |i|
    (0..x).each do |j|
      field[i][j] = 0 if field[i][j] == -1
    end
  end
end

puts flashes
