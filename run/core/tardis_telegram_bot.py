#!/usr/bin/env python3

import sys
import logging
import re

import telegram
from passlib.apps import custom_app_context as password_manager

class TardisTelegramBot:
    def __init__(self, telegram_token, password):
        self.bot = telegram.Bot(token=telegram_token)
        self.password = password
        self.logger = logging.getLogger('tardis_telegram_bot')

        self.authenticated_chats = []
        self.spam_chats = []

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
                if arguments and password_manager.verify(arguments[0], self.password):
                    self.reply(chat, 'Success! You can now use all commands.')
                    self.authenticated_chats.append(chat)
                else:
                    self.reply(chat, 'F U')
            else:
                self.reply(chat, 'Please say /password <password> to verify yourself.')

    def reply(self, chat, text):
        self.bot.sendMessage(chat_id=chat, text=text)

    def process_message(self, message):
        text = message.text

        if text.startswith('/'):
            command = text[1:]
            self.logger.info('received command: %s', command)
            self.process_command(command, message)
        else:
            self.logger.info('received non-command message: %s', text)

    def loop(self):
        last_update = 0
        while True:
            for update in self.bot.getUpdates(offset=last_update, timeout=30):
                if update.message:
                    self.logger.info(
                        'received update with message: %s', str(update)
                    )
                    self.process_message(update.message)
                else:
                    self.logger.warning(
                        'received update without message: %s', str(update)
                    )

                last_update = update.update_id + 1

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    TardisTelegramBot(sys.argv[1], sys.argv[2]).loop()
