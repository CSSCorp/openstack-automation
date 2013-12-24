
import re
import os
import json
import yaml
import salt
import traceback
import salt.runner
from threading import RLock
sc = salt.client.LocalClient()


def handle(*args, **kwargs):
    data = kwargs['data']  # events data dictionary, contains sysmon results
    machine = data['machine']  # which machine raised the event
    if not _runner_lock(data):
        print "event handler runner already running"
    for metric in data['DM']:
        current_metric_reading = data['DM'][metric]['curval']
        metric_threshold = data['DM'][metric]['threshold']
        if not current_metric_reading > metric_threshold:
            continue
        #time for action
        for action in data['DM'][metric]['actions']:
            if action == 'email':
                email(machine, data['DM'][metric])
            if action == 'scale':
                scale(machine, data['DM'][metric])
    _runner_unlock()


def _runner_lock(data):
    if os.path.isfile('/var/run/salt/event_handler.pid'):
        return False
    with open('/var/run/salt/event_handler.pid', 'w') as runner_id:
        json.dump(data, runner_id)


def _runner_unlock():
    if os.path.isfile('/var/run/salt/event_handler.pid'):
        os.remove('/var/run/salt/event_handler.pid')


def email(machine, metric_data):
    pass


def scale(machine, metric_data):
    machine_pillar = sc.cmd(machine, 'pillar.items')[machine]
    (cluster_file, top_file) = get_cluster_file(machine, machine_pillar)
    machine_type = get_machine_type(machine, cluster_file)
    log(json.dumps(metric_data, indent=4))
    if machine_type not in metric_data['actions']['scale']['types']:
        log("no need to scale %s. scaling not enabled for %s" %
            (machine, machine_type))
        return
    new_machine = None
    if not cluster_file:
        log("cluster file for %s could not be found. Exiting" % machine)
        return
    available_machines = cluster_file.get('scale_options')
    if len(available_machines) > 0:
        new_machine = cluster_file.pop('scale_options')
    if not new_machine:
        log("no new machines available to scale for %s" % machine)
        return
    cluster_file.append(machine_type, new_machine)
    top_file.set(new_machine, ['%s.sls' % machine_pillar['cluster_name']])
    top_file.flush()
    cluster_file.flush()
    cluster_config_directory = get_config_directory(machine, machine_pillar)

    def file_callback(string):
        return re.sub(machine, new_machine, string)

    _replicate(os.path.join(cluster_config_directory, machine),
               os.path.join(cluster_config_directory, new_machine),
               file_callback)
    _sync_cluster(new_machine)


def _replicate(source, destination, callback):
    print 'working at %s \n %s' % (source, destination)
    if not os.path.isdir(destination):
        if os.path.isfile(destination):
            os.remove(destination)
        os.mkdir(destination)
    for item in os.listdir(source):
        item_path = os.path.join(source, item)
        if os.path.isdir(item_path):
            _replicate(item_path, os.path.join(destination, item), callback)
        elif os.path.isfile(item_path):
            with open(item_path, 'rb') as src_file:
                with open(os.path.join(destination, item), 'wb') as dst_file:
                    for line in src_file.readlines():
                        line = callback(line)
                        dst_file.write(line)


def _sync_cluster(new_machine):
    log(sc.cmd(new_machine, 'saltutil.refresh_pillar'))
    log(sc.cmd(new_machine, 'saltutil.sync_all'))
    log(sc.cmd('cluster_type:openstack', 'state.highstate',
               expr_form='pillar'))
    log(sc.cmd('cluster_type:openstack', 'state.highstate',
               expr_form='pillar'))
    log(sc.cmd('cluster_type:openstack', 'state.highstate',
               expr_form='pillar'))


def get_config_directory(machine, machine_pillar):
    cluster_name = machine_pillar['cluster_name']
    for env in machine_pillar['master']['file_roots']:
        for root_dir in machine_pillar['master']['file_roots'][env]:
            dir_name = os.path.join(root_dir, 'config', cluster_name)
            if os.path.isdir(dir_name):
                return dir_name


def get_cluster_file(machine, machine_pillar):
    cluster_name = machine_pillar['cluster_name']
    for env in machine_pillar['master']['pillar_roots']:
        for pillar_dir in machine_pillar['master']['pillar_roots'][env]:
            file_name = os.path.join(pillar_dir, '%s.sls' % cluster_name)
            if os.path.isfile(file_name):
                top_file = os.path.join(pillar_dir, 'top.sls')
                cluster_file = sls_conf(file_name)
                top_file = sls_conf(top_file)
                return (cluster_file, top_file)


def get_machine_type(machine, cluster_file):
    for entity in cluster_file.get("install").keys():
        if machine in cluster_file.get(entity):
            return entity


def log(text):
    print text


class sls_conf(object):
    """
    a parser for sls configuration files. Supports json and yaml
    config_obj = sls_conf('path to config file')
    """
    pattern = re.compile(r'(^#!)((\w+)((\|(\w+))*))')  # shebang pattern
    default = 'yaml'

    def __init__(self, configfile):
        """
        json_cfg = json_conf(configfile)
        configfile : full path to a json configuration file
        """
        object.__init__(self)
        self.configfile = configfile
        self.lock = RLock()
        self.shebang = ''
        self.refresh()

    def refresh(self):
        with open(self.configfile, 'r', 0) as cfgfile:
            self.shebang = cfgfile.readline()
            slstype = self.findtype()
            if not slstype:
                print 'no default specified. Trying default %s' % self.default
                cfgfile.seek(0, 0)
                self.shebang = ''
                loader = getattr(self, 'load_%s' % self.default)
            else:
                loader = getattr(self, 'load_%s' % slstype)
            loader(cfgfile)

    def flush(self):
        with open(self.configfile, 'w', 0) as cfgfile:
            cfgfile.write(self.shebang)
            slstype = self.findtype()
            if not slstype:
                print 'no default specified. Trying default %s' % self.default
                renderer = getattr(self, 'render_%s' % self.default)
            else:
                renderer = getattr(self, 'render_%s' % slstype)
            cfgfile.write(renderer())

    def dump(self):
        print self.shebang
        slstype = self.findtype()
        if not slstype:
            print 'no default specified. Trying default %s' % self.default
            renderer = getattr(self, 'render_%s' % self.default)
        else:
            renderer = getattr(self, 'render_%s' % slstype)
        print renderer()

    def findtype(self, txt=None):
        if not txt:
            txt = self.shebang
        ma = re.match(self.pattern, txt)
        if ma:
            if ma.group(3) in ['yaml', 'json']:
                return ma.group(3)
            else:
                if ma.group(4)[0] == '|':
                    return self.findtype(ma.group(1) + ma.group(4)[1:])

    def load_json(self, cfgfile):
        self.config = json.load(cfgfile)

    def load_yaml(self, cfgfile):
        self.config = yaml.load(cfgfile.read())

    def render_json(self):
        return json.dumps(self.config, indent=4)

    def render_yaml(self):
        return yaml.dump(self.config)

    def __enter__(self):
        self.lock.acquire()
        return self

    def __exit__(self, excep_type, excep_value, tb):
        if tb:
            print traceback.format_exc()
            raise excep_value
        self.lock.release()

    def get(self, path, config=None):
        """
        config_obj.get(<<dot separated path to the config parameter you need>>)
        """
        if not config:
            config = self.config
        path_list = path.split('.')
        if path_list[0] in config:
            if len(path_list) == 1:
                return config[path_list[0]]
            return self.get('.'.join(path_list[1:]), config[path_list[0]])

    def set(self, path, value, config=None):
        """
        config_obj.set(<<dot separated path to the config parameter you need>>)
        """
        if not config:
            config = self.config
        path_list = path.split('.')
        if path_list[0] in config:
            if len(path_list) == 1:
                config.update({path_list[0]: value})
                return value
            return self.set('.'.join(path_list[1:]), value,
                            config[path_list[0]])

    def append(self, path, value, config=None):
        """
        config_obj.append(
            <<dot separated path to the list you want to append to>>)
        works only if the leaf element is a list
        """
        element = self.get(path)
        if type(element) == list:
            element.append(value)
            return value

    def remove(self, path, value, config=None):
        element = self.get(path)
        if type(element) == list:
            return element.pop(element.index(value))

    def pop(self, path, config=None):
        element = self.get(path)
        if type(element) == list:
            return element.pop()
