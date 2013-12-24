
def utilize():
    swap_info = __salt__['status.meminfo']()
    if swap_info:
        info = dict(
            total=float(swap_info['SwapTotal']['value']),
            free=float(swap_info['SwapFree']['value'])
        )
        return _calculate(info)


def _calculate(info):
    active = info['total'] - info['free']
    val = (active / info['total']) * 100.0
    return val
