require_relative "solitaire_cipher"
require 'test/unit'

class TestSolitaireCipher < Test::Unit::TestCase

  def setup
    @cipher = SolitaireCipher.new
  end

  def teardown
    @cipher = nil
  end

  def test_generate_keystream_letter
    deck = (1..52).to_a + ['A','B']
    assert_equal(
      'D',
      @cipher.generate_keystream_letter(deck)
    )
    assert_equal(
      'W',
      @cipher.generate_keystream_letter(deck)
    )
    assert_equal(
      'J',
      @cipher.generate_keystream_letter(deck)
    )
    assert_equal(
      nil,
      @cipher.generate_keystream_letter(deck)
    )
  end

  def test_generate_keystream
    assert_equal(
      %w(D W J X H),
      @cipher.generate_keystream(5)
    )
    assert_equal(
      %w(D W J X H Y R F D G),
      @cipher.generate_keystream(10)
    )
    assert_equal(
      %w(D W J X H Y R F D G T M S H P U U R X J),
      @cipher.generate_keystream(20)
    )
  end

  def test_convert
    assert_equal(
      'CODEI NRUBY LIVEL ONGER',
      @cipher.convert('GLNCQ MJAFF FVOMB JIYCB')
    )
    assert_equal(
      'GLNCQ MJAFF FVOMB JIYCB',
      @cipher.convert('Code in Ruby, live longer!')
    )
  end

  def test_encrypt
    assert_equal(
      'GLNCQ MJAFF FVOMB JIYCB',
      @cipher.encrypt('Code in Ruby, live longer!')
    )
    assert_equal(
      'LBVJW VGXPK',
      @cipher.encrypt('Hello world!')
    )
  end

  def test_decrypt
    assert_equal(
      'CODEI NRUBY LIVEL ONGER',
      @cipher.decrypt('GLNCQ MJAFF FVOMB JIYCB')
    )
    assert_equal(
      'HELLO WORLD',
      @cipher.decrypt('LBVJW VGXPK')
    )
  end
end
