class Silence < Formula
  desc "An educational framework for deploying APIs (based on a MySQL schema) and web applications."
  homepage "https://github.com/IISSI-US/SilenceEvolution"
  version "0.0.11"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.11/silence-aarch64-apple-darwin.tar.xz"
    sha256 "43af5efdf81574cf31b57f3862527092682fbdc7e34744bb04d3e4ba1caa9631"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.11/silence-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e7be014199f859ca0eba177b737691cd9841f992592cff2ae22e93be1e685940"
    end
    if Hardware::CPU.intel?
      url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.11/silence-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "edbf066c2b7bd889fe8e2868b8a056a6426b45612fc6f6f01c8d218fb648dbfd"
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
