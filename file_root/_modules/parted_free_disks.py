

__virtualname__ = 'partition_free_disks'

def __virtual__():
    return __virtualname__

def free_disks(min_disk_size='10'):
    """
    Check if partition with 'name' exists
    Check if partition with 'name' is not mounted anywhere
    If not create a partition on the specified disk
    """
    available_disks = []
    for free_space in find_free_spaces(int(min_disk_size)):
        __salt__['partition.mkpart'](free_space['device'], 'primary', 'fat32',
                                     start=free_space['start'],
                                     end=free_space['end'])
        available_disks.append(free_space['device']+free_space['id'])
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


def find_free_spaces(min_disk_size):
    free_spaces = []
    for block_device in get_block_device():
        device_name = '/dev/%s' % block_device
        part_data = __salt__['partition.part_list'](device_name, unit='s')
        sector_size = _sector_to_int(part_data['info']['logical sector'])
        disk_final_sector_int = _sector_to_int(part_data['info']['size'])
        last_device_id, last_allocated_sector_int = _last_allocated_sector(part_data['partitions'])
        if ((disk_final_sector_int-last_allocated_sector_int)*sector_size)/1073741824 > min_disk_size:
            free_spaces.append({'device': device_name,
                                'id': str(last_device_id+1),
                                'start': _int_to_sector(last_allocated_sector_int+1),
                                'end': _int_to_sector(disk_final_sector_int-1)})
    return free_spaces

def _last_allocated_sector(part_data):
    last_allocated_sector = 2048
    for partition_id, partition_data in part_data.iteritems():
        sector_end_in_int = _sector_to_int(partition_data['end'])
        if sector_end_in_int > last_allocated_sector:
            last_allocated_sector = sector_end_in_int
    return int(partition_id), last_allocated_sector
        
def _sector_to_int(sector):
    if sector[-1] == 's':
        return int(sector[:-1])
    return int(sector)

def _int_to_sector(int_sector):
    return str(int_sector) + 's'