require 'formula'

class Geant4 < Formula
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.02.tar.gz"
  version "4.10.02"
  sha256 "633ca2df88b03ba818c7eb09ba21d0667a94e342f7d6d6ff3c695d83583b8aa3"
  
  option "with-g3tog4", "Use G3toG4 Library"
  option "with-notimeout", "Set notimeout in installing data"

  depends_on "cmake" => :build
  depends_on :x11
  depends_on "clhep"
  depends_on "qt" => :optional
  depends_on "xerces-c" 
  
  # patch :p0 do
  #   url "https://github.com/flanni/homebrew-hep-software/geant4_cmake_modules_findclhep.diff"
  #   sha256 "333e842d040ed25d209feb76e03ff60ec90ed4760f7636d3133c4d5a911efd61" 
  # end
  
  def patches
    DATA
  end
  
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
        -DGEANT4_USE_GDML=ON
      ]

      args << "-DGEANT4_INSTALL_DATA_TIMEOUT=86400" if build.with? "notimeout"
      args << "-DGEANT4_USE_QT=ON" if build.with? "qt"
      args << "-DGEANT4_USE_G3TOG4=ON" if build.with? "g3tog4"
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"
      system "export G4INSTALL=/usr/local/Cellar/geant4/4.10.02/"
      system "cd ../environments/g4py; mkdir build; cd build; cmake ../; make install"
    end
  end
end

__END__
--- geant4.10.02/cmake/Modules/FindCLHEP.cmake.orig     2016-01-31 10:12:58.000000000 +0100
+++ geant4.10.02/cmake/Modules/FindCLHEP.cmake  2016-01-31 10:14:15.000000000 +0100
@@ -205,7 +205,7 @@
 if(CLHEP_INCLUDE_DIR)
     set(CLHEP_VERSION 0)
     file(READ "${CLHEP_INCLUDE_DIR}/CLHEP/Units/defs.h" _CLHEP_DEFS_CONTENTS)
-    string(REGEX REPLACE ".*#define PACKAGE_VERSION \"([0-9.]+).*" "\\1"
+    string(REGEX REPLACE ".*#define CLHEP_UNITS_VERSION \"([0-9.]+).*" "\\1"
         CLHEP_VERSION "${_CLHEP_DEFS_CONTENTS}")
 
     if(NOT CLHEP_FIND_QUIETLY)

