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
  def patches
    DATA
  end
  
  def install
    system "export GEANT4_INSTALL=/usr/local/Cellar/geant4/4.10.02/"
    system "cd", "environments/g4py"
    system "mkdir", "g4py-build" 
    system "ls"
    system "cd", "g4py-build"
    system "cmake", "../" 
    system "cd", "g4py-build"
    system "make", "install"
  end 
end

def caveats
 "Python wrapper for Geant 4. It assumes Geant4 formula from this tap, which is built with system CLHEP"
end

__END__
--- geant4.10.02/environments/g4py/CMakeLists.txt.orig	2016-01-31 16:07:34.000000000 +0100
+++ geant4.10.02/environments/g4py/CMakeLists.txt	2016-01-31 16:07:50.000000000 +0100
@@ -27,6 +27,7 @@
 find_package(Geant4 REQUIRED)
 find_package(PythonInterp REQUIRED)
 find_package(PythonLibs REQUIRED)
+find_package(CLHEP)
 find_package(Boost)
 find_package(XercesC)
 find_package(ROOT)
--- geant4.10.02/environments/g4py/examples/demos/TestEm0/module/CMakeLists.txt.orig	2016-01-31 17:32:34.000000000 +0100
+++ geant4.10.02/environments/g4py/examples/demos/TestEm0/module/CMakeLists.txt	2016-01-31 17:32:57.000000000 +0100
@@ -6,7 +6,7 @@
   ${GEANT4_INCLUDE_DIR}
 )
 
-link_directories (${GEANT4_LIBRARY_DIR} ${Boost_LIBRARY_DIRS})
+link_directories (${GEANT4_LIBRARY_DIR} ${Boost_LIBRARY_DIRS} ${CLHEP_LIBRARY_DIR} )
 
 # library
 set(_TARGET testem0)
@@ -28,7 +28,7 @@
 
 target_link_libraries (${_TARGET}
                        ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                       ${PYTHON_LIBRARIES})
+                       ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${TEST_MODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/examples/demos/water_phantom/module/CMakeLists.txt.orig	2016-01-31 17:33:11.000000000 +0100
+++ geant4.10.02/environments/g4py/examples/demos/water_phantom/module/CMakeLists.txt	2016-01-31 17:33:30.000000000 +0100
@@ -6,7 +6,7 @@
   ${GEANT4_INCLUDE_DIR}
 )
 
-link_directories (${GEANT4_LIBRARY_DIR} ${Boost_LIBRARY_DIRS})
+link_directories (${GEANT4_LIBRARY_DIR} ${Boost_LIBRARY_DIRS} ${CLHEP_LIBRARY_DIR})
 
 # library
 set(_TARGET demo_wp)
@@ -23,7 +23,7 @@
 
 target_link_libraries (${_TARGET}
                        ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                       ${PYTHON_LIBRARIES})
+                       ${PYTHON_LIBRARIES} ${CHLEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${TEST_MODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/site-modules/geometries/ExN01geom/CMakeLists.txt.orig	2016-01-31 17:22:31.000000000 +0100
+++ geant4.10.02/environments/g4py/site-modules/geometries/ExN01geom/CMakeLists.txt	2016-01-31 17:22:42.000000000 +0100
@@ -17,7 +17,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4SITEMODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/site-modules/geometries/ExN03geom/CMakeLists.txt.orig	2016-01-31 17:22:55.000000000 +0100
+++ geant4.10.02/environments/g4py/site-modules/geometries/ExN03geom/CMakeLists.txt	2016-01-31 17:23:09.000000000 +0100
@@ -18,7 +18,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4SITEMODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/site-modules/geometries/ezgeom/CMakeLists.txt.orig	2016-01-31 17:24:19.000000000 +0100
+++ geant4.10.02/environments/g4py/site-modules/geometries/ezgeom/CMakeLists.txt	2016-01-31 17:24:30.000000000 +0100
@@ -20,7 +20,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4SITEMODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/site-modules/geometries/Qgeom/CMakeLists.txt.orig	2016-01-31 17:23:59.000000000 +0100
+++ geant4.10.02/environments/g4py/site-modules/geometries/Qgeom/CMakeLists.txt	2016-01-31 17:24:11.000000000 +0100
@@ -17,7 +17,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4SITEMODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/site-modules/physics_lists/EMSTDpl/CMakeLists.txt.orig	2016-01-31 17:26:08.000000000 +0100
+++ geant4.10.02/environments/g4py/site-modules/physics_lists/EMSTDpl/CMakeLists.txt	2016-01-31 17:26:18.000000000 +0100
@@ -17,7 +17,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4SITEMODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/site-modules/physics_lists/ExN01pl/CMakeLists.txt.orig	2016-01-31 17:26:28.000000000 +0100
+++ geant4.10.02/environments/g4py/site-modules/physics_lists/ExN01pl/CMakeLists.txt	2016-01-31 17:26:38.000000000 +0100
@@ -17,7 +17,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4SITEMODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/site-modules/physics_lists/ExN03pl/CMakeLists.txt.orig	2016-01-31 17:26:47.000000000 +0100
+++ geant4.10.02/environments/g4py/site-modules/physics_lists/ExN03pl/CMakeLists.txt	2016-01-31 17:26:58.000000000 +0100
@@ -17,7 +17,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4SITEMODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/site-modules/primaries/MedicalBeam/CMakeLists.txt.orig	2016-01-31 17:28:10.000000000 +0100
+++ geant4.10.02/environments/g4py/site-modules/primaries/MedicalBeam/CMakeLists.txt	2016-01-31 17:28:21.000000000 +0100
@@ -17,7 +17,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4SITEMODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/source/CMakeLists.txt.orig	2016-01-31 17:20:58.000000000 +0100
+++ geant4.10.02/environments/g4py/source/CMakeLists.txt	2016-01-31 17:21:13.000000000 +0100
@@ -9,7 +9,7 @@
   ${GEANT4_INCLUDE_DIR}
 )
 
-link_directories (${GEANT4_LIBRARY_DIR} ${Boost_LIBRARY_DIRS})
+link_directories (${GEANT4_LIBRARY_DIR} ${Boost_LIBRARY_DIRS} ${CLHEP_LIBRARY_DIR})
 
 add_subdirectory(global)
 add_subdirectory(interface)
--- geant4.10.02/environments/g4py/source/event/CMakeLists.txt.orig	2016-01-31 16:45:11.000000000 +0100
+++ geant4.10.02/environments/g4py/source/event/CMakeLists.txt	2016-01-31 16:45:26.000000000 +0100
@@ -24,7 +24,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4MODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/source/global/CMakeLists.txt.orig	2016-01-31 16:37:31.000000000 +0100
+++ geant4.10.02/environments/g4py/source/global/CMakeLists.txt	2016-01-31 16:37:47.000000000 +0100
@@ -37,7 +37,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4MODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/source/particles/CMakeLists.txt.orig	2016-01-31 17:05:01.000000000 +0100
+++ geant4.10.02/environments/g4py/source/particles/CMakeLists.txt	2016-01-31 17:05:16.000000000 +0100
@@ -24,7 +24,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4MODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/source/physics_lists/CMakeLists.txt.orig	2016-01-31 17:11:19.000000000 +0100
+++ geant4.10.02/environments/g4py/source/physics_lists/CMakeLists.txt	2016-01-31 17:11:31.000000000 +0100
@@ -18,7 +18,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4MODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/source/processes/CMakeLists.txt.orig	2016-01-31 17:07:39.000000000 +0100
+++ geant4.10.02/environments/g4py/source/processes/CMakeLists.txt	2016-01-31 17:08:04.000000000 +0100
@@ -27,7 +27,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4MODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/source/run/CMakeLists.txt.orig	2016-01-31 16:43:01.000000000 +0100
+++ geant4.10.02/environments/g4py/source/run/CMakeLists.txt	2016-01-31 16:43:16.000000000 +0100
@@ -26,7 +26,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4MODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/source/track/CMakeLists.txt.orig	2016-01-31 16:57:59.000000000 +0100
+++ geant4.10.02/environments/g4py/source/track/CMakeLists.txt	2016-01-31 16:58:13.000000000 +0100
@@ -22,7 +22,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES})
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4MODULES_INSTALL_DIR})
--- geant4.10.02/environments/g4py/source/tracking/CMakeLists.txt.orig	2016-01-31 16:47:22.000000000 +0100
+++ geant4.10.02/environments/g4py/source/tracking/CMakeLists.txt	2016-01-31 16:56:13.000000000 +0100
@@ -20,7 +20,7 @@
 
 target_link_libraries (${_TARGET}
                       ${GEANT4_LIBRARIES_WITH_VIS} boost_python
-                      ${PYTHON_LIBRARIES})
+                      ${PYTHON_LIBRARIES} ${CLHEP_LIBRARIES} )
 
 # install
 install(TARGETS ${_TARGET} LIBRARY DESTINATION ${G4MODULES_INSTALL_DIR})
 
