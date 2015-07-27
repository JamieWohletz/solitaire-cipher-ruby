class SolitaireCipher

    def convert(message)
      output = 'Sorry! I couldn\'t convert that.'
      if /\A[A-Z\s]*\Z/ =~ message
        output = decrypt(message)
      else
        output = encrypt(message)
      end
      output
    end

    def encrypt(message)
      msg = message.upcase.gsub(/[^A-Z]/,'').chars
      until msg.length % 5 == 0
        msg.push 'X'
      end
      msg = to_numbers(msg)

      kstream = to_numbers(generate_keystream(msg.length))
      sum_array = []
      0.upto(msg.length-1) do |i|
        num = msg[i] + kstream[i]
        sum_array.push(num > 26? num-26 : num)
      end
      to_letters(sum_array).join().scan(/.{5}/).join(' ')
    end

    def decrypt(message)
      msg = to_numbers(message.gsub(' ','').chars)
      kstream = to_numbers(generate_keystream(msg.length))
      differences = []
      0.upto(msg.length-1) do |i|
        differences << (msg[i] > kstream[i]? msg[i] : msg[i] + 26) - kstream[i]
      end
      to_letters(differences).join().scan(/.{5}/).join(' ')
    end

    def generate_keystream(length)
      i, keystream, deck = 0, [], (1..52).to_a + ['A','B']
      while i < length do
        letter = generate_keystream_letter(deck)
        if letter
          keystream << letter
          i += 1
        end
      end
      keystream
    end

    def generate_keystream_letter(deck)
      move_card_down('A', 1, deck)
      move_card_down('B', 2, deck)
      top_cards = deck.slice!(0, [deck.index('A'),deck.index('B')].min)
      bottom_cards = deck.slice!(([deck.index('A'),deck.index('B')].max+1)..deck.length)
      deck.push *(top_cards || [])
      deck.unshift *(bottom_cards || [])
      deck.insert(-2,*(deck.shift(value_of(deck.last))))
      key_card_val = value_of(deck[value_of(deck.first)])
      key_card_val == 53? nil : to_letter(key_card_val % 26)
    end

    private
    def move_card_down(card, number_of_spaces, deck)
      n, m, i = deck.length, number_of_spaces, deck.index(card)
      return if i.nil?
      deck.insert((i + m > n - 1) ? (i + m - (n - 1)) : (i + m), deck.delete_at(i))
    end

    def to_numbers(chars)
      chars.map do |c|
        c = to_number(c)
      end
    end

    def to_letters(numbers)
      numbers.map do |n|
        n = to_letter(n)
      end
    end

    def to_letter(number)
      (number+64).chr
    end

    def to_number(letter)
      letter.ord - 64
    end

    def value_of(card)
      ['A','B'].include?(card) ? 53 : card
    end
end

if ARGV[0]
  SolitaireCipher.new().convert(ARGV[0])
end
