class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://www.lysator.liu.se/~nisse/archive/nettle-3.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/nettle/nettle-3.2.tar.gz"
  sha256 "ea4283def236413edab5a4cf9cf32adf540c8df1b9b67641cfc2302fca849d97"

  bottle do
    cellar :any
    sha256 "803e13bba9403f8ad4362263d279242c5f86f8c7ad2b215fbebb9c0a27c86138" => :sierra
    sha256 "149db1957c10656b05dd887d70ec699dc5e3776790fd2208a37b3a6fafa47f66" => :el_capitan
    sha256 "9d26a23ec1699a09d84dba677eba18944f9c7480e2061b36bb4c8ec2bca13a9e" => :yosemite
    sha256 "f86d2cf88360585545fb7309c8d631717801d90ecdfd9fdaf094aff32f4829f5" => :mavericks
    sha256 "826ee800cfeebdf799c40036c7da4636e1a8cb5a25312a184bbb9e3c2fd21179" => :x86_64_linux
  end

  depends_on "gmp"
  depends_on "homebrew/dupes/m4" => :build unless OS.mac?

  def install
    # OS X doesn't use .so libs. Emailed upstream 04/02/2016.
    inreplace "testsuite/dlopen-test.c", "libnettle.so", "libnettle.dylib" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "install"
    system "make", "check"

    # Move lib64/* to lib/ on Linuxbrew
    lib64 = Pathname.new "#{lib}64"
    if lib64.directory?
      mkdir_p lib
      system "mv #{lib64}/* #{lib}/"
      rmdir lib64
      inreplace Dir[lib/"pkgconfig/*"], "/lib64", "/lib"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <nettle/sha1.h>
      #include <stdio.h>

      int main()
      {
        struct sha1_ctx ctx;
        uint8_t digest[SHA1_DIGEST_SIZE];
        unsigned i;

        sha1_init(&ctx);
        sha1_update(&ctx, 4, "test");
        sha1_digest(&ctx, SHA1_DIGEST_SIZE, digest);

        printf("SHA1(test)=");

        for (i = 0; i<SHA1_DIGEST_SIZE; i++)
          printf("%02x", digest[i]);

        printf("\\n");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lnettle", "-o", "test"
    system "./test"
  end
end
