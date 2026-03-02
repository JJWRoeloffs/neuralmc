FROM ubuntu:20.04

# To prevent tzdata from prompting current location
ENV DEBIAN_FRONTEND=noninteractive


# The stuff that needs to be there, everywhere
RUN apt-get update -y && apt-get install -y python3 python3-pip software-properties-common git vim wget
RUN python3 -m pip install colorama pandas torch torch_optimizer
WORKDIR /root/neuralmc

# Installing verilator. Not done in a seperate stage because it confuses build and run dependencies.
RUN apt-get update -y && apt-get install -y help2man perl make autoconf g++ flex bison ccache libgoogle-perftools-dev numactl perl-doc libfl2 libfl-dev zlibc zlib1g zlib1g-dev

RUN git clone https://github.com/verilator/verilator
RUN cd verilator && git checkout v5.022 && autoconf && bash ./configure && make -j `nproc` && make install
RUN rm -r ./verilator

# Confirm working installation (we are cloning a random git repo, after all)
RUN <<'EOF'
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
cd "$tmpdir"

cat > our.v <<'EOV'
module our;
  initial begin
    $display("Hello World");
    $finish;
  end
endmodule
EOV

verilator --binary -j 0 -Wall our.v
./obj_dir/Vour | grep -q "Hello World"
EOF

### - Installing Bitwuzla (Needs to be after verilator)
### (Only git version possible, so we need the latest version of some packages)

# installing the latest gmp.
RUN wget https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz && tar -xf gmp-6.3.0.tar.xz
RUN cd gmp-6.3.0 && ./configure --enable-cxx && make && make check && make install
RUN rm -r ./gmp-6.3.0

# installing the latest mpfr
# For some reason, installing libgmp-dev before doing the manual install fixes a compiler error.
RUN wget https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.xz && tar -xf mpfr-4.2.1.tar.xz
RUN cd mpfr-4.2.1 && ./configure && make && make install
RUN rm -r ./mpfr-4.2.1

RUN apt-get update -y && apt-get install -y build-essential pkg-config ninja-build libgtest-dev
RUN python3 -m pip install cmake meson ninja cython
RUN git clone https://github.com/bitwuzla/bitwuzla && cd bitwuzla && ./configure.py debug && cd build && meson test
RUN python3 -m pip install ./bitwuzla

COPY ./ ./
