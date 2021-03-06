class Dialog < Formula
  desc "Display user-friendly dialog boxes from shell scripts"
  homepage "http://invisible-island.net/dialog/"
  url "ftp://invisible-island.net/dialog/dialog-1.3-20160209.tgz"
  mirror "https://fossies.org/linux/misc/dialog-1.3-20160209.tgz"
  sha256 "0314f7f2195edc58e7567a024dc1d658c2f8ea732796d8fa4b4927df49803f87"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee630bb7ae15cde86a4dd48a598b5eaf1151237bef9e0f1ffa9a120cc5fbd9ac" => :sierra
    sha256 "8c12527b91df19529a580ff081621d30514119bfd999f76a763d59c406b32531" => :el_capitan
    sha256 "89a8a52b64df7abe4aabfa9de1aa62523098154ae447da57fab3adce18b34a29" => :yosemite
    sha256 "74626b6e18ebd0b4b755e04457be5a385bc10745cf08130f1330ab2b108a0550" => :mavericks
    sha256 "d05a67d2bc4aba6c599249ea8937222b75d1ff606522d218643fcbba72ba20c5" => :x86_64_linux
  end

  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
