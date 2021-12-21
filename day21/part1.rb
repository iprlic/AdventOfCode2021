#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

start = File.read(file_path).split("\n").map{ |p| p.chars.drop(28).join.to_i }

p1 = start.first
p2 = start.last


moves = 0
score1 = 0
score2 = 0
turn = '1'

roll = 0
last = 0

cnt = 0
loop do
    cnt +=1
    roll +=3

    sum = 0

    last += 1
    last = last % 100 if last > 100
    sum += last

    last += 1
    last = last % 100 if last > 100
    sum += last

    last += 1
    last = last % 100 if last > 100
    sum += last



    if turn == '1'
      p1 += sum
      p1 = (p1 % 10) if p1 > 10
      p1 = 10 if p1 == 0
      score1 += p1

      if score1 >= 1000
        puts score2 * roll
        puts "🤮"
        exit
      end

      turn = '2'
    else
      p2 += sum
      p2 = p2 % 10 if p2 > 10
      p2 = 10 if p2 == 0

      score2 += p2

      if score2 >= 1000
        puts score1 * roll
        puts "🤮"
        exit
      end

      turn = '1'
    end
end

