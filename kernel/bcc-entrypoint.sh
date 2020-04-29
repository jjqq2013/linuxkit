#!/bin/sh
set -e
if [ ! -d /sys/kernel/debug/tracing ]; then
  if ! mount -t debugfs debugfs /sys/kernel/debug; then
    echo -e 'please run:\n  docker run -it --privileged --net=host --ipc=host --pid=host --uts=host --userns=host\n    -v /dev:/dev -v /lib/modules:/lib/modules  -v /sys:/sys\n    <THIS_IMAGE_NAME> [COMMAND [ARGS...]]' >&2
    exit 1
  fi
fi
if [ "`cat /proc/sys/kernel/kptr_restrict`" -gt 1 ]; then
  if echo 1 > /proc/sys/kernel/kptr_restrict; then
    echo 'changed /proc/sys/kernel/kptr_restrict=1 so root user can view addresses in /proc/kallsyms' >&2
  else
    echo 'failed to set /proc/sys/kernel/kptr_restrict=1, so can not view addresses in /proc/kallsyms, some tools such as execsnoop will not work' >&2
  fi
fi
exec "$@"
