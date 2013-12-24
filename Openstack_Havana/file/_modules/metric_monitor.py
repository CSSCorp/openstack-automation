
def read_data():
    if not 'DM' in __pillar__:
        return
    return_data = {'DM': __pillar__['DM'], "machine": __grains__['id']}
    for metric in __pillar__['DM']:
        function = 'metric_%s.utilize' % metric
        if function not in __salt__:
            return_data['DM'][metric].update({'Error': 'function %s not available' % function})
            continue
        metric_cur_val = __salt__[function]()
        return_data['DM'][metric].update({'curval': metric_cur_val})
    return return_data


def monitor():
    return __salt__['event.fire_master'](read_data(), 'sysmon')