#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: `basename $0` OTP_VERSION"
    exit 1
fi

OTP_VERSION=$1
OTP_NAME=$(sed -e 's/./\U&/g' <<< $OTP_VERSION)

sudo docker build -t="herokurouting/erlang:${OTP_VERSION}" - <<EOF
FROM herokurouting/erlang:base
ENV OTP_VERSION $OTP_VERSION
RUN KERL_CONFIGURE_OPTIONS=--enable-hipe kerl build $OTP_NAME $OTP_VERSION
RUN kerl install $OTP_VERSION /opt/erlang/$OTP_VERSION
RUN . /opt/erlang/$OTP_VERSION/activate
EOF

sudo docker push herokurouting/erlang:${OTP_VERSION}
