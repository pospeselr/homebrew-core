class Libcgosling < Formula
  desc ""
  homepage "https://gosling.technology"
  url "https://github.com/blueprint-freespeech/gosling.git", tag: "cgosling-v0.2.2"
  license "BSD-3-Clause"

  depends_on "rust" => :build
  depends_on "cmake" => :build
  depends_on "tor"

  def install
    system "cmake",
      "-S", ".",
      "-B", "build",
      "-DCMAKE_BUILD_TYPE=Release",
      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cgosling.hpp>

      int main() {
        gosling_library* library = nullptr;
        gosling_error* err = nullptr;
        ::gosling_library_init(&library, &error);
        if (library != nullptr && error == nullptr) {
          gosling_library_free(library);
        } else {
          return -1;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lcgosling", "-o", "test"
    system "./test"
  end
end
