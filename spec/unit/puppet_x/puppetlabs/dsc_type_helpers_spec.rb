#! /usr/bin/env ruby
require 'spec_helper'
#require 'puppet/type'
require 'puppet_x/puppetlabs/dsc_type_helpers'

describe PuppetX::Dsc::TypeHelpers do
  before(:each) do
    @th = PuppetX::Dsc::TypeHelpers
  end

  describe "munge_boolean" do

    describe "when a true value is passed" do

      # TODO: Do I test the weird edge cases e.g. 'true;false' as a string?
      "t,T,yes,YES,true,TRUE,y,Y,1".split(",").each do |testcase|
        it "#{testcase} should return true" do
          value = @th.munge_boolean(testcase)
          expect(value).to eq true
        end
      end
    end

    describe "when a false value is passed" do

      "f,F,no,NO,n,N,false,FALSE,0".split(",").each do |testcase|
        it "#{testcase} should return false" do
          value = @th.munge_boolean(testcase)
          expect(value).to eq false
        end
      end

      it ".empty? should return false" do
        value = @th.munge_boolean([])
        expect(value).to eq false
      end
    end

    describe "when an invalid value is passed" do

      testcases = {
          'a non-empty array' => [1,2,3,4],
          'generic object' => Object.new,
          'hash' => { 'test' => 'value'}
      }
      testcases.each do |name,testcase|
        it "#{name} should error as an invalid value" do
          expect { value = @th.munge_boolean(testcase) }.to raise_error
        end
      end
    end
  end

  describe "munge_integer" do

    describe "when a valid value is passed" do

      testcases = {
          'string integer'          => { 'value' => '1', 'expected' => 1 },
          'string negative integer' => { 'value' => '-1', 'expected' => -1 },
          'string float'            => { 'value' => '1.1', 'expected' => 1 },
          'float'                   => { 'value' => 1.1, 'expected' => 1 },
          'string array'            => { 'value' => ['1','2','3','4'],  'expected' => [1,2,3,4] }
      }
      testcases.each do |name,testcase|
        it "#{name} should return an integer" do
          value = @th.munge_integer(testcase['value'])
          expect(value).to eq testcase['expected']
        end
      end

    end

    describe "when an invalid value is passed" do

      testcases = {
          'hash' => { 'key' => 'value' }
      }
      testcases.each do |name,testcase|
        it "#{name} should raise error" do
          expect { value = @th.munge_integer(testcase) }.to raise_error
        end
      end

    end
  end


end
