#!/usr/bin/env ruby
# frozen_string_literal: true

require 'memoist'



# split to 14 sets
# memoize them by x, y, z and input
# cycle faster

class Monad
    extend Memoist

    # split to 14 sets
    # memoize them by x, y, z and input
    # cycle faster

    def cycles
        file_path = File.expand_path('input.txt', __dir__)
        monad = File.read(file_path).split("inp w")

        monad.drop(1)
    end

    memoize :cycles

    def cycle(num)
        cmds = cycles[num].split("\n").drop(3).map do |i| 
            ins = i.split(' ') 
            {
                'cmd' => ins[0],
                'a' => ins[1],
                'b' => ins[2]
            }
        end
    end

    memoize :cycle

    def run_cycle(i, state)
        c = cycle(i)

        c.each do |ins|
            state = instruction(ins, state)
            if !state['valid']
                break
            end
        end

        state
    end

    memoize :run_cycle

    def size
        cycles.size
    end

    memoize :size

    def run(num, state)
        (0..size-1).each do |c|
            state['w'] = num[c]
            if state['z'] >= 0
                state['x'] = state['z'] % 26
                state = run_cycle(c, state)

                puts state 
                puts state['z'] % 26
                exit if c == 13
    
                    
            else
                state['valid'] = false
                puts "alarm 1"
                exit
            end

            break if !state['valid']
        end

        state['x'] = 0
        state['y'] = 0
        state['w'] = 0


        state


    end

    def instruction(i, prev_state)
        vars = ['x', 'y', 'z', 'w']
        state = prev_state.clone
        state['valid'] = true
    
        n = vars.include?(i['b']) ? state[i['b']] : i['b'].to_i
    
        case i['cmd']
        when 'add'

            state[i['a']] += n
        when 'mul'
            state[i['a']] *= n
        when 'div'
            state[i['a']] /= n
        when 'mod'
            if n <= 0 or state[i['a']] < 0 
                state['valid'] = false
                puts "alarm 2"
                exit
            else
                state[i['a']] %= n
            end
        when 'eql'
            state[i['a']] = state[i['a']] == n ? 1 : 0
        end
    
        state
    end

    memoize :instruction


    def max
        starting_input = 9298542

        cnt = 0

        loop do
            state = {
                'w' => 0,
                'x' => 0,
                'y' => 0,
                'z' => 0,
                'valid' => true
            }  
            tmp_input = starting_input.to_s.chars.map(&:to_i)

            if tmp_input.include?(0) 
                starting_input -= 1
                next
            end

        
            # max
            #input = [9, 9, 1] + tmp_input.take(2) + [9, 9, 7] + tmp_input.drop(2).take(3) + [9] + tmp_input.drop(5).take(2)

            #min#
            input = [8, 4, 1] + [9, 1] + [5, 2, 1] + [3, 1, 1] + [6] + [1, 1]
            puts input.join
            cnt +=1
            
            state = run(input, state)
        
            if state['valid'] and state['z'] <= 12
                puts starting_input
                exit
            else
                starting_input -= 1
            end

            if cnt % 100000 == 0
                puts starting_input 
                puts state['z']
            end
        end
        
    end

    
end

m = Monad.new

put m.max