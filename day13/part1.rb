#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

field = input.split("\n\n").first.split("\n").map { |c| c.split(',').map(&:to_i) }
folds = input.split("\n\n").last.split("\n").map { |c| c.slice(11, c.size).split('=') }

folds.each do |f|
  line = f[1].to_i
  fold = f[0]

  field.each do |d|
    next if (fold == 'y') && (line > d[1])
    next if (fold == 'x') && (line > d[0])

    d[1] = line - (d[1] - line) if fold == 'y'
    d[0] = line - (d[0] - line) if fold == 'x'
  end

  field = field.uniq
  puts field.size
  break
end
