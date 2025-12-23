#!/bin/bash
#ddev-generated

VOLUME_OWNER="$(stat -c '%U' /src)"
VOLUME_GROUP="$(stat -c '%G' /src)"
DDEV_USER="$(id -un)"
DDEV_GROUP="$(id -gn)"

# Confirm /src owner and group matches container user. Attempt to fix, if BACKSTOPJS_ALLOW_PERM_REPAIR is true.
# This is to handle cases where BACKSTOPJS_TESTDIR is changed to a directory that does not exist and docker auto-creates it.
if ! [ "$VOLUME_OWNER" = "$DDEV_USER" ] || ! [ "$VOLUME_GROUP" = "$DDEV_GROUP" ]; then
    if [ "${BACKSTOPJS_ALLOW_PERM_REPAIR:-"false"}" = "true" ]; then
        if ! sudo chown -R "$DDEV_USER":"$DDEV_GROUP" /src &> /dev/null; then
            printf "Automated repair failed. %s owner/group is %s/%s, should be %s/%s. On host, run 'sudo chown -R %s:%s %s'." "$BACKSTOPJS_TESTDIR" "$VOLUME_OWNER" "$VOLUME_GROUP" "$DDEV_USER" "$DDEV_GROUP" "$DDEV_USER" "$DDEV_GROUP" "$BACKSTOPJS_TESTDIR"
            exit 1
        fi
    else
        printf "%s owner/group is %s/%s, should be %s/%s. On host, run 'sudo chown -R %s:%s %s'." "$BACKSTOPJS_TESTDIR" "$VOLUME_OWNER" "$VOLUME_GROUP" "$DDEV_USER" "$DDEV_GROUP" "$DDEV_USER" "$DDEV_GROUP" "$BACKSTOPJS_TESTDIR"
        exit 1
    fi
fi

printf "container healthy"
exit 0