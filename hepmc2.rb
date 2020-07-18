class Hepmc2 < Formula
  desc "Library is to handle  event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/hepmc/"
  url "https://hepmc.web.cern.ch/hepmc/releases/hepmc2.06.11.tgz"
  sha256 "86b66ea0278f803cde5774de8bd187dd42c870367f1cbf6cdaec8dc7cf6afc10"

  option "with-test", "Test during installation"
  option "with-root", "Enable root IO"

  depends_on "cmake" => :build
  depends_on "root" => :optional
  
  def install
    ENV['PATH']="/Library/Frameworks/Python.framework/Versions/Current/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"
    ENV['ROOTSYS']="/usr/local"
    ENV['PKG_CONFIG_PATH']="/Library/Frameworks/Python.framework/Versions/Current/lib/pkgconfig"
    ENV['PYTHONPATH']="/Library/Frameworks/Python.framework/Versions/Current/lib/:/usr/local/Cellar/root/6.22.00_1/lib"
    mkdir "../build" do
      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -Dmomentum:STRING=GEV 
        -Dlength:STRING=MM 
      ]
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
