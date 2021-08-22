{ stdenv
, fetchFromGitHub
, cmake
, python3
, device-libs
, llvm
, clang
, clang-unwrapped
, openmp
, rocr
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
    sha256 = "0n5qgypyx8qs43y18j1drnanhy7al7namhxn0yzgdws6z7lxsnyz";
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
