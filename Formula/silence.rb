class Silence < Formula
  desc "An educational framework for deploying APIs (based on a MySQL schema) and web applications."
  homepage "https://github.com/IISSI-US/SilenceEvolution"
  version "0.0.8"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.8/silence-aarch64-apple-darwin.tar.xz"
    sha256 "7428d23ebd61ebba5e94ed3c8c5ad26cc646526d6abfad5aa3b4a6e3fc805a0c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.8/silence-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d4efb116b22ad09de981d57252b77d61a64b1aceccacd6bbe45caea131f0c96d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/IISSI-US/SilenceEvolution/releases/download/0.0.8/silence-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ed1993c216a5b9e57e98512d9196d1d127484337d104c78b04b110e86642fdf2"
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
