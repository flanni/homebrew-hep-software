class Hepmc3 < Formula
  desc "Library is to handle  event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/hepmc/"
  url "https://files.pythonhosted.org/packages/93/c4/8c262545ae027f437ffefe5a20a646228438039dc1dc289ba3ea31555285/HepMC3-3.2.2.1.tar.gz"
  sha256 "217ddf9a43bdb578f4d8ade31479cc8b9912bf441645c86537776ac7de1925c8"

  option "with-test", "Test during installation"
  option "with-root", "Enable root IO"

  depends_on "cmake" => :build
  depends_on "root" => :optional
  
  def install
    ENV['PATH']="/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"
    ENV['ROOTSYS']="/usr/local"
    ENV['PKG_CONFIG_PATH']="/usr/local/Cellar/python@3.9/3.9.0_2/lib/pkgconfig"
    ENV['PYTHONPATH']="/usr/local/Cellar/python@3.9/3.9.0_2/lib/site-packages:/usr/local/Cellar/root/6.20.04_2/lib"
    mkdir "../build" do
      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DHEPMC3_PYTHON_VERSIONS=3.X
        -DHEPMC3_ENABLE_PYTHON=ON
        -DHEPMC3_BUILD_EXAMPLES=ON
        -DHEPMC3_BUILD_DOCS=ON
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
