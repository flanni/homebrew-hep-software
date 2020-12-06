class Hepmc3 < Formula
  desc "Library is to handle  event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/hepmc/"
  url "https://hepmc.web.cern.ch/hepmc/releases/HepMC3-3.2.2.tar.gz"
  sha256 "7f2b29b3f18539f4ed9d590a1e5589d6f61eb5c5901263952a442d95136af6e6"

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
        -DHEPMC3_ENABLE_ROOTIO:BOOL=ON 
        -DHEPMC3_ENABLE_TEST:BOOL=ON 
        -DHEPMC3_INSTALL_INTERFACES:BOOL=ON 
        -DHEPMC3_ENABLE_PYTHON:BOOL=ON 
        -DHEPMC3_PYTHON_VERSIONS=3.9 
        -DHEPMC3_BUILD_STATIC_LIBS:BOOL=OFF 
        -DHEPMC3_BUILD_DOCS:BOOL=ON 
        -DHEPMC3_Python_SITEARCH39=/usr/local/lib/python3.9/site-packages 
        -DPYTHIA8_ROOT_DIR=/usr/local/Cellar/pythia8/8.303
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
