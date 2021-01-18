# Jack-Frost-Discord-Bot

A discord bot made in discordrb

## Prerequisites

Ruby >= 2.5 (You can install ruby [here](https://www.ruby-lang.org/en/downloads/ "Download Ruby Here"))
Bundler gem (If you dont have it you can use `gem install bundler` on some distros eg: ubuntu add `sudo` to that)

## How to make a bot app

go to the discord dev portal that can be found [here](https://discord.com/developers/applications "The Discord Dev Portal")
make an app then make a bot
you will have a bot *token* and *client ID* (this is important)

## Installing the bot (linux)

Clone the repository

```sh
git clone https://github.com/AkronOhioScott/Jack-Frost-Discord-Bot.git
cd Jack-Frost-Discord-bot
cd data
ls
```

Here you should see a file named `config.yaml`

now use `nano` or whatever editor you want to use to edit the file eg: `nano config.yaml` or `vim config.yaml`
<br>the yaml file has 7 fields
<br>the yaml file also has comments that will tell you what goes into what part
so fill that out
<br> 
<br>when done exit out of your editor then

```sh
cd ..
bundle install
bundle exec ruby main.rb
```

and the bot should be online and you should see a message in the console saying the bot is online!

## Installing the bot (windows)

download the zip on the github and extract it <br>
then use notepad or a text editor to edit the `config.yaml` file<br>
when done open command prompt

```cmd
cd Jack-Frost-Discord-bot
bundle install
bundle exec ruby main.rb
```

and you're done!
