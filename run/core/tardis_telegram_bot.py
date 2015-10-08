#!/usr/bin/env python3

import sys
import re
import os
import json

from appdirs import AppDirs
import telegram
from passlib.apps import custom_app_context as password_manager

class TardisTelegramBot:
    def __init__(self, telegram_token=None, password_hash=None):
        self.data_dir = AppDirs('tardis').user_data_dir
        os.makedirs(self.data_dir, exist_ok=True)
        self.data_file = os.path.join(self.data_dir, 'telegram_bot.json')

        self.authenticated_chats = []
        self.spam_chats = []

        try:
            self.read_data()
        except OSError:
            pass    # first run

        if telegram_token:
            self.telegram_token = telegram_token
        if password_hash:
            self.password_hash = password_hash

        self.bot = telegram.Bot(token=self.telegram_token)

    def save_data(self):
        with open(self.data_file, 'w') as f:
            json.dump({
                'authenticated_chats': self.authenticated_chats,
                'spam_chats': self.spam_chats,
                'telegram_token': self.telegram_token,
                'password_hash': self.password_hash
            }, f)

    def read_data(self):
        with open(self.data_file, 'r') as f:
            data = json.load(f)
            self.authenticated_chats = data['authenticated_chats']
            self.spam_chats = data['spam_chats']
            self.telegram_token = data['telegram_token']
            self.password_hash = data['password_hash']

    def process_command(self, command, message):
        chat = message.chat_id
        command, *arguments = re.findall(
            r'(?:[^\s,"]|"(?:\\.|[^"])*")+',    # split on spaces, respecting ""
            command
        )

        if chat in self.authenticated_chats:
            if command == 'forgetme':
                if chat in self.authenticated_chats:
                    self.authenticated_chats.remove(chat)
                if chat in self.spam_chats:
                    self.spam_chats.remove(chat)
                self.reply(chat, "You're dead to me.")
            elif command == 'spam':
                if arguments and arguments[0] == 'on':
                    if chat not in self.spam_chats:
                        self.spam_chats.append(chat)
                    self.reply(chat, 'This chat will be spammed.')
                elif arguments and arguments[0] == 'off':
                    if chat in self.spam_chats:
                        self.spam_chats.remove(chat)
                    self.reply(chat, 'This chat will not be spammed.')
                else:
                    self.reply(chat, 'Please use /spam (on|off).')
            else:
                self.reply(chat, 'Unknown command: ' + command)
        else:
            if command == 'password':
                if arguments and password_manager.verify(arguments[0], self.password_hash):
                    self.reply(chat, 'Success! You can now use all commands.')
                    self.authenticated_chats.append(chat)
                else:
                    self.reply(chat, 'F U')
            else:
                self.reply(chat, 'Please say /password <password> to verify yourself.')

        self.save_data()

    def send_spam(self, text):
        for chat in self.spam_chats:
            self.bot.sendMessage(chat_id=chat, text=text)

    def reply(self, chat, text):
        self.bot.sendMessage(chat_id=chat, text=text)

    def process_message(self, message):
        text = message.text

        if text.startswith('/'):
            command = text[1:]
            self.process_command(command, message)

    def loop(self):
        last_update = 0
        while True:
            for update in self.bot.getUpdates(offset=last_update, timeout=200):
                if update.message:
                    self.process_message(update.message)
                last_update = update.update_id + 1

if __name__ == '__main__':
    if sys.argv[1] == 'listen':
        if len(sys.argv) > 3:
            TardisTelegramBot(sys.argv[2], sys.argv[3]).loop()
        else:
            TardisTelegramBot().loop()
    elif sys.argv[1] == 'spam':
        TardisTelegramBot().send_spam(sys.stdin.read())
