class Silence < Formula
  desc "An educational framework for deploying APIs (based on a MySQL schema) and web applications."
  homepage "https://github.com/IISSI-US/SilenceEvolution"
  version "0.0.9"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.9/silence-aarch64-apple-darwin.tar.xz"
    sha256 "4c2e28bc17b9b5c526b1974e4ef5564f70d4f57de18ddcfbf27ac2af6305f4b0"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.9/silence-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a99fd163d0415a920c6473cd9ecc5d42334ae183d2108a8498153fbff838509b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.9/silence-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0e546981e95bc011de3a4696f869b7059a20ca08da9b2797004ad89e85784424"
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
