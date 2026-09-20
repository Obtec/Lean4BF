FROM leanprover/lean4:v4.34.0

WORKDIR /app

# Lake 설정 및 의존성 파일 복사
COPY lakefile.toml lean-toolchain ./

# 소스 코드 복사
COPY Lean4BF.lean Main.lean ./
COPY Lean4BF ./Lean4BF

# 프로젝트 빌드
RUN lake build

EXPOSE 8080

CMD ["./.lake/build/bin/lean4bf"]
