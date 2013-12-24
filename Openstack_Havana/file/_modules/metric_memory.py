
def utilize():
    mem_info = __salt__['status.meminfo']()
    if mem_info:
        info = dict(
            total=float(mem_info['MemTotal']['value']),
            free=float(mem_info['MemFree']['value'])
        )
        return _calculate(info)


def _calculate(info):
    active = info['total'] - info['free']
    val = (active / info['total']) * 100.0
    return val
