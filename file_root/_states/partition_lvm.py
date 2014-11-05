

__virtualname__ = 'partition_lvm'

def __virtual__():
    if 'partiontion.mkpart' in salt & 'lvm.present' in salt:
        return __virtualname__
    return None


def part_present(name, disk=None):
    """
    Check if partition with 'name' exists
    Check if partition with 'name' is not mounted anywhere
    If not create a partition on the specified disk
    """
    pass


def find_free_space(device):
    part_data = salt['partition.part_list'](device, unit='s')
    disk_final_sector_int = _sector_to_int(part_data['info']['size'])
    last_part_sector_int = _last_sector_in_partition(part_data)
    if (disk_final_sector_int-last_part_sector_int) > 16000000:
        return (_sector_to_int(last_part_sector_int), _sector_to_int(disk_final_sector_int-1))


def _last_sector_in_partition(part_data):
    last_part_sector = 1
    for partition_id, partition_data in part_data['partitions'].iteritems():
        sector_end_in_int = _sector_to_int(partition_data['end']
        if sector_end_in_int > last_part_sector:
	    last_part_sector = sector_end_in_int
    return last_part_sector


def _sector_to_int(sector):
    return int(sector[:-1])


def _int_to_sector(int_sector):
    return str(int_sector) + 's'