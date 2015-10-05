#!/usr/bin/env python3

import sys
import logging

import telegram

class TardisBot:
    def __init__(self, telegram_token):
        self.bot = telegram.Bot(token=telegram_token)

    def process_message(self, message):
        self.bot.sendMessage(chat_id=message.chat_id,
                             text=('you said: ' + message.text))
    def loop(self):
        last_update = 0
        while True:
            for update in self.bot.getUpdates(offset=last_update, timeout=30):
                if update.message:
                    logging.info('received update with message: %s',
                                 str(update))
                    self.process_message(update.message)
                else:
                    logging.warning('received update without message: %s',
                                    str(update))

                last_update = update.update_id + 1

if __name__ == '__main__':
    logging.getLogger().setLevel(logging.INFO)
    TardisBot(sys.argv[1]).loop()
