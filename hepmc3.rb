class Hepmc3 < Formula
  desc "Library is to handle  event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/hepmc/"
  url "https://hepmc.web.cern.ch/hepmc/releases/HepMC3-3.2.1.tar.gz"
  sha256 "6e4e4bb5708af105d4bf74efc2745e6efe704e942d46a8042f7dcae37a4739fe"

  option "with-test", "Test during installation"
  option "with-root", "Enable root IO"

  depends_on "cmake" => :build
  depends_on "root" => :optional
  
  def install
    ENV['PATH']="/Library/Frameworks/Python.framework/Versions/3.8/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"
    ENV['ROOTSYS']="/usr/local"
    ENV['PKG_CONFIG_PATH']="/Library/Frameworks/Python.framework/Versions/3.8/lib/pkgconfig"
    ENV['PYTHONPATH']="/Library/Frameworks/Python.framework/Versions/3.8/lib/:/usr/local/Cellar/root/6.20.04_2/lib"
    mkdir "../build" do
      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DHEPMC3_PYTHON_VERSIONS=3.X
        -DHEPMC3_ENABLE_PYTHON=ON

      ]
      args<<"-DHEPMC3_ENABLE_TEST=ON" if build.with? "test"
      args<<"-DHEPMC3_ENABLE_ROOTIO=ON" if build.with? "root"
      system "cmake", buildpath, *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    system "make", "test"
  end
end
