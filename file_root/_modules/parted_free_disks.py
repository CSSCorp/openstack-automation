

__virtualname__ = 'partition_free_disks'

def __virtual__():
    if ('partition.mkpart' in __salt__) & ('lvm.present' in __salt__):
        return __virtualname__
    return None

def free_disks(min_disk_size='10G'):
    """
    Check if partition with 'name' exists
    Check if partition with 'name' is not mounted anywhere
    If not create a partition on the specified disk
    """
    available_disks = []
    for free_space in _find_free_spaces(min_disk_size):
        if __salt__['partition.mkpart'](free_space['device'], 'primary',
                                    start=None, end=None):
            available_disks.append(free_space)
    return []
    return available_disks


def get_block_device():
    '''
    Retrieve a list of disk devices

    .. versionadded:: 2014.7.0

    CLI Example:

    .. code-block:: bash

        salt '*' partition.get_block_device
    '''
    cmd = 'lsblk -n -io KNAME -d -e 1,7,11 -l'
    devs = __salt__['cmd.run'](cmd).splitlines()
    return devs


def _find_free_space(device):
    part_data = __salt__['partition.part_list'](device, unit='s')
    disk_final_sector_int = _sector_to_int(part_data['info']['size'])
    last_part_sector_int = _last_sector_in_partition(part_data)
    if (disk_final_sector_int-last_part_sector_int) > 16000000:
        return (_sector_to_int(last_part_sector_int), _sector_to_int(disk_final_sector_int-1))

def _last_sector_in_partition(part_data):
    last_part_sector = 1
    for partition_id, partition_data in part_data['partitions'].iteritems():
        sector_end_in_int = _sector_to_int(partition_data['end'])
        if sector_end_in_int > last_part_sector:
            last_part_sector = sector_end_in_int
    return last_part_sector
        
def _sector_to_int(sector):
    return int(sector[:-1])

def _int_to_sector(int_sector):
    return str(int_sector) + 's'