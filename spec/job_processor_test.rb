# frozen_string_literal: true
require 'minitest/autorun'
require './job_processor.rb'

describe Mediators::JobProcessor do
  describe 'simple example results' do
    before(:all) do
      @content = (File.readlines 'simple_example.txt')
      @result = Mediators::JobProcessor.run(@content.join)
    end

    it 'are the correct length' do
      assert !@result.nil?
      assert_equal @content.length, @result.length
    end

    it 'have the correct ordering' do
      assert_operator @result.index('c'), :<, @result.index('b')
      assert_operator @result.index('f'), :<, @result.index('c')
      assert_operator @result.index('a'), :<, @result.index('d')
      assert_operator @result.index('b'), :<, @result.index('e')
    end
  end

  describe 'complex example results' do
    before(:all) do
      @content = (File.readlines 'complex_example.txt')
      @result = Mediators::JobProcessor.run(@content.join)
    end

    it 'are the correct length' do
      assert !@result.nil?
      assert_equal @content.length, @result.length
    end

    it 'have the correct ordering' do
      assert_operator @result.index('g'), :<, @result.index('a')
      assert_operator @result.index('c'), :<, @result.index('b')
      assert_operator @result.index('f'), :<, @result.index('c')
      assert_operator @result.index('a'), :<, @result.index('d')
      assert_operator @result.index('b'), :<, @result.index('e')
      assert_operator @result.index('a'), :<, @result.index('f')
      assert_operator @result.index('f'), :<, @result.index('h')
    end
  end

  describe 'same dependency example results' do
    before(:all) do
      @content = (File.readlines 'same_dependency.txt')
      @result = Mediators::JobProcessor.run(@content.join)
    end

    it 'are the correct length' do
      assert !@result.nil?
      assert_equal @content.length, @result.length
    end

    it 'have the correct ordering' do
      assert_operator @result.index('c'), :<, @result.index('b')
      assert_operator @result.index('f'), :<, @result.index('c')
      assert_operator @result.index('f'), :<, @result.index('d')
      assert_operator @result.index('b'), :<, @result.index('e')
    end
  end

  describe 'circular dependency example results' do
    before(:all) do
      @content = (File.readlines 'circular_dependency.txt')
      @result = Mediators::JobProcessor.run(@content.join)
    end

    it 'returns false' do
      assert !@result
    end
  end

  describe 'self dependency example results' do
    before(:all) do
      @content = (File.readlines 'self_dependency.txt')
      @result = Mediators::JobProcessor.run(@content.join)
    end

    it 'returns false' do
      assert !@result
    end
  end
end
