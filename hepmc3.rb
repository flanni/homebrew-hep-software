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
    mkdir "../build" do
      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DHEPMC3_PYTHON_VERSIONS=3.X
      ]
      args<<"-DHEPMC3_ENABLE_TEST=ON" if build.with? "test"
      args<<"-DHEPMC3_ENABLE_ROOTIO=OFF" if build.without? "root"
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
__END__

diff -u python/cmake_install.cmake.orig python/cmake_install.cmake
--- python/cmake_install.cmake.orig	
+++ python/cmake_install.cmake	
@@ -45,9 +45,6 @@
   if(EXISTS "$ENV{DESTDIR}/Library/Frameworks/Python.framework/Versions/3.8/lib/python3.8/site-packages/pyHepMC3/pyHepMC3.so" AND
      NOT IS_SYMLINK "$ENV{DESTDIR}/Library/Frameworks/Python.framework/Versions/3.8/lib/python3.8/site-packages/pyHepMC3/pyHepMC3.so")
     execute_process(COMMAND /usr/bin/install_name_tool
-      -delete_rpath "/Users/flanni/Tests/HepMC3-3.2.1/outputs/lib"
-      "$ENV{DESTDIR}/Library/Frameworks/Python.framework/Versions/3.8/lib/python3.8/site-packages/pyHepMC3/pyHepMC3.so")
-    execute_process(COMMAND /usr/bin/install_name_tool
       -add_rpath "/usr/local/Cellar/hepmc/3.2.1/lib"
       "$ENV{DESTDIR}/Library/Frameworks/Python.framework/Versions/3.8/lib/python3.8/site-packages/pyHepMC3/pyHepMC3.so")
     if(CMAKE_INSTALL_DO_STRIP)
@@ -93,9 +90,6 @@
   if(EXISTS "$ENV{DESTDIR}/Library/Frameworks/Python.framework/Versions/3.8/lib/python3.8/site-packages/pyHepMC3/search/pyHepMC3search.so" AND
      NOT IS_SYMLINK "$ENV{DESTDIR}/Library/Frameworks/Python.framework/Versions/3.8/lib/python3.8/site-packages/pyHepMC3/search/pyHepMC3search.so")
     execute_process(COMMAND /usr/bin/install_name_tool
-      -delete_rpath "/Users/flanni/Tests/HepMC3-3.2.1/outputs/lib"
-      "$ENV{DESTDIR}/Library/Frameworks/Python.framework/Versions/3.8/lib/python3.8/site-packages/pyHepMC3/search/pyHepMC3search.so")
-    execute_process(COMMAND /usr/bin/install_name_tool
       -add_rpath "/usr/local/Cellar/hepmc/3.2.1/lib"
       "$ENV{DESTDIR}/Library/Frameworks/Python.framework/Versions/3.8/lib/python3.8/site-packages/pyHepMC3/search/pyHepMC3search.so")
     if(CMAKE_INSTALL_DO_STRIP)
__END__
diff -u search/cmake_install.cmake.orig search/cmake_install.cmake
--- search/cmake_install.cmake.orig	2020-05-24 12:17:57.000000000 +0200
+++ search/cmake_install.cmake	2020-05-24 12:19:02.000000000 +0200
@@ -37,9 +37,6 @@
   if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libHepMC3search.3.dylib" AND
      NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libHepMC3search.3.dylib")
     execute_process(COMMAND /usr/bin/install_name_tool
-      -delete_rpath "/Users/flanni/Tests/HepMC3-3.2.1/outputs/lib"
-      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libHepMC3search.3.dylib")
-    execute_process(COMMAND /usr/bin/install_name_tool
       -add_rpath "/usr/local/Cellar/hepmc/3.2.1/lib"
       "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libHepMC3search.3.dylib")
     if(CMAKE_INSTALL_DO_STRIP)
@@ -53,9 +50,6 @@
   if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libHepMC3search.dylib" AND
      NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libHepMC3search.dylib")
     execute_process(COMMAND /usr/bin/install_name_tool
-      -delete_rpath "/Users/flanni/Tests/HepMC3-3.2.1/outputs/lib"
-      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libHepMC3search.dylib")
-    execute_process(COMMAND /usr/bin/install_name_tool
       -add_rpath "/usr/local/Cellar/hepmc/3.2.1/lib"
       "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libHepMC3search.dylib")
     if(CMAKE_INSTALL_DO_STRIP)
