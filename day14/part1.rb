#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

poly = input.split("\n\n").first.chars

inserts = input.split("\n\n").last.split("\n").map { |i| i.split(' -> ') }

(0..9).each do |_s|
  new_poly = []
  poly.each_cons(2) do |p|
    pair = p.join

    ins = inserts.find { |i| i[0] == pair }[1]

    new_poly += if new_poly.empty?
                  [p[0], ins, p[1]]
                else
                  [ins, p[1]]
                end
  end

  poly = new_poly
end

groups = poly.group_by(&:itself).map { |_k, v| v.size }.sort
puts groups.last - groups.first
