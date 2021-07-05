#!/bin/bash

#
# Copyright (C) 2021 Nethesis S.r.l.
# http://www.nethesis.it - nethserver@nethesis.it
#
# This script is part of NethServer.
#
# NethServer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License,
# or any later version.
#
# NethServer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with NethServer.  If not, see COPYING.
#

set -e

if ! buildah containers --format "{{.ContainerName}}" | grep -q repomd-builder; then
    echo "Pulling Python runtime and Skopeo..."
    buildah from --name repomd-builder -v "${PWD}:/usr/src:Z" docker.io/library/python:3.9-alpine
    buildah run repomd-builder sh <<EOF
cd /usr/src
python -mvenv /opt/pyenv --upgrade-deps
source /opt/pyenv/bin/activate
pip install semver
apk add skopeo
EOF
fi

buildah run repomd-builder sh -c "cd /usr/src ; . /opt/pyenv/bin/activate ; python createrepo.py"
