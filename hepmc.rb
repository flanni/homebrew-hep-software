class Hepmc < Formula
  desc "C++ event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/"
  url "http://hepmc.web.cern.ch/hepmc/releases/HepMC3-3.1.0.tar.gz"
  sha256 "cd37eed619d58369041018b8627274ad790020a4714b54ac05ad1ebc1a6e7f8a"

  option "with-test", "Test during installation"

  depends_on "cmake" => :build

  def install
    flargs = %W[
      -DHEPMC3_BUILD_EXAMPLES=OFF
      -DROOT_DIR=#{Formula["root"].inc_prefix}
    ]
    
    mkdir "../build" do
      system "cmake", buildpath, "-Dmomentum:STRING=GEV", "-Dlength:STRING=MM", *flargs, *std_cmake_args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    cp_r share/"HepMC/examples/.", testpath
    system "make", "example_BuildEventFromScratch.exe"
    system "./example_BuildEventFromScratch.exe"
  end
end
