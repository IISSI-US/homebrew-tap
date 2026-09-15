class Silence < Formula
  desc "An educational framework for deploying APIs (based on a MySQL schema) and web applications."
  homepage "https://github.com/IISSI-US/SilenceEvolution"
  version "0.0.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.6/silence-aarch64-apple-darwin.tar.xz"
    sha256 "63b181dc48ea0d16cfa4674c0f17f79a7a7292b68e6454ae14029e1d63269ebe"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.6/silence-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "743e3a06a1460ff1b85bfef3f0e4538ea9f4085e33ae95ed14ffcd220f07927c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.6/silence-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b15d1d8e40943da2b3a670d725c92f316e098b3fcf9a00aedfef88d88a73beb2"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":       {},
    "aarch64-pc-windows-gnu":     {},
    "aarch64-pc-windows-gnullvm": {},
    "aarch64-unknown-linux-gnu":  {},
    "x86_64-pc-windows-gnu":      {},
    "x86_64-unknown-linux-gnu":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "silence"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "silence"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "silence"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
