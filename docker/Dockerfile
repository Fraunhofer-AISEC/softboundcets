FROM fedora:36

ARG USERNAME
ARG USER_UID
ARG USER_GID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN dnf upgrade -y \
    && dnf install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# build commands
RUN dnf install -y which llvm clang git curl cmake ninja-build lld libnsl mold doxygen

# libs to build SPEC CPU
RUN dnf install -y libnsl libxcrypt-compat numactl

# helpful commands
RUN dnf install -y fish fd-find bat neovim findutils cvise file gdb ripgrep htop procps-ng psmisc exa ccache

RUN dnf debuginfo-install -y glibc libgcc libstdc++

######################### set up some Juliet Test Suite environment requirements

RUN echo "This is my custom textS" > /tmp/file.txt
RUN echo "40" > /tmp/in.txt

ENV ADD=adsfadfasdfadfjjSasdf

################################################################################


# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME

WORKDIR /home/$USERNAME
