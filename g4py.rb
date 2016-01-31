 require 'formula'
 
 class G4py < Formula
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.02.tar.gz"
  version "4.10.02"
  sha256 "633ca2df88b03ba818c7eb09ba21d0667a94e342f7d6d6ff3c695d83583b8aa3"

  depends_on "cmake" => :build
  depends_on "python" => :build
  depends_on "geant4" => :build
  depends_on "root6" => :build
  
  depends_on "xerces-c"
  
  def install
    system "export G4INSTALL=/usr/local/Cellar/geant4/4.10.02/"
    system "cd", "environments/g4py"
    system "mkdir", "build" 
    system "cmake", "../" 
    system "make", "install"
  end 
end
