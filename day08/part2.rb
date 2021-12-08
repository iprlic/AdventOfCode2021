#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

signals = input.split("\n").map { |l| l.split(' | ').map(&:split) }

sum = 0
signals.each do |s|
  output = []

  wires = s.first.sort_by(&:length).map { |w| w.chars.sort }
  displays = s.last.map { |w| w.chars.sort }

  zero = []
  one = wires[0]
  two = []
  three = []
  four = wires[2]
  five = []
  six = []
  seven = wires[1]
  eight = wires.last
  nine = []

  a = seven.difference(one).first
  # find three
  [3, 4, 5].each do |i|
    next unless wires[i].difference(seven).size == 2

    three = wires[i]
  end

  b = four.difference(three).first
  g = three.difference(four).difference(seven).first
  d = (three - [a, g]).difference(one).first

  # find two and five
  [3, 4, 5].each do |i|
    next if wires[i] == three

    if wires[i].include?(b)
      five = wires[i]
    else
      two = wires[i]
    end
  end

  # find the rest
  [6, 7, 8].each do |i|
    if wires[i].include?(d)
      if (wires[i] & one).size == 2
        nine = wires[i]
      else
        six = wires[i]
      end
    else
      zero = wires[i]
    end
  end

  all = [zero, one, two, three, four, five, six, seven, eight, nine]

  output = []

  displays.each do |x|
    (0..9).each do |i|
      if all[i] == x
        output.push(i)
        break
      end
    end
  end

  sum += output.join.to_i
end

puts sum
