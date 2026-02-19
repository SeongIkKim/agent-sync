class AgentSync < Formula
  desc "Unify AGENTS.md/CLAUDE.md/GEMINI.md/CODEX.md via symlinks"
  homepage "https://github.com/SeongIkKim/agent-sync"
  license "MIT"

  head "https://github.com/SeongIkKim/agent-sync.git", branch: "main"

  def install
    bin.install "scripts/bootstrap-agents.sh" => "agent-sync-bootstrap"
    bin.install "scripts/check-agents.sh" => "agent-sync-check"
    bin.install "scripts/install.sh" => "agent-sync-install"
    doc.install "README.md"
  end

  test do
    system bin/"agent-sync-bootstrap", testpath
    system bin/"agent-sync-check", testpath
  end
end
