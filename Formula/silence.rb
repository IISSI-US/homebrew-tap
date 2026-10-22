class Silence < Formula
  desc "An educational framework for deploying APIs (based on a MySQL schema) and web applications."
  homepage "https://github.com/IISSI-US/SilenceEvolution"
  version "0.0.12"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.12/silence-aarch64-apple-darwin.tar.xz"
    sha256 "e6d13e96db053997cb2ec09769ab22b065fbfa974c1a448633bf9cd5229b0662"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.12/silence-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e0fec3f1535e3c72e5cc821e87fe6363218e20da2001101e66214d5c116cb01e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.12/silence-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2b48d7e326c3d579fa3bfbe2874d67b750c957b889f9b4a6701cdf256c15fd0"
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
