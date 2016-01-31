require 'formula'

class Geant4 < Formula
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.02.tar.gz"
  version "4.10.02"
  sha256 "633ca2df88b03ba818c7eb09ba21d0667a94e342f7d6d6ff3c695d83583b8aa3"
  
  option "with-g3tog4", "Use G3toG4 Library"
  option "with-gdml", "Use GDML"
  option "with-notimeout", "Set notimeout in installing data"

  depends_on "cmake" => :build
  depends_on :x11
  depends_on "clhep"
  depends_on "qt" => :optional
  depends_on "xerces-c" if build.with? "gdml"

  def install
    mkdir "geant-build" do
      args = %W[
        ../
        -DGEANT4_INSTALL_DATA=ON
        -DGEANT4_USE_OPENGL_X11=ON
        -DGEANT4_USE_RAYTRACER_X11=ON
        -DGEANT4_BUILD_EXAMPLE=ON
        -DGEANT4_USE_SYSTEM_CLHEP=ON
        -DGEANT4_BUILD_STORE_TRAJECTORY=ON
      ]

      args << "-DGEANT4_INSTALL_DATA_TIMEOUT=86400" if build.with? "notimeout"
      args << "-DGEANT4_USE_QT=ON" if build.with? "qt"
      args << "-DGEANT4_USE_G3TOG4=ON" if build.with? "g3tog4"
      args << "-DGEANT4_USE_GDML=ON" if build.with? "gdml"
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"
    end
  end
end
