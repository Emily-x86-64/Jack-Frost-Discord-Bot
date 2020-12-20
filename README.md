# Jack-Frost-Discord-Bot
A discord bot made in discordrb
# Prerequisites
Ruby >= 2.5 (You can install ruby [here](https://www.ruby-lang.org/en/downloads/ "Download Ruby Here"))
Bundler gem (If you dont have it you can use `gem install bundler` on some distros eg: ubuntu add `sudo` to that)
# How to make a bot app
go to the discord dev portal that can be found [here](https://discord.com/developers/applications "The Discord Dev Portal")
make an app then make a bot
you will have a bot *token* and *client ID* (this is important)
# Installing the bot
first use `git clone https://github.com/AkronOhioScott/Jack-Frost-Discord-Bot.git` or download the .zip on the github
then `cd Jack-Frost-Discord-bot`
now `cd data`
then `ls`
you should see a file named `config.yaml`
now use `nano` or whatever editor you want to use to edit the file eg: `nano config.yaml` or `vim config.yaml`
the yaml file has 7 fields
the yaml file also has comments that will tell you what goes into what part
so fill that out
when done exit out of your editor then `cd ..`
then run `bundle install`
now run `bundle exec ruby main.rb`
and the bot should be online and you should see a message in the console saying the bot is online

