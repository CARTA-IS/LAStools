# Build stage
FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    g++ \
    make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build/LAStools
COPY . .

RUN cmake -DCMAKE_BUILD_TYPE=Release . \
    && cmake --build . -- -j$(nproc)

# Runtime stage
FROM ubuntu:22.04

COPY --from=builder /build/LAStools/bin64/ /usr/local/bin/

WORKDIR /data

CMD ["/bin/bash"]
