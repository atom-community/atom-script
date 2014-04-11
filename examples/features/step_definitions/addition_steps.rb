Given(/^I have entered (\d+) into the calculator$/) do |arg1|
  @calculator ||= []
  @calculator << arg1.to_i
end

When(/^I press add$/) do
  @result = @calculator.inject(:+)
end

Then(/^the result should be (\d+) on the screen$/) do |arg1|
  fail "expected: #{arg1}\ngot: #{@result}" unless @result.eql?(arg1.to_i)
end
