# From http://rspec.info

# bowling.rb
class Bowling
  def hit(pins)
  end

  def score
    0
  end
end

# bowling_spec.rb
# require 'bowling'

describe Bowling, "#score" do
  it "returns 0 for all gutter game" do
    bowling = Bowling.new
    20.times { bowling.hit(0) }
    bowling.score.should eq(0)
  end
end
