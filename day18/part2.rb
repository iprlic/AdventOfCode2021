#!/usr/bin/env ruby

file_path = File.expand_path('input.txt', __dir__)
lines = File.read(file_path).split("\n")

def find_split(input)
  brackets = 0
  cnt = 0

  input.chars.each do |i|
    return cnt if (i == ',') && brackets.zero?

    brackets += 1 if i == '['
    brackets -= 1 if i == ']'

    cnt += 1
  end
end

def parse_number(input)
  if input.start_with?('[')
    input.slice!(0, 1)
    input.slice!(input.size - 1, input.size)

    spl = find_split(input)
    nums = [input.slice(0..spl), input.slice(spl + 1..-1)]
    [parse_number(nums[0]), parse_number(nums[1])]
  else
    input.to_i
  end
end

def magnitude(num)
  n1 = if num[0].is_a?(Array)
         magnitude(num[0])
       else
         num[0]
       end

  n2 = if num[1].is_a?(Array)
         magnitude(num[1])
       else
         num[1]
       end

  (3 * n1) + (2 * n2)
end

def sum_nums(a, b)
  num = "[#{a},#{b}]"

  reduce_num(num, 0)
end

def is_num?(num)
  non_nums = ['[', ']', ',']

  return false if non_nums.include?(num)

  true
end

def explode(chars, i)
  begining = chars.slice(0, i)
  ending = chars.slice(i + 1, chars.size)

  cut_right = num_right(ending, 0, 1)
  right = ending.slice(0, cut_right)

  cut_left = num_left(begining, begining.size - 1, 1)
  left = begining.slice(begining.size - cut_left, begining.size)

  left = left.join.to_i
  right = right.join.to_i

  ending = ending.slice(1 + cut_right, ending.size)
  begining = begining.slice(0, begining.size - (1 + cut_left))

  new_begining = []
  found = false
  cnt = 0
  skip = 0
  begining_reverse = begining.reverse

  begining_reverse.each do |b|
    if skip.positive?
      skip -= 1
      next
    end
    if is_num?(b) && (found == false)
      found = true
      skip = num_right(begining_reverse.slice(cnt, begining_reverse.size - 1), 0, 1)

      b2 = begining_reverse.slice(cnt, skip).reverse.join.to_i
      new_begining.push((b2 + left).to_s)
      skip -= 1
    else
      new_begining.push(b)
    end
    cnt += 1
  end

  begining = new_begining.reverse

  begining_found = found

  found = false
  new_ending = []
  cnt = 0
  skip = false
  ending.each do |b|
    if skip
      skip = false
      next
    end

    if is_num?(b) && (found == false)
      found = true
      if !is_num?(ending[cnt + 1])
        new_ending.push((b.to_i + right).to_s)
      else
        b2 = (b + ending[cnt + 1]).to_i
        skip = true
        new_ending.push((b2 + right).to_s)
      end
    else
      new_ending.push(b)
    end
    cnt += 1
  end

  ending = new_ending

  begining.push('0')

  (begining + ending).join
end

def num_right(chars, i, cnt)
  return num_right(chars, i, cnt + 1) if is_num?(chars[i + cnt])

  cnt
end

def num_left(chars, i, cnt)
  return num_left(chars, i, cnt + 1) if is_num?(chars[i - cnt])

  cnt
end

def split(chars, i)
  rights = num_right(chars, i, 1)
  num = chars.slice(i, 1 + rights).join.to_i

  pair = "[#{[(num.to_f / 2).floor.to_i, (num.to_f / 2).ceil.to_i].join(',')}]"

  begining = chars.slice(0, i)
  ending = chars.slice(i + 2, chars.size)

  begining.join + pair + ending.join
end

def reduce_num(num, cnt)
  reduction = false

  chars = num.chars

  brackets = 0
  (0..chars.size - 1).each do |i|
    c = chars[i]
    brackets += 1 if c == '['
    brackets -= 1 if c == ']'

    next unless (c == ',') && (brackets >= 5) && is_num?(chars[i + 1]) && is_num?(chars[i - 1])

    reduction = true
    num = explode(chars, i)
    break
  end

  unless reduction
    brackets = 0
    (0..chars.size - 1).each do |i|
      c = chars[i]
      brackets += 1 if c == '['
      brackets -= 1 if c == ']'

      next unless is_num?(c) && (i < chars.size - 1) && is_num?(chars[i + 1])

      reduction = true
      num = split(chars, i)
      break
    end
  end

  return num unless reduction

  reduce_num(num, cnt + 1)
end

max_magnitude = 0
lines.combination(2).to_a.each do |l|
  magnitude = magnitude(parse_number(sum_nums(l.first, l.last)))
  max_magnitude = magnitude if magnitude > max_magnitude
  magnitude = magnitude(parse_number(sum_nums(l.last, l.first)))
  max_magnitude = magnitude if magnitude > max_magnitude
end

puts max_magnitude
