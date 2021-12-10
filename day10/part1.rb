#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

field =  input.split("\n").map(&:chars)

opening = ['(', '[', '{', '<']
closing = [')', ']', '}', '>']

firsts = []

field.each do |f|
  opens = []
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
      firsts.push(c)
      break
    end
  end
end

sum = 0
firsts.each do |f|
  case f
  when ')'
    sum += 3
  when ']'
    sum += 57
  when '}'
    sum += 1197
  when '>'
    sum += 25_137
  end
end

puts sum
