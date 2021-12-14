#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

poly = input.split("\n\n").first.chars

pairs = []

poly.each_cons(2) do |p|
  pairs.push(p.join)
end

pairs = pairs.group_by(&:itself).transform_values(&:size)
groups = poly.group_by(&:itself).transform_values(&:size)

inserts = input.split("\n\n").last.split("\n").map { |i| i.split(' -> ') }.to_h

cnt = 0
(0..39).each do |_s|
  new_pairs = {}
  pairs.each do |p, c|
    ins = inserts[p]
    elems = p.chars
    p1 = elems[0] + ins
    p2 = ins + elems[1]

    if new_pairs.key?(p1)
      new_pairs[p1] += c
    else
      new_pairs[p1] = c
    end

    if new_pairs.key?(p2)
      new_pairs[p2] += c
    else
      new_pairs[p2] = c
    end

    if groups.key?(ins)
      groups[ins] += c
    else
      groups[ins] = c
    end
  end

  pairs = new_pairs

  cnt += 1
end

groups = groups.map { |_k, v| v }.sort
puts groups.last - groups.first
