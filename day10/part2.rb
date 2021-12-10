#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

field =  input.split("\n").map(&:chars)

opening = ['(', '[', '{', '<']
closing = [')', ']', '}', '>']

scores = []

field.each do |f|
  opens = []
  correct = true

  f.each do |c|
    opens.push(c) if opening.include?(c)

    next unless closing.include?(c)

    match = false
    case opens.last
    when '('
      match = true if c == ')'
    when '['
      match = true if c == ']'
    when '{'
      match = true if c == '}'
    when '<'
      match = true if c == '>'
    end

    if match
      opens.pop
    else
      correct = false
      break
    end
  end

  next unless correct

  score = 0
  opens.reverse.each do |o|
    score *= 5
    case o
    when '('
      score += 1
    when '['
      score += 2
    when '{'
      score += 3
    when '<'
      score += 4
    end
  end

  scores.push(score)
end

puts scores.sort[scores.size / 2]
