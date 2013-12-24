
def utilize():
    cpu_stats = __salt__['status.cpustats']()
    if cpu_stats:
        stats = cpu_stats.get('cpu')
        return _calculate(stats)


def _calculate(stats):
    active = float(
        stats['user'] + stats['nice'] + stats['system'] +
        stats.get('guest', 0.0)
    )
    total = float(
        stats['user'] + stats['nice'] + stats['system'] + stats['idle'] +
        stats['iowait'] + stats['irq'] + stats['softirq'] + stats['steal'] +
        stats.get('guest', 0.0)
    )
    val = (active / total) * 100.0
    return val
