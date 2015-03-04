#!/usr/bin/env python3

import yaml
import urllib.request
import base64
import re
import os
from collections import namedtuple
from time import sleep

CURRENT_DIR = os.path.dirname(__file__)

Device = namedtuple('Device', ['ip', 'mac', 'host'])

class DnsMonitor:
    def __init__(self,
                 router_host, router_user, router_password,
                 hosts, hosts_file):
        
        url = 'http://{}/DHCPTable.htm'.format(router_host)

        router_auth = base64.b64encode(router_user.encode() + b':' +
                                       router_password.encode())

        self.request = urllib.request.Request(url)
        self.request.add_header('Authorization', b'Basic ' + router_auth)

        self.hosts = hosts
        self.hosts_file = hosts_file

        self._devices = set()

        self.ip_pattern = re.compile(r'''
            <td>(?P<host>[^\s]*)\s*<\/td>
            \s*
            <td>(?P<ip>([0-9]+\.){3}[0-9]+)\s*<\/td>
            \s*
            <td>(?P<mac>([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2}))\s*<\/td>
        ''', re.VERBOSE)

    def connected(self, devices):
        if not devices:
            return
        print("connected: ", devices)
        os.system('woosh 1')

    def disconnected(self, devices):
        if not devices:
            return
        print("disconnected: ", devices)

    def update(self):
        new_devices = self.get_devices()
        if new_devices == self._devices:
            return

        self.save_hosts(new_devices)
        os.system('reload_dns')

        self.connected(new_devices - self._devices)
        self.disconnected(self._devices - new_devices)

        self._devices = new_devices
    
    def save_hosts(self, devices):
        if not self.hosts_file:
            return
        with open(self.hosts_file, 'w') as f:
            for device in devices:
                hostnames = self.hostnames(device)
                if hostnames:
                    f.write(device.ip + ' ' + ' '.join(hostnames) + '\n')

    def hostnames(self, device):
        hostnames = self.hosts.get(device.mac, [])
        if type(hostnames) is not list:
            hostnames = [hostnames]

        if re.match(r'^[a-zA-Z0-9\-]+$', device.host):
            if device.host not in hostnames:
                hostnames.append(device.host) 

        return hostnames

    def get_devices(self):
        data_string = re.sub(r'[\r\n]', '', self.raw_host_data().decode())
        devices = []
        for match in re.finditer(self.ip_pattern, data_string):
            devices.append(Device(**match.groupdict()))
        return set(devices)

    def raw_host_data(self):
        return urllib.request.urlopen(self.request).read()

class Loop:
    def __init__(self, config_file):
        with open(config_file, 'r') as f:
            config = yaml.load(f.read())
        self.monitor = DnsMonitor(
            router_host = config['router_host'],
            router_user = config['router_user'],
            router_password = config['router_password'],
            hosts = config['hosts'],
            hosts_file = config['hosts_file']
        )

    def run(self):
        while True:
            self.monitor.update()
            sleep(2)

Loop(os.path.join(CURRENT_DIR, 'tardis.conf')).run()
