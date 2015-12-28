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
          'generic object'    => Object.new,
          'hash'              => { 'test' => 'value'}
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

      # TODO: Do I need better names for these testcases?
      testcases = {
          'string not a number'     => { 'value' => 'not_a_number',     'expected' => 0 },
          'string integer'          => { 'value' => '1',                'expected' => 1 },
          'string negative integer' => { 'value' => '-1',               'expected' => -1 },
          'string float'            => { 'value' => '1.1',              'expected' => 1 },
          'float'                   => { 'value' => 1.1,                'expected' => 1 },
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
          'hash'   => { 'key' => 'value' },
          'object' => Object.new
      }
      testcases.each do |name,testcase|
        it "#{name} should raise error" do
          expect { value = @th.munge_integer(testcase) }.to raise_error
        end
      end

    end
  end

  describe "munge_embeddedinstance" do

    mof_types = {
        'param_bool1'  => { :type => 'bool'},
        'param_bool2'  => { :type => 'boolean'},

        'param_int8'   => { :type => 'int8'},
        'param_int16'  => { :type => 'int16'},
        'param_int32'  => { :type => 'int32'},
        'param_int64'  => { :type => 'int64'},
        'param_uint8'  => { :type => 'uint8'},
        'param_uint16' => { :type => 'uint16'},
        'param_uint32' => { :type => 'uint32'},
        'param_uint64' => { :type => 'uint64'},
        'param_sint8'  => { :type => 'sint8'},
        'param_sint16' => { :type => 'sint16'},
        'param_sint32' => { :type => 'sint32'},
        'param_sint64' => { :type => 'sint64'},

        'param_int8[]'   => { :type => 'int8[]'},
        'param_int16[]'  => { :type => 'int16[]'},
        'param_int32[]'  => { :type => 'int32[]'},
        'param_int64[]'  => { :type => 'int64[]'},
        'param_uint8[]'  => { :type => 'uint8[]'},
        'param_uint16[]' => { :type => 'uint16[]'},
        'param_uint32[]' => { :type => 'uint32[]'},
        'param_uint64[]' => { :type => 'uint64[]'},
        'param_sint8[]'  => { :type => 'sint8[]'},
        'param_sint16[]' => { :type => 'sint16[]'},
        'param_sint32[]' => { :type => 'sint32[]'},
        'param_sint64[]' => { :type => 'sint64[]'},
    }

    testcases = {
        'boolean, bool' => {
            'rubytype' => 'boolean',
            'value'    => { 'param_bool1' => 'true', 'param_bool2' => 'y' },
            'expected' => { 'param_bool1' => true, 'param_bool2' => true }
        },
        'int8, int16, int32, int64' => {
            'rubytype' => 'integer',
            'value'    => { 'param_int8' => '100', 'param_int16' => '100', 'param_int32' => '100', 'param_int64' => '100' },
            'expected' => { 'param_int8' => 100, 'param_int16' => 100, 'param_int32' => 100, 'param_int64' => 100 }
        },
        'uint8, uint16, uint32, uint64' => {
            'rubytype' => 'integer',
            'value'    => { 'param_uint8' => '100', 'param_uint16' => '100', 'param_uint32' => '100', 'param_uint64' => '100' },
            'expected' => { 'param_uint8' => 100, 'param_uint16' => 100, 'param_uint32' => 100, 'param_uint64' => 100 }
        },
        'sint8, sint16, sint32, sint64' => {
            'rubytype' => 'integer',
            'value'    => { 'param_sint8' => '100', 'param_sint16' => '100', 'param_sint32' => '100', 'param_sint64' => '100' },
            'expected' => { 'param_sint8' => 100, 'param_sint16' => 100, 'param_sint32' => 100, 'param_sint64' => 100 }
        },
        'int8[], int16[], int32[], int64[]' => {
            'rubytype' => 'integer[]',
            'value'    => { 'param_int8[]' => ['1','2'], 'param_int16[]' => ['1','2'], 'param_int32[]' => ['1','2'], 'param_int64[]' => ['1','2'] },
            'expected' => { 'param_int8[]' => [1,2], 'param_int16[]' => [1,2], 'param_int32[]' => [1,2], 'param_int64[]' => [1,2] }
        },
        'uint8[], uint16[], uint32[], uint6[]' => {
            'rubytype' => 'integer[]',
            'value'    => { 'param_uint8[]' => ['1','2'], 'param_uint16[]' => ['1','2'], 'param_uint32[]' => ['1','2'], 'param_uint64[]' => ['1','2'] },
            'expected' => { 'param_uint8[]' => [1,2], 'param_uint16[]' => [1,2], 'param_uint32[]' => [1,2], 'param_uint64[]' => [1,2] }
        },
        'sint8[], sint16[], sint32[], sint64[]' => {
            'rubytype' => 'integer[]',
            'value'    => { 'param_sint8[]' => ['1','2'], 'param_sint16[]' => ['1','2'], 'param_sint32[]' => ['1','2'], 'param_sint64[]' => ['1','2'] },
            'expected' => { 'param_sint8[]' => [1,2], 'param_sint16[]' => [1,2], 'param_sint32[]' => [1,2], 'param_sint64[]' => [1,2] }
        }
    }
    testcases.each do |typename,testcase|
      it "#{typename} mof types should return #{testcase['rubytype']} ruby type" do
        value = @th.munge_embeddedinstance(mof_types,testcase['value'])
        expect(value).to eq testcase['expected']
      end
    end

  end

end
