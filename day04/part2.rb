#!/usr/bin/env ruby

def draw(nums, deck)
    current = nums.shift

    reduced_deck = []

    deck.each do |c|
        if not mark(c, current)
            reduced_deck.push(c) 
        elsif deck.size == 1
            score(c, current)
            exit(0)
        end
    end

    draw(nums, reduced_deck)
end

def score(deck, num)
    puts deck.sum{ |d| d.sum { |x| x!= "x" ? x.to_i : 0 }} * num.to_i
end

def mark(deck, num)
    for i in 0..4 do
        for j in 0..4 do
            if num == deck[i][j]
                deck[i][j] = "x" 
                if check(deck, i, j)
                    return true      
                end
            end
        end
    end
    
    false
end

def check(deck, row, column)

    cnt = 0
    for i in 0..4 do
        cnt +=1 if deck[row][i] == "x"
    end
  
    return true if cnt == 5
    cnt = 0
    for i in 0..4 do
        cnt +=1 if deck[i][column] == "x"
    end

    return true if cnt == 5

    false
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

cards = input.split("\n\n")

draws = cards.shift.split(',')

cards = cards.map{ |c| c = c.split("\n").map{ |r| r = r.split } }

draw(draws, cards)
