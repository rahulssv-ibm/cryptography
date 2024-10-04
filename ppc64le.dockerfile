# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

ARG base=ppc64le/python:3.12-slim-bullseye
FROM ${base}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update -y -q && \
    apt-get install -y -q --no-install-recommends \
    curl build-essential libssl-dev libffi-dev python3-dev pkg-config cmake \
    git

#RUN  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > sh.rustup.rs && \
#    sh ./sh.rustup.rs -y && export PATH=$PATH:$HOME/.cargo/bin && . "$HOME/.cargo/env"
#RUN rm -rf sh.rustup.rs
# Install Rust using rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > sh.rustup.rs && \
    sh ./sh.rustup.rs -y

# Add Cargo to PATH
ENV PATH="/home/builduser/.cargo/bin:${PATH}"

# Switch to a non-root user
RUN useradd -m builduser
USER builduser

# Create a .bashrc file for builduser
RUN echo 'source $HOME/.cargo/env' > /home/builduser/.bashrc


COPY . /cryptography
WORKDIR /cryptography