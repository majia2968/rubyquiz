class Array
  def random_member(&block)
    return select(&block).random_member if block
    return self[rand(size)]
  end

  def count(&block)
    return select(&block).size 
  end
end

class String
  def clean_here_string
    indent = self[/^\s*/]
    return self.gsub(/^#{indent}/, "")
  end
end

class Person
  attr_reader :first, :family, :mail
  def initialize(first, family, mail)
    @first, @family, @mail = first, family, mail
  end
  def to_s() "#{first} #{family} <#{first}> "
end

class AssignSanta
  def initialize(persons)
    @persons = persons.dup
    @santas = persons.dup
    @families = persons.collect {|p| p.family}.uniq
    @families.each { |f|
      if santa_surplus(f) < 0
        raise "No santa configuration possible"
      }
    end

    # Key function -- extra santas available for a family
    #        if this is negative -- no santa configuration is possible
    #        if this is 0 -- next santa must be assigned to this family
    def santa_surplus(family)
      return @santas.count {|s| s.family != family} -
        @persons.count {|p| p.family == family}
    end

    def call
      while @persons.size() > 0
        family = @families.detect { |f|
          santa_surplus(f)==0 and
          @persons.count{|p| p.family == f} > 0
        }
        person = @persons.random_member { |p|
          family == nil || p.family == family
        }
        santa = @santas.random_member{ |s|
          s.family != person.family
        }
        yield(person, santa)
        @persons.delete(person)
        @santas.delete(santa)
      end
    end
end
