#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require './bundle/bundler/setup'
require 'alfred'
require 'active_support/all'

def gen_timestamp(t = DateTime.current)
  {
    millisecond: (t.to_f * 1000).to_i.to_s,
    second: (t.to_i).to_s
  }
end

def parse_time_stamp(ts)
  ts = ts[0..9] if ts.length === 13
  Time.at(ts.to_i)
end

def date_formate(time)
  time.strftime('%Y-%m-%d %T').to_s
end

$adv_hash = {'y' => :years, 'm' => :months, 'd' => :days, 'h' => :hours, 'M' => :minutes, 's' => :seconds}
def set_offset(offset_str, time = DateTime.current)
  time = DateTime.parse(parse_time_stamp(time.to_s).to_s) if time.class == Fixnum

  offset_array = offset_str.scan(/(\d+)([sMhdmy])/).flatten.map.with_index do |x, idx|
    idx.odd? ? $adv_hash[x] : x.to_i
  end
  offset_array = offset_array.reverse
  time = time.advance(Hash[*offset_array])

  time
end

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback

  if ARGV.length == 0
    now = gen_timestamp
    fb.add_item(title: now[:second], subtitle: '10位秒级别时间戳')
    fb.add_item(title: now[:millisecond], subtitle: '13位毫秒级别时间戳')
  end

  if ARGV[0] && (ARGV[0].length === 10 || ARGV[0].length === 13)
    arg = ARGV[0];
    time = date_formate(parse_time_stamp(arg.to_s))
    fb.add_item(title: time, subtitle: '解析时间戳')
  end

  if ARGV.length == 2 && ARGV[0] == '+'
    time = set_offset(/((\d+)[sMhdmy])+/.match(ARGV[1]).to_s)
    date_formated = date_formate(time)
    time = gen_timestamp(time)
    fb.add_item(title: time[:second], subtitle: date_formated)
  end

  if ARGV.length == 3 && ARGV[1] == '+'
    time = set_offset(/((\d+)[sMhdmy])+/.match(ARGV[2]).to_s, ARGV[0].to_i)
    date_formated = date_formate(time)
    time = gen_timestamp(time)
    fb.add_item(title: time[:second], subtitle: date_formated)
  end

  puts fb.to_alfred
end
