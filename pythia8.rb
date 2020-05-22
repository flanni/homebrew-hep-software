require 'formula'

class Pythia8 < Formula
  
  desc "Pythia 8.302"
  homepage "http://pythia8.hepforge.org"
  url "http://home.thep.lu.se/~torbjorn/pythia8/pythia8302.tgz"
  version "8.302"
  sha256 "7372e4cc6f48a074e6b7bc426b040f218ec4a64b0a55e89da6af56933b5f5085"


  depends_on 'hepmc3'
  depends_on 'lhapdf'
  depends_on 'boost'
  depends_on 'fastjet'
  

  patch :DATA
  
  def install
    ENV['PATH']="/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"    
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-fastjet3=#{Formula['fastjet'].opt_prefix}
      --with-hepmc3=#{Formula['hepmc3'].opt_prefix}
      --with-lhapdf6=#{Formula['lhapdf'].opt_prefix}
      --with-boost=#{Formula['boost'].opt_prefix}
      --with-python=#{Formula['python'].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"

    prefix.install 'examples'

  end

  test do
    ENV['PYTHIA8DATA'] = "#{prefix}/xmldoc"

    system "make -C #{prefix}/examples/ main01"
    system "#{prefix}/examples/main01.exe"
    system "make -C #{prefix}/examples/ main41"
    system "#{prefix}/examples/main41.exe"
  end
end
__END__
diff --git a/Makefile b/Makefile
--- a/Makefile	
+++ b/Makefile	
@@ -64,8 +64,9 @@
 endif
 
 # Python.
-PYTHON_COMMON=-I$(PYTHON_INCLUDE) $(CXX_COMMON) -Wl,-rpath,$(PREFIX_LIB)
+PYTHON_COMMON = ""
 ifeq ($(PYTHON_USE),true)
+  PYTHON_COMMON=-I$(PYTHON_INCLUDE) $(CXX_COMMON) -Wl,-rpath,$(PREFIX_LIB)
   TARGETS+=$(LOCAL_LIB)/_pythia8.so
 endif
 
@@ -118,12 +119,12 @@
 	$(CXX) -x c++ $< -o $@ -c -MD -w $(CXX_LHAPDF)
 $(LOCAL_LIB)/libpythia8lhapdf5.so: $(LOCAL_TMP)/LHAPDF5Plugin.o\
 	$(LOCAL_LIB)/libpythia8.a
-	$(CXX) $^ -o $@ $(CXX_COMMON) $(CXX_SHARED) $(CXX_SONAME)$(notdir $@)\
+	$(CXX) $^ -o $@ $(CXX_COMMON) -w $(PYTHON_COMMON) $(CXX_SHARED) $(CXX_SONAME)$(notdir $@)\
 	 -L$(LHAPDF5_LIB) -Wl,-rpath,$(LHAPDF5_LIB) -lLHAPDF -lgfortran
 $(LOCAL_LIB)/libpythia8lhapdf6.so: $(LOCAL_TMP)/LHAPDF6Plugin.o\
 	$(LOCAL_LIB)/libpythia8.a
-	$(CXX) $^ -o $@ $(CXX_COMMON) $(CXX_SHARED) $(CXX_SONAME)$(notdir $@)\
-	 -L$(LHAPDF6_LIB) -Wl,-rpath,$(LHAPDF6_LIB) -lLHAPDF
+	$(CXX) $^ -o $@ $(CXX_COMMON) -w $(PYTHON_COMMON) $(CXX_SHARED) $(CXX_SONAME)$(notdir $@)\
+	 	-L$(LHAPDF6_LIB) -Wl,-rpath,$(LHAPDF6_LIB) -lLHAPDF
 
 # POWHEG (exclude any executable ending with sh).
 $(LOCAL_TMP)/POWHEGPlugin.o: $(LOCAL_INCLUDE)/Pythia8Plugins/LHAPowheg.h
@@ -139,7 +140,7 @@
 $(LOCAL_LIB)/pythia8.py: $(LOCAL_INCLUDE)/Pythia8Plugins/PythonWrapper.h
 	SPLIT=`grep -n "PYTHON SOURCE" $< | cut -d : -f 1`;\
 	 SPLIT=$$[$$SPLIT+1]; tail -n +$$SPLIT $< | cut -d "/" -f 3- > $@
-	$(PYTHON_BIN)python -m compileall $(LOCAL_LIB)
+	$(PYTHON_BIN)/python -m compileall $(LOCAL_LIB)
 $(LOCAL_LIB)/_pythia8.so: $(LOCAL_INCLUDE)/Pythia8Plugins/PythonWrapper.h\
 	$(LOCAL_LIB)/pythia8.py $(wildcard $(LOCAL_INCLUDE)/*/*.h) |\
 	$(LOCAL_LIB)/libpythia8$(LIB_SUFFIX)
