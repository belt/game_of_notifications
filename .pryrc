Bond.start if defined?(Bond)

def stack
  ap caller.reject{|ln| ln.match?(/\bgems\b/)}
end

if defined?(PryByebug)
  Pry.commands.alias_command 'l', 'whereami'
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'q', 'quit'

  # Hit Enter to repeat last command
  #Pry::Commands.command /^$/, "repeat last command" do
  #  _pry_.run_command Pry.history.to_a.last
  #end
end

Pry.config.ls.heading_color = :magenta
Pry.config.ls.public_method_color = :green
Pry.config.ls.protected_method_color = :yellow
Pry.config.ls.private_method_color = :bright_black
Pry.config.ls.class_constant_color = :bright_blue
Pry.config.ls.instance_var_color = :bright_blue

Pry.config.theme = 'pry-modern-256' unless Pry.config.theme || (rails_env && defined?(PryTheme))

# Interactive: _pry_.config.pager = false
Pry.config.pager = false
