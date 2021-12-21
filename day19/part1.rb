#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require 'trilateration'

file_path = File.expand_path('input.txt', __dir__)

scanners = File.read(file_path).split("\n\n").map do |s|
  s.split("\n").drop(1).map do |b|
    { 'x' => b.split(',')[0].to_i, 'y' => b.split(',')[1].to_i, 'z' => b.split(',')[2].to_i, 'scanner' => false }
  end
end

def rotate(px, py, ang)
  rad = ang * Math::PI / 180

  x = (Math.cos(rad) * px) - (Math.sin(rad) * py)
  y = (Math.cos(rad) * py) + (Math.sin(rad) * px)

  [x.round, y.round]
end

def rotations(scanner)
  scanner_2 = []
  scanner.each do |s|
    new_s = {}
    new_s['x'] = 0 - s['x']
    new_s['y'] = 0 - s['z']
    new_s['z'] = 0 - s['y']

    scanner_2.push(new_s)
  end

  scanner_3 = []
  scanner.each do |s|
    new_s = {}
    new_s['x'] = 0 - s['z']
    new_s['y'] = s['y']
    new_s['z'] = s['x']

    scanner_3.push(new_s)
  end

  scanner_4 = []
  scanner.each do |s|
    new_s = {}
    new_s['x'] = s['z']
    new_s['y'] = 0 - s['y']
    new_s['z'] = s['x']

    scanner_4.push(new_s)
  end

  scanner_5 = []
  scanner.each do |s|
    new_s = {}
    new_s['x'] = 0 - s['y']
    new_s['y'] = s['z']
    new_s['z'] = 0 - s['x']

    scanner_5.push(new_s)
  end

  scanner_6 = []
  scanner.each do |s|
    new_s = {}
    new_s['x'] = s['x']
    new_s['y'] = 0 - s['y']
    new_s['z'] = 0 - s['z']

    scanner_6.push(new_s)
  end

  scanners = [scanner, scanner_2, scanner_3, scanner_4, scanner_5, scanner_6]

  rots = []
  [0, 90, 180, 270].each do |ang|
    [%w[x y], %w[y z], %w[x z]].each do |o|
      scanners.each do |s|
        rotation = []
        s.each do |b|
          new_coor = rotate(b[o[0]], b[o[1]], ang)
          new_point = if !o.include?('z')
                        {
                          'x' => new_coor[0],
                          'y' => new_coor[1],
                          'z' => b['z']
                        }
                      elsif !o.include?('x')
                        {
                          'x' => b['x'],
                          'y' => new_coor[0],
                          'z' => new_coor[1]
                        }
                      else
                        {
                          'x' => new_coor[0],
                          'y' => b['y'],
                          'z' => new_coor[1]
                        }
                      end

          rotation.push(new_point)
        end
        rots.push(rotation)
      end
    end
  end

  rots.uniq
end

def overlapp(scanner1, scanner2, _full)
  rots = rotations(scanner2)

  pp rots
  not_found = []

  found = false
  rots.each do |r|
    scanner1.each do |s1|
      m_found = 0
      not_found = []
      r.each do |s2|
        if s1 == s2
          m_found += 1
        else
          not_found.push(s2)
        end
      end

      found = true if m_found >= 12
    end
    break if found
  end

  return not_founds if found

  []
end

def precompute(x1, x2, x3, y1, y2, y3, z1, z2, z3); end

def norm(a)
  Math.sqrt(a['x']**2 + a['y']**2 + a['z']**2)
end

def dot(a, b)
  a['x'] * b['x'] + a['y'] * b['y'] + a['z'] * b['z']
end

def vector_subtract(a, b)
  {
    'x' => a['x'] - b['x'],
    'y' => a['y'] - b['y'],
    'z' => a['z'] - b['z']
  }
end

def vector_add(a, b)
  {
    'x' => a['x'] + b['x'],
    'y' => a['y'] + b['y'],
    'z' => a['z'] + b['z']
  }
end

def vector_divide(a, b)
  {
    'x' => a['x'] / b,
    'y' => a['y'] / b,
    'z' => a['z'] / b
  }
end

def vector_multiply(a, b)
  {
    'x' => a['x'].to_f * b,
    'y' => a['y'].to_f * b,
    'z' => a['z'].to_f * b
  }
end

def vector_cross(a, b)
  {
    'x' => a['y'] * b['z'] - a['z'] * b['y'],
    'y' => a['z'] * b['x'] - a['x'] * b['z'],
    'z' => a['x'] * b['y'] - a['y'] * b['x']
  }
end

def trianulate(p1, p2, p3, p4, scanner)
  scanner = false if scanner.nil?
  z = 0
  ex = vector_divide(vector_subtract(p2, p1), norm(vector_subtract(p2, p1)))

  i = dot(ex, vector_subtract(p3, p1))
  a = vector_subtract(vector_subtract(p3, p1), vector_multiply(ex, i))
  ey = vector_divide(a, norm(a))
  ez = vector_cross(ex, ey)
  d = norm(vector_subtract(p2, p1))
  j = dot(ey, vector_subtract(p3, p1))

  x = (p1['r']**2 - p2['r']**2 + d**2) / (2 * d)
  y = (p1['r']**2 - p3['r']**2 + i**2 + j**2) / (2 * j) - (i / j) * x

  b = p1['r']**2 - x**2 - y**2

  z = Math.sqrt(b) if b.positive?
  a = vector_add(p1, vector_add(vector_multiply(ex, x), vector_multiply(ey, y)))

  p4a = vector_add(a, vector_multiply(ez, z))
  p4b = vector_subtract(a, vector_multiply(ez, z))

  if z.zero?
    {
      'x' => a['x'].round.to_i,
      'y' => a['y'].round.to_i,
      'z' => a['z'].round.to_i,
      'scanner' => scanner
    }
  else
    da = Math.sqrt((p4a['x'] - p4['x'])**2 + (p4a['y'] - p4['y'])**2 + (p4a['z'] - p4['z'])**2)
    db = Math.sqrt((p4b['x'] - p4['x'])**2 + (p4b['y'] - p4['y'])**2 + (p4b['z'] - p4['z'])**2)

    f = p4a

    f = p4b if (da - p4['r']).abs > (db - p4['r']).abs

    {
      'x' => f['x'].round.to_i,
      'y' => f['y'].round.to_i,
      'z' => f['z'].round.to_i,
      'scanner' => scanner
    }
  end
end

def distance_overlap(scanner1, scanner2, full)
  points1 = []
  points2 = []

  pairs1 = []
  pairs2 = []

  # scanner1.each do |s1|
  #  scanner2.each do |s2|
  #    if s1[2] == s2[2]

  #     points1.add(s1[0].clone)
  #      points1.add(s1[1].clone)

  #      points2.add(s2[0].clone)
  #      points2.add(s2[1].clone)
  #    end
  #  end
  # end

  scanner1.each do |s1|
    scanner2.each do |s2|
      if s1[2] == s2[2]
        pairs1.push([s1[0].clone, s1[1].clone])
        pairs2.push([s2[0].clone, s2[1].clone])
      end
    end
  end

  while pairs1.size.positive?
    chk = pairs1.first
    a = pairs1.first.first
    b = pairs1.first.last

    c = pairs2.first.first
    d = pairs2.first.last

    founda = points1.include?(a)
    foundb = points1.include?(b)

    (1..pairs1.size - 1).each do |i|
      p = pairs1[i]
      p2 = pairs2[i]
      if (founda == false) && ((p.first == a) || (p.last == a))

        if p2.first == c
          points1.push(a)
          points2.push(c)
          founda = true
        elsif p2.first == d
          points1.push(a)
          points2.push(d)
          founda = true
        elsif p2.last == c
          points1.push(a)
          points2.push(c)
          founda = true
        elsif p2.last == d
          points1.push(a)
          points2.push(d)
          founda = true
        end
      end

      if (foundb == false) && ((p.first == b) || (p.last == b))
        if p2.first == c
          points2.push(c)
          points1.push(b)
          foundb = true
        elsif p2.first == d
          points2.push(d)
          points1.push(b)
          foundb = true
        elsif p2.last == c
          points2.push(c)
          points1.push(b)
          foundb = true
        elsif p2.last == d
          points2.push(d)
          points1.push(b)
          foundb = true
        end
      end

      break if founda && foundb
    end

    pairs1 = pairs1.drop(1)
    pairs2 = pairs2.drop(1)

  end

  if points1.size >= 12
    four = points2.drop(5).take(4).dup
    new_four = points1.drop(5).take(4).dup
    unidentified = (full.clone - points2.to_a)

    # pp points1
    # puts
    unidentified = unidentified.map do |a|
      dist = four.map do |b|
        Math.sqrt((b['x'] - a['x'])**2 + (b['y'] - a['y'])**2 + (b['z'] - a['z'])**2)
      end

      (0..3).each do |n|
        new_four[n]['r'] = dist[n]
      end

      # puts a
      trianulate(new_four[0], new_four[1], new_four[2], new_four[3], a['scanner'])
    end

    return unidentified
  end

  nil
end

def combine(s)
  combos = s.combination(2)

  combos.map do |c|
    a = c[0]
    b = c[1]

    d = Math.sqrt((b['x'] - a['x'])**2 + (b['y'] - a['y'])**2 + (b['z'] - a['z'])**2).round(3)

    [a, b, d]
  end
end

# scanners = scanners.take(2)
scanners_cnt = scanners.size

cnt = 0
loop do
  new_scanners = []
  skip = []
  found = false
  cnt += 1

  combined = scanners[0]

  (1..scanners.size - 1).each do |s|
    if found
      new_scanners.push(scanners[s])
      next
    end
    c1 = combine(scanners[0])
    c2 = combine(scanners[s])
    o = distance_overlap(c1, c2, scanners[s].dup)

    if !o.nil?
      new_scanners.unshift(scanners[0] + o)
      found = true
    else
      new_scanners.push(scanners[s])
    end
  end

  scanners = new_scanners
  found = false
  # puts scanners.first.size

  break if scanners.size == 1
end

# pp scanners_cnt
# pp scanners

beacons = scanners.first

puts beacons.size
# puts

# output = File.read(File.expand_path('output.txt', __dir__)).split("\n").sort

# puts output
