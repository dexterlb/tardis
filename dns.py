import yaml
import urllib.request
import base64
import re

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

        self.devices = []

        self.ip_pattern = re.compile(r'''
            <td>(?P<host>[^\s]*)\s*<\/td>
            \s*
            <td>(?P<ip>([0-9]+\.){3}[0-9]+)\s*<\/td>
            \s*
            <td>(?P<mac>([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2}))\s*<\/td>
        ''', re.VERBOSE)

    def update(self):
        new_devices = get_devices
        if new_devices == devices:
            return

        # save_hosts(update_hostnames(new_devices))

        devices_added(new_devices - self.devices)
        devices_removed(self.devices - new_devices)

        self.devices = new_devices

    def devices_added(self, devices):
        if not devices:
            return
        print("connected: ", devices)

    def devices_removed(self, devices):
        if not devices:
            return
        print("disconnected: ", devices)

    def get_devices(self):
        data_string = re.sub(r'[\r\n]', '', self.raw_host_data().decode())
        devices = []
        for match in re.finditer(self.ip_pattern, data_string):
            devices.append(match.groupdict())
        return devices

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
