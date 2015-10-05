#!/usr/bin/env python3

import sys
import logging

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
        pass

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
                    self.logger.info('received update with message: %s',
                                 str(update))
                    self.process_message(update.message)
                else:
                    self.logger.warning('received update without message: %s',
                                    str(update))

                last_update = update.update_id + 1

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    TardisTelegramBot(sys.argv[1], sys.argv[2]).loop()
