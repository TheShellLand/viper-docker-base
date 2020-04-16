FROM python:3

ENV VERSION 2.x

USER root
WORKDIR /

# from docs
RUN apt update \
    && apt install -y git gcc python3-dev python3-pip

# fix
RUN apt install -y libfuzzy-dev

# install latest from git
RUN if [ "$VERSION" = "2.x" ]; then \
    git clone https://github.com/viper-framework/viper \
    && cd viper \
    && pip3 install . ; fi

# if you want to pip install viper-framework
#RUN apt update \
#    && apt install -y git gcc python3-dev python3-pip \
#    && apt-get -y install libfuzzy-dev \
#    && pip3 install viper-framework

# install from git
RUN if [ "$VERSION" = "v1.3" ]; then \
    git clone https://github.com/viper-framework/viper \
    && cd viper \
    && git reset --hard $VERSION \
    # fix Cannot import name "Feature" from "setuptools"
    && pip3 install --upgrade setuptools \
    # fix c/call_python.c:20:30: error: dereferencing pointer to incomplete type ‘PyInterpreterState’ {aka ‘struct _is’}
    && pip3 install cffi \
    # fix ERROR: pymisp 2.4.124 has requirement jsonschema<4.0.0,>=3.2.0, but you'll have jsonschema 2.6.0 which is incompatible.
    # fix ERROR: pymispgalaxies 0.2 has requirement jsonschema<4.0.0,>=3.2.0, but you'll have jsonschema 2.6.0 which is incompatible.
    && pip3 install jsonschema==3.2.0 \
    # fix ERROR: pymisp 2.4.124 has requirement python-dateutil<3.0.0,>=2.8.1, but you'll have python-dateutil 2.6.1 which is incompatible.
    && pip3 install python-dateutil==2.8.1 \
    # fix ERROR: pymisp 2.4.124 has requirement requests<3.0.0,>=2.22.0, but you'll have requests 2.18.4 which is incompatible.
    && pip3 install requests==2.22.0 \
    # fix ERROR: msoffcrypto-tool 4.10.2 has requirement cryptography>=2.3, but you'll have cryptography 2.1.3 which is incompatible.
    && pip3 install cryptography==2.3 \
    # fix ERROR: msoffcrypto-tool 4.10.2 has requirement olefile>=0.45, but you'll have olefile 0.44 which is incompatible.
    # fix ERROR: oletools 0.56.dev4 has requirement olefile>=0.46, but you'll have olefile 0.44 which is incompatible.
    && pip3 install olefile==0.46 \
    # fix ERROR: androguard 3.4.0 has requirement asn1crypto>=0.24.0, but you'll have asn1crypto 0.23.0 which is incompatible.
    && pip3 install asn1crypto==0.24.0 \
    # fix ERROR: pyasn1-modules 0.2.8 has requirement pyasn1<0.5.0,>=0.4.6, but you'll have pyasn1 0.4.2 which is incompatible.
    && pip3 install pyasn1==0.4.6 \
    # fix ImportError: cannot import name 'Feature' from 'setuptools' (/usr/local/lib/python3.8/site-packages/setuptools/__init__.py)
    && pip3 install MarkupSafe \
    && sed -i 's/requests==.*//' requirements-base.txt \
    && sed -i 's/cffi.*//' requirements-modules.txt \
    && sed -i 's/jsonschema.*//' requirements-modules.txt \
    && sed -i 's/python-dateutil.*//' requirements-modules.txt \
    && sed -i 's/requests.*//' requirements-modules.txt \
    && sed -i 's/cryptography.*//' requirements-modules.txt \
    && sed -i 's/olefile.*//' requirements-modules.txt \
    && sed -i 's/asn1crypto.*//' requirements-modules.txt \
    && sed -i 's/pyasn1.*//' requirements-modules.txt \
    && sed -i 's/jsonschema.*//' requirements-modules.txt \
    && sed -i 's/MarkupSafe.*//' requirements-modules.txt \
    && pip3 install -r requirements-base.txt \
    && pip3 install -r requirements-modules.txt \
    && pip3 install -r requirements-web.txt \
    # fix No module named 'viper.modules.pdftools'
    && cd /viper/viper/modules \
    && rm -rf pdftools \
    && git clone https://github.com/viper-framework/pdftools \
    && cd pdftools \
    && git reset --hard 5e38ea45fde26b1713fb0057ed0e9f7a64ddd0e8 \
    && cd /viper \
    # fix pymacho_helper
    && cd /viper/viper/modules \
    && rm -rf pymacho_helper \
    && git clone https://github.com/viper-framework/Mach-O pymacho_helper \
    && cd pymacho_helper \
    && git reset --hard 5717c9a533db7cae269c4de36f079a1429113f4f \
    && cd /viper \
    # fix module 'pip' has no attribute 'req'
    && pip3 install --upgrade pip==9 \
    && python setup.py build \
    && python setup.py install \
    && mkdir -p /usr/share/viper \
    && cp -rf data/* /usr/share/viper \
    && cp viper.conf.sample /usr/share/viper/viper.conf.sample \
    && pip3 install --upgrade pip \
    && ln -s /usr/local/bin/viper-cli /usr/local/bin/viper \
    # delete all modules
    && rm -rf /usr/local/lib/python3.8/site-packages/viper-1.3.dev0-py3.8.egg/viper/modules/* ; fi

# cleanup
RUN apt autoremove -y \
    && apt autoclean \
    && apt clean \
    && rm -rf /tmp/*

USER root

ENTRYPOINT ["viper"]
