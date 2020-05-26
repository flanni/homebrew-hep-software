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
  depends_on 'gnu-sed'

  patch :DATA
  
  def install
    ENV['PATH']="/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"    
    args = %W[
      --prefix=#{prefix}
      --with-fastjet3=#{Formula['fastjet'].opt_prefix}
      --with-hepmc3=#{Formula['hepmc3'].opt_prefix}
      --with-lhapdf6=#{Formula['lhapdf'].opt_prefix}
      --with-python-config="/Library/Frameworks/Python.framework/Versions/3.8/bin/python3.8-config"
      --with-python-bin="/Library/Frameworks/Python.framework/Versions/3.8/bin"
      --with-python-lib="/Library/Frameworks/Python.framework/Versions/3.8/lib"
      --with-python-include="/Library/Frameworks/Python.framework/Versions/3.8/include"
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
diff --git a/plugins/python/Makefile b/plugins/python/Makefile
--- a/plugins/python/Makefile	2020-05-24 14:59:40.000000000 +0200
+++ b/plugins/python/Makefile	2020-05-24 15:04:55.000000000 +0200
@@ -59,9 +59,8 @@
 # Build the headers.
 $(LOCAL_INCLUDE)/Pythia8%.h: $(TOP_INCLUDE)/Pythia8%.h
 	@mkdir -p $(dir $@)
-	@sed "s/protected:/public:/g" $< |\
-	 sed "s/\(const  *Info\& *info  *=  *infoPrivate;\)/\1\n  "\
-	"Info infoPython() {return Info(infoPrivate);}/g" > $@
+	@gsed "s/protected:/public:/g" $< |\
+	 gsed "s/\(const  *Info\& *info  *=  *infoPrivate;\)/\1\nInfo infoPython() {return Info(infoPrivate);}/g" > $@
 
 # Build the objects.
 $(LOCAL_TMP)/%.o: $(LOCAL_SRC)/%.cpp
