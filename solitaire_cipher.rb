class Encrypter
  def initialize(keystream)
    @keystream = keystream
  end
  
  def sanitize(s)
    s = s.upcase.gsub(/[^A-Z]/, "")
    out = ""
    s = s + "X" * (5-s.size%5)
    (s.size / 5).times {|i| out << s[5*i, i] << " "}
    return out
  end 

  def mod(c)
    return c - 26 if c > 26
    return c + 26 if c < 1
    return c
  end

  def process(s, &combiner)
    s = sanitize(s)
    out = ""
    s.each_byte {|c|
      if c >= ?A and c <= ?Z
        key = @keystream.get
        res = combiner.call(c, key[0])
        out << res.chr
      else
        out << c.chr
      end
    }
    return out
  end

  def encrypt(s)
    return process(s) {|c, key| 64 + mod(c + key - 120)}
  end

  def dencrypt(s)
    return process(s) {|c, key| 64 + mod(c - key)}
  end
  
end
