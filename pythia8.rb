require 'formula'

class Pythia8 < Formula
  
  desc "Pythia 8.243"
  homepage "http://pythia8.hepforge.org"
  url "http://home.thep.lu.se/~torbjorn/pythia8/pythia8243.tgz"
  version "8.243"
  sha256 "f8ec27437d9c75302e192ab68929131a6fd642966fe66178dbe87da6da2b1c79"


  depends_on 'hepmc3'
  depends_on 'lhapdf'
  depends_on 'boost'
  depends_on 'fastjet'
  

  patch :DATA
  
  def install
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

  def caveats; <<-EOS.undent
    It is recommended to 'brew install sacrifice' now, as
    the easiest way to generate Pythia 8 events.

    Otherwise, programs can be built against the Pythia 8
    libraries by making use of 'pythia8-config'.

    EOS
  end
end
__END__
diff --git a/Makefile b/Makefile
--- a/Makefile	
+++ b/Makefile	
@@ -139,7 +139,7 @@
 $(LOCAL_LIB)/pythia8.py: $(LOCAL_INCLUDE)/Pythia8Plugins/PythonWrapper.h
 	SPLIT=`grep -n "PYTHON SOURCE" $< | cut -d : -f 1`;\
 	 SPLIT=$$[$$SPLIT+1]; tail -n +$$SPLIT $< | cut -d "/" -f 3- > $@
-	$(PYTHON_BIN)python -m compileall $(LOCAL_LIB)
+	$(PYTHON_BIN)/python -m compileall $(LOCAL_LIB)
 $(LOCAL_LIB)/_pythia8.so: $(LOCAL_INCLUDE)/Pythia8Plugins/PythonWrapper.h\
 	$(LOCAL_LIB)/pythia8.py $(wildcard $(LOCAL_INCLUDE)/*/*.h) |\
 	$(LOCAL_LIB)/libpythia8$(LIB_SUFFIX)
