#!/usr/bin/env ruby

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

moves = input.split("\n").map{ |m| { 'move': m.split[0], 'value': m.split[1].to_i}}

location = {
    'depth': 0,
    'horizontal': 0
}

moves.each do |m|
    puts m
    case m[:move]
    when 'forward'
        location[:horizontal] += m[:value]
    when 'down'
        location[:depth] += m[:value]
    when 'up'
        location[:depth] -= m[:value]
    else
        raise "Unknown move: #{m[:move]}"
    end
end

puts location[:depth] * location[:horizontal]