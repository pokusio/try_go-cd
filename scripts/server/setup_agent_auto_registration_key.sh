#!/bin/bash

set -Eeuo pipefail

# --- 
# docker run --name gocd-server-peek -itd --restart=always gocd/gocd-server:v22.3.0 /bin/sh
# docker exec --user root -it -e UID=0 -e GID=0 gocd-server-peek /bin/sh -c 'pwd && whoami && id && apk --version && apk update && apk add python3'
# docker exec --user root -it -e UID=0 -e GID=0 gocd-server-peek /bin/sh -c 'pwd && python3 --version'
installPython3(){ # Specific to [gocd/gocd-server:v22.3.0]
  apk update && apk add python3
  python3 --version
}
installPython3
shopt -s expand_aliases
alias python='python3'


if ! grep -q 'agentAutoRegisterKey="agent-autoregister-key"' /go-working-dir/config/cruise-config.xml; then
  echo 'Agent auto registration key is already set up.'
  exit 0
fi

uuid=$(python -c 'import uuid; print str(uuid.uuid4())')

sed -i -e "s/agentAutoRegisterKey=\"agent-autoregister-key\"/agentAutoRegisterKey=\"${uuid}\"/" /go-working-dir/config/cruise-config.xml

echo -n "${uuid}" >/shared/autoregister.key
