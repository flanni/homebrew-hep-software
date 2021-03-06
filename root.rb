class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch/"
  url "https://root.cern/download/root_v6.22.02.source.tar.gz"
  version "6.22.02"
  sha256 "89784afa9c9047e9da25afa72a724f32fa8aa646df267b7731e4527cc8a0c340"

  depends_on "cmake" => :build
  depends_on "cfitsio"
  depends_on "davix"
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "gl2ps"
  depends_on "graphviz"
  depends_on "gsl"
  # Temporarily depend on Homebrew libxml2 to work around a brew issue:
  # https://github.com/Homebrew/brew/issues/5068
  depends_on "libxml2" if MacOS.version >= :mojave
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "tbb"
  depends_on "xrootd"
  depends_on "xz" # for LZMA
  depends_on "zstd"

  conflicts_with "glew", :because => "root ships its own copy of glew"

  skip_clean "bin"

  def install
    
    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900
    # 
    # Freetype/afterimage/gl2ps/lz4 are vendored in the tarball, so are fine.
    # However, this is still permitting the build process to make remote
    # connections. As a hack, since upstream support it, we inreplace
    # this file to "encourage" the connection over HTTPS rather than HTTP.
    inreplace "cmake/modules/SearchInstalledSoftware.cmake",
              "http://lcgpackages",
              "https://lcgpackages"
    
    ENV['PATH']="/Library/Frameworks/Python.framework/Versions/Current/bin:/usr/local/opt/make/libexec/gnubin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"
    ENV['PKG_CONFIG_PATH']="/Library/Frameworks/Python.framework/Versions/Current/lib/pkgconfig"
    ENV['PYTHONPATH']="/Library/Frameworks/Python.framework/Versions/Current/lib/:/usr/local/Cellar/pythia8/8.302/lib"

    #-DCLING_CXX_PATH=clang++
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -DPYTHON_EXECUTABLE=/Library/Frameworks/Python.framework/Versions/Current/bin/python
      -Dbuiltin_cfitsio=OFF
      -Dbuiltin_freetype=ON
      -Dbuiltin_glew=ON
      -Ddavix=ON
      -Dfftw3=ON
      -Dfitsio=ON
      -Dfortran=ON
      -Dgdml=ON
      -Dgnuinstall=ON
      -Dimt=ON
      -Dmathmore=ON
      -Dminuit2=ON
      -Dmysql=OFF
      -Dpgsql=OFF
      -Dpyroot=ON
      -Droofit=ON
      -Dtmva=ON
      -Dxrootd=ON
      -Dpythia8=OFF
      -Dproof=OFF
    ]

    cxx_version = (MacOS.version < :mojave) ? 14 : 17
    args << "-DCMAKE_CXX_STANDARD=#{cxx_version}"

    # Workaround the shim directory being embedded into the output
    inreplace "build/unix/compiledata.sh", "`type -path $CXX`", ENV.cxx

    mkdir "builddir" do
      system "cmake", "..", *args

      system "make", "install"

      chmod 0755, Dir[bin/"*.*sh"]

      #version = Language::Python.major_minor_version "/Library/Frameworks/Python.framework/Versions/Current/bin/python"
      version = "3.9"
      pth_contents = "import site; site.addsitedir('#{lib}/root')\n"
      (prefix/"lib/python#{version}/site-packages/homebrew-root.pth").write pth_contents
    end
  end

  def caveats
    <<~EOS
      As of ROOT 6.22, you should not need the thisroot scripts; but if you
      depend on the custom variables set by them, you can still run them:
      For bash users:
        . #{HOMEBREW_PREFIX}/bin/thisroot.sh
      For zsh users:
        pushd #{HOMEBREW_PREFIX} >/dev/null; . bin/thisroot.sh; popd >/dev/null
      For csh/tcsh users:
        source #{HOMEBREW_PREFIX}/bin/thisroot.csh
      For fish users:
        . #{HOMEBREW_PREFIX}/bin/thisroot.fish
    EOS
  end

  test do
    (testpath/"test.C").write <<~EOS
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS

    # Test ROOT command line mode
    system "#{bin}/root", "-b", "-l", "-q", "-e", "gSystem->LoadAllLibraries(); 0"

    # Test ROOT executable
    assert_equal "\nProcessing test.C...\nHello, world!\n",
                 shell_output("root -l -b -n -q test.C")

    # Test linking
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <TString.h>
      int main() {
        std::cout << TString("Hello, world!") << std::endl;
        return 0;
      }
    EOS
    (testpath/"test_compile.bash").write <<~EOS
      $(root-config --cxx) $(root-config --cflags) $(root-config --libs) $(root-config --ldflags) test.cpp
      ./a.out
    EOS
    assert_equal "Hello, world!\n",
                 shell_output("/bin/bash test_compile.bash")

    # Test Python module
    system "/Library/Frameworks/Python.framework/Versions/Current/bin/python", "-c", "import ROOT; ROOT.gSystem.LoadAllLibraries()"
  end
end
