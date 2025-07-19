# Configure zram Swap

## 1. Description

The zram module creates RAM-based block devices. Data written to these block devices is stored are compressed<b>*</b> and stored inside the memory. The usecase for such block devices is faster swap access: due to the nature of how RAM operates, it's much quicker to access swapped data from the memory than from a swap file or swap partition. The compression ratio is about 3:1, so 1 GB swap equals to ~333 MB in the memory.

<b>*</b> The compression algorithm can be configured.

*Further reading: https://www.kernel.org/doc/html/latest/admin-guide/blockdev/zram.html*

## 2. Configuration

### 2.1. systemd

systemd-zram-generate offers easy block device management via the `systemctl` command. It also comes with a default configuration that fits most users.

**Installation:** `sudo apt install systemd-zram-generator`

**Configuration file:** `/etc/systemd/zram-generator.conf`

```shell
$ cat /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 2         # use half of the maximum available RAM
compression-algorithm = lz4 # use lz4 compression; others: deflate, lzo, zstd
```
💡 I recommend keeping the default compression algorithm or switching to `zstd` for the best compression to speed ratio.

**Initialization:**

1. Create new device units: `systemctl daemon-reload`
2. Start the systemd service: `systemctl start /dev/zram0` (adjust the name if necessary to match `zram-generator.conf`)
3. Check the zram swap was generated correctly:

```shell
$ sudo zramctl
NAME       ALGORITHM DISKSIZE DATA COMPR TOTAL STREAMS MOUNTPOINT
/dev/zram0 lz4          7.8G  16K  1.3K   44K      12 [SWAP]
```

💡 `DISKSIZE` is defined by `zram-size` in `zram-generator.conf`, so you might see a different value on your system.

### 2.2. non-systemd

There are plenty of available tools for creating and managing zram swap block devices. A famous option is `zram-tools`.

**Installation:** `sudo apt install zram-tools`

**Configuration file:** `/etc/default/zramswap`

```shell
$ cat /etc/default/zramswap
# Compression algorithm selection
# speed: lz4 > zstd > lzo
# compression: zstd > lzo > lz4
# This is not inclusive of all that is available in the latest kernels
# See /sys/block/zram0/comp_algorithm (when zram module is loaded) to see
# what is currently set and available for your kernel
ALGO=lz4

# Specifies the amount of RAM that should be used for zram
# based on the percentage the total amount of available memory
# This takes precedence and overrides SIZE below
#PERCENT=50

# Specifies a static amount of RAM that should be used for
# the ZRAM devices, this is in MiB
#SIZE=256

# Specifies the priority for the swap devices, see swapon(2)
# for more details. Higher number = higher priority
# This should probably be higher than hdd/ssd swaps.
#PRIORITY=100
```

💡 I recommend keeping the default compression algorithm or switching to `zstd` for the best compression to speed ratio, then uncommenting the `PERCENT` line and leaving it `50` (50% of the maximum available memory).

💡 Uncomment the `PRIORITY` line if you're also using a swap file or swap partition, then set the value (`100`) higher than what's defined for your existing swap configuration (check it with `cat /proc/sys/vm/swappiness`).

**Initialization:**

1. Reboot your system.
2. Check the zram swap was generated correctly:

```shell
$ sudo swapon
NAME       TYPE      SIZE USED PRIO
/dev/zram0 partition 7.8G 512K  100
```

💡 `swapon` doesn't return the compression algorithm.
