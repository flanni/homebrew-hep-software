class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "https://geant4.web.cern.ch"
  url "https://geant4-data.web.cern.ch/geant4-data/releases/source/geant4.10.07.p02.tar.gz"
  version "10.7.2"
  sha256 "5eaa519b66d62703f9a9667f35b8dd95e50c1127d56a534215f8834e3c38129f"

#  bottle do
#    sha256 cellar: :any, big_sur:     "170f4a4a3c7c730371e324e7f8e067a855247c1e7ed58f6313be95a55448b7ce"
#    sha256 cellar: :any, catalina:    "ce3f0b6a5d075a00e48d38389348e2cc4c140bc88cccb9d44337b48aeb1cfb9e"
#    sha256 cellar: :any, mojave:      "8bca28cae9c11797ae79e787c3fdfe17cf5b4a1ddb478b7731f36a25ea6f1a7b"
#    sha256 cellar: :any, high_sierra: "09736ea0f71a08b93566a3fb02a16c8bef148e5f79eba71fb8fdd0c5947fa001"
#  end

  depends_on "cmake" => [:build, :test]
  depends_on "expat"
  depends_on "qt"
  depends_on "xerces-c"

  # Check for updates in cmake/Modules/Geant4DatasetDefinitions.cmake

  resource "G4NDL" do
    url "https://cern.ch/geant4-data/datasets/G4NDL.4.6.tar.gz"
    sha256 "9d287cf2ae0fb887a2adce801ee74fb9be21b0d166dab49bcbee9408a5145408"
  end

  resource "G4EMLOW" do
    url "https://cern.ch/geant4-data/datasets/G4EMLOW.7.13.tar.gz"
    sha256 "374896b649be776c6c10fea80abe6cf32f9136df0b6ab7c7236d571d49fb8c69"
  end

  resource "PhotonEvaporation" do
    url "https://cern.ch/geant4-data/datasets/G4PhotonEvaporation.5.7.tar.gz"
    sha256 "761e42e56ffdde3d9839f9f9d8102607c6b4c0329151ee518206f4ee9e77e7e5"
  end

  resource "RadioactiveDecay" do
    url "https://cern.ch/geant4-data/datasets/G4RadioactiveDecay.5.6.tar.gz"
    sha256 "3886077c9c8e5a98783e6718e1c32567899eeb2dbb33e402d4476bc2fe4f0df1"
  end

  resource "G4SAIDDATA" do
    url "https://cern.ch/geant4-data/datasets/G4SAIDDATA.2.0.tar.gz"
    sha256 "1d26a8e79baa71e44d5759b9f55a67e8b7ede31751316a9e9037d80090c72e91"
  end

  resource "G4PARTICLEXS" do
    url "https://cern.ch/geant4-data/datasets/G4PARTICLEXS.3.1.1.tar.gz"
    sha256 "66c17edd6cb6967375d0497add84c2201907a25e33db782ebc26051d38f2afda"
  end

  resource "G4ABLA" do
    url "https://cern.ch/geant4-data/datasets/G4ABLA.3.1.tar.gz"
    sha256 "7698b052b58bf1b9886beacdbd6af607adc1e099fc730ab6b21cf7f090c027ed"
  end

  resource "G4INCL" do
    url "https://cern.ch/geant4-data/datasets/G4INCL.1.0.tar.gz"
    sha256 "716161821ae9f3d0565fbf3c2cf34f4e02e3e519eb419a82236eef22c2c4367d"
  end

  resource "G4PII" do
    url "https://cern.ch/geant4-data/datasets/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end
  
 resource "G4ENSDFSTATE" do
    url "https://cern.ch/geant4-data/datasets/G4ENSDFSTATE.2.3.tar.gz"
    sha256 "9444c5e0820791abd3ccaace105b0e47790fadce286e11149834e79c4a8e9203"
  end

  resource "RealSurface" do
    url "https://cern.ch/geant4-data/datasets/G4RealSurface.2.2.tar.gz"
    sha256 "9954dee0012f5331267f783690e912e72db5bf52ea9babecd12ea22282176820"
  end

  resource "G4TENDL" do
    url "https://cern.ch/geant4-data/datasets/G4TENDL.1.3.2.tar.gz"
    sha256 "4fb57b9c1ae475726da93992f373dc33e8d22f30d555afc1a42575ac25053b44"
  end

  def install
    mkdir "geant-build" do
      args = std_cmake_args + %w[
        ../
        -DCMAKE_PREFIX_PATH=/usr/local/Cellar/qt@5//5.15.2/lib/cmake/
        -DGEANT4_USE_GDML=ON
        -DGEANT4_BUILD_MULTITHREADED=ON
        -DGEANT4_USE_QT=ON
      ]

      system "cmake", *args
      system "make", "install"
    end

    resources.each do |r|
      (share/"Geant4-#{version}/data/#{r.name}#{r.version}").install r
    end
  end

  def caveats
    <<~EOS
      Because Geant4 expects a set of environment variables for
      datafiles, you should source:
        . #{HOMEBREW_PREFIX}/bin/geant4.sh (or .csh)
      before running an application built with Geant4.
    EOS
  end

  test do
    system "cmake", share/"Geant4-#{version}/examples/basic/B1"
    system "make"
    (testpath/"test.sh").write <<~EOS
      . #{bin}/geant4.sh
      ./exampleB1 run2.mac
    EOS
    assert_match "Number of events processed : 1000",
                 shell_output("/bin/bash test.sh")
  end
end
