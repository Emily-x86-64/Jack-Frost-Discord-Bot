# frozen_string_literal: true

# Embed visualizer: https://leovoel.github.io/embed-visualizer/

require 'discordrb'
require 'httparty'
require 'duck_duck_go'
require 'json'
require 'yaml'

CONFIG = OpenStruct.new YAML.load_file 'data/config.yaml'

bot = Discordrb::Commands::CommandBot.new token: CONFIG.token, prefix: CONFIG.prefix, command_doesnt_exist_message: CONFIG.command_not_found_message, no_permission_message: CONFIG.no_premission_message, advanced_functionality: true, client_id: CONFIG.client_id

bot.mention { |event| event.respond "My prefix for this guild is #{CONFIG.prefix}\nFor help use #{CONFIG.prefix}help" }
bot.ready do |event|
  event.bot.online
  event.bot.playing = CONFIG.game
  puts 'The bot is online!'
end
bot.server_create do |event|
  event.server.default_channel.send_embed do |embed|
    embed.title = 'Thanks for adding me!'
    embed.colour = rand(0..0xfffff)
    embed.description = '''Thanks for adding *Jack Frost Discord Bot* to your server! This bot was made in part by
    <@865791552864649297> and <@83283213010599936>. For help you can use the *==help* command to get started with some
    of the commands! Have fun!'''
    embed.timestamp = Time.now
  end
  puts "Bot was added to #{event.server.name}."
end
bot.server_delete { puts 'Bot was removed from a server.' }
bot.command(:ping, aliases: %i[pong], description: 'Sends the bots ping time') do |event|
  event.channel.send_embed do |embed|
    embed.title = ':ping_pong: Ping! :ping_pong:'
    embed.colour = rand(0..0xfffff)
    embed.description = "Pong! Time taken: #{Time.now - event.timestamp} seconds."
    embed.timestamp = Time.now
  end
end
bot.command :clinc do |event|
  event.channel.send_embed do |embed|
    embed.title = 'Clinc'
    embed.colour = rand(0..0xfffff)
    embed.description = 'This is the verbal abuse room, You heap of parrot droppings!!'
    embed.timestamp = Time.now
  end
end
bot.command(:invite, description: 'Will give a invite to the support server and a link to add the bot to a server') do |event|
  event.channel.send_embed do |embed|
    embed.title = 'Invite me to your server!'
    embed.colour = rand(0..0xfffff)
    embed.url = bot.invite_url(permission_bits: 2_147_483_647)
    embed.description = 'For help with the bot you can join [this server](https://discord.gg/N4YKYYPfcC)'
    embed.timestamp = Time.now
  end
end
bot.command(:shutdown, help_available: false) do |event|
  break unless event.user.id == CONFIG.owner

  bot.send_message(event.channel.id, 'Bot is shutting down')
  exit
end
bot.command(:eval, help_available: false, usage: "==eval ```rb\ncode\n```") do |event, *code|
  break unless event.user.id == CONFIG.owner

  begin
    eval code.join(' ')
  rescue
    'An error occurred, please check the console.'
  end
end
bot.command(:avatar, aliases: %i[pfp profile], arg_types: [Discordrb::User]) do |event, user|
  event.channel.send_embed do |embed|
    embed.title = 'Avatar!'
    embed.colour = rand(0..0xfffff)
    embed.description = "Avatar of #{user.mention}:"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: user.avatar_url)
    embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Looking fresh!!')
    embed.timestamp = Time.now
  end
end
bot.command(:embed_test, aliases: %i[embed], help_available: false) do |event|
  break unless event.user.id == CONFIG.owner

  event.channel.send_embed("this `supports` __a__ **subset** *of* ~~markdown~~ 😃 ```js\nfunction foo(bar) {\n  console.log(bar);\n}\n\nfoo(1);```") do |embed|
    embed.title = 'title ~~(did you know you can have markdown here too?)~~'
    embed.colour = rand(0..0xfffff)
    embed.url = 'https://discordapp.com'
    embed.description = "this supports [named links](https://discordapp.com) on top of the previously shown subset of markdown. ```\nyes, even code blocks```"
    embed.timestamp = Time.now
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: 'https://cdn.discordapp.com/embed/avatars/0.png')
    embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: 'https://cdn.discordapp.com/embed/avatars/0.png')
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'author name', url: 'https://discordapp.com', icon_url: 'https://cdn.discordapp.com/embed/avatars/0.png')
    embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'footer text', icon_url: 'https://cdn.discordapp.com/embed/avatars/0.png')
    embed.add_field(name: '🤔', value: 'some of these properties have certain limits...')
    embed.add_field(name: '😱', value: 'try exceeding some of them!')
    embed.add_field(name: '🙄', value: 'an informative error should show up, and this view will remain as-is until all issues are fixed')
    embed.add_field(name: '<:ruby:232899886419410945>', value: 'these last two', inline: true)
    embed.add_field(name: ':transgender_flag:', value: 'are inline fields', inline: true)
  end
end
bot.command(:eight_ball, aliases: %i[8b 8ball], description: 'A command that works like an 8-Ball', usage: '8ball question') do |event, *question|
  responses = ['It is decidedly so.',
               'Without a doubt.',
               'Yes - definitely.',
               'You may rely on it.',
               'As I see it, yes.',
               'Most likely.',
               'Outlook good.',
               'Yes.',
               'Signs point to yes.',
               'Reply hazy, try again.',
               'Ask again later.',
               'Better not tell you now.',
               'Cannot predict now.',
               'Concentrate and ask again.',
               'Dont count on it.',
               'My reply is no.',
               'My sources say no.',
               'Outlook not so good.',
               'Very doubtful.']
  event.channel.send_embed do |embed|
    embed.title = '8-Ball!'
    embed.colour = rand(0..0xfffff)
    embed.description = "Your question is: #{question.join(' ')}\nAnd your answer is: #{responses.sample}"
    embed.timestamp = Time.now
  end
end
bot.command(:server_list, help_available: false) { |_event| bot.servers.to_s }
bot.command(:server, description: 'A command that tells the server name to the user') { |event| event.respond "This servers name is: #{event.server.name}" }
bot.command(:owner, description: 'A command that will echo the owner of the server') { |event| event.respond "The owner of this server is: #{event.server.owner.mention}" }
bot.command(:members, description: 'A command that will echo how many members a server has') { |event| event.respond "This server has #{event.server.member_count} members" }
bot.command(:servers) { |event| event.respond "I am in #{event.bot.servers.size} servers" }
bot.command(:random, description: 'Will pick a set of random numbers that the user defines', usage: 'random min max') do |event, min, max|
  event.channel.send_embed do |embed|
    embed.title = 'Random!'
    embed.colour = rand(0..0xfffff)
    embed.description = "Hmm... That's a tough one... But I would have to go with... #{rand(min.to_i..max.to_i)}"
    embed.timestamp = Time.now
  end
end
bot.command(:region, description: 'A command that will echo the region of a server') { |event| event.respond "The region of this server is: #{event.server.region}" }
bot.command(:roll, description: 'rolls some dice', usage: 'roll NdS', min_args: 1) do |_event, dnd_roll|
  number, sides = dnd_roll.split('d')
  next 'Invalid syntax.. try: `roll 2d10`' unless number && sides

  begin
    number = Integer(number, 10)
    sides  = Integer(sides, 10)
  rescue ArgumentError
    next 'You must pass two *numbers*.. try: `roll 2d10`'
  end
  rolls = Array.new(number) { rand(1..sides) }
  sum = rolls.reduce(:+)
  "You rolled: #{rolls} , Your total is: #{sum}"
end
bot.command :connect do |event|
  channel = event.user.voice_channel
  next 'You need to be in a voic channel for this command to work' unless channel

  bot.voice_connect(channel)
  event.respond "Connected to: #{channel.name}"
end
bot.command :time do |event|
  message = event.respond "The current time is: #{Time.now.strftime('%F %T %Z')}"
  message.react "\u274c"
  bot.add_await(:"delete_#{message.id}", Discordrb::Events::ReactionAddEvent, emoji: "\u274c") do |reaction_event|
    next true unless reaction_event.message.id == message.id

    message.delete
  end
  nil
end
bot.command(:iscool, arg_types: [Discordrb::User]) do |event, user|
  answers = %w[Yes No]
  if answers.sample == 'Yes'
    event.channel.send_embed do |embed|
      embed.title = 'Cool'
      embed.colour = rand(0..0xfffff)
      embed.description = "Yes #{user.mention} is cool"
      embed.timestamp = Time.now
    end
  else
    event.channel.send_embed do |embed|
      embed.title = 'Cool'
      embed.colour = rand(0..0xfffff)
      embed.description = "No #{user.mention} is not cool"
      embed.timestamp = Time.now
    end
  end
end
bot.command :joke do |event|
  sfwjoke = HTTParty.get('https://sv443.net/jokeapi/v2/joke/Any?blacklistFlags=nsfw,religious,political,racist,sexist&format=txt')
  nsfwjoke = HTTParty.get('https://sv443.net/jokeapi/v2/joke/Any?format=txt')
  if event.channel.nsfw? || event.channel.pm?
    event.channel.send_embed do |embed|
      embed.title = 'Joke!'
      embed.colour = rand(0..0xfffff)
      embed.description = nsfwjoke.to_s
      embed.timestamp = Time.now
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Because this is a NSFW channel / PM channel this joke is a NSFW joke')
    end
  else
    event.channel.send_embed do |embed|
      embed.title = 'Joke!'
      embed.colour = rand(0..0xfffff)
      embed.description = sfwjoke.to_s
      embed.timestamp = Time.now
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Because this is a SFW channel this joke is a SFW joke')
    end
  end
end
bot.command(:ban, required_permissions: [:ban_members], arg_types: [Discordrb::User]) do |event, user, *reason|
  event.server.ban(user, reason.join(' '))
  event.respond "I have banned #{user.mention}."
end
bot.command(:kick, required_permissions: [:kick_members], arg_types: [Discordrb::User]) do |event, user, *reason|
  event.server.kick(user, reason.join(' '))
  event.respond "I have kicked #{user.mention}."
end
bot.command :italic do |_event, *args|
  "*#{args.join(' ')}*"
end
bot.command :bold do |_event, *args|
  "**#{args.join(' ')}**"
end
bot.command(:prune, required_permissions: [:manage_messages]) do |event, num_of_messages|
  event.channel.prune(num_of_messages.to_i + 1, true, "Deleted By Jack Frost Bot on #{Time.now}")
  message = event.respond "I have deleted #{num_of_messages} messages!"
  message.delete
end
bot.command(:echo, aliases: %i[print]) do |_event, *words|
  words.join(' ')
end
bot.command(:userinfo, arg_types: [Discordrb::User]) do |event, user|
  event.channel.send_embed do |embed|
    embed.title = "Info for: #{user.mention}"
    embed.colour = rand(0..0xfffff)
    embed.description = "Username: #{user.member.display_name}\nUser ID: #{user.id}\nAccount Creation Date: #{user.creation_time}"
    embed.timestamp = Time.now
  end
end

at_exit { bot.stop }
bot.run
