{ stdenv
, fetchFromGitHub
, cmake
, python3
, device-libs
, llvm
, clang
, clang-unwrapped
, openmp
, rocm-runtime
, hip
, boost
}:
stdenv.mkDerivation rec {
  name = "hipsycl";
  version = "0.9.1";
  src = fetchFromGitHub {
    owner = "illuhad";
    repo = "hipSYCL";
    rev = "v${version}";
    sha256 = "020wr7n9g6kw2klwzlxz6fcw74h2kdm752pqkvn6q28marb549a1";
  };

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ clang openmp llvm ];
  cmakeFlags = [
    "-DCLANG_INCLUDE_PATH=${clang}/resource-root/include"
    "-DWITH_CUDA_BACKEND=NO"
    "-DWITH_ROCM_BACKEND=YES"
    "-DROCM_PATH=${device-libs}"
  ];
  propagatedBuildInputs = [ hip rocr ];

  NIX_TARGET_CFLAGS_COMPILE = " -isystem ${clang-unwrapped}/include";

  prePatch = ''
    patchShebangs bin
    mkdir -p contrib
    mkdir -p contrib/HIP/include/
    ln -s ${hip}/include/hip contrib/HIP/include/
  '';
}
