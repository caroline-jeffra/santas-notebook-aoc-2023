workflows, parts = File.open('input')
                       .read
                       .split("\n\n")
                       .map { |s| s.split("\n") }

ACCEPTED = []

def A(part)
  ACCEPTED << part
end

def R(part); end

workflows.map! do |workflow|
  name, rules = workflow.match(/(\w+){(.*)}/).captures
  rules = rules.gsub(':', ' ? ')
               .gsub(',', ' : ')
               .gsub(/([a-z]{2,})/, '\1(args)')
               .gsub(/(A|R)/, '\1(args)')

  define_method(name.to_sym) do |args|
    x, m, a, s = args
    eval rules
  end
end

parts.map! { |part| part.scan(/\d+/).map(&:to_i) }
parts.each { |part| send(:in, part) }

p ACCEPTED.map(&:sum).sum
