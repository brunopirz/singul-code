#!/usr/bin/env bash
# SingulCode — Script de instalação (Linux / macOS)
# Uso: curl -fsSL https://raw.githubusercontent.com/.../install.sh | bash
#      ou: ./install.sh
#      ou: ./install.sh --prefix /usr/local

set -euo pipefail

BINARY_NAME="singulcode"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUST_DIR="${REPO_DIR}/rust"

# ── Cores ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${CYAN}[singulcode]${NC} $*"; }
success() { echo -e "${GREEN}[singulcode]${NC} $*"; }
warn()    { echo -e "${YELLOW}[singulcode]${NC} $*"; }
error()   { echo -e "${RED}[singulcode]${NC} $*" >&2; exit 1; }

# ── Determinar diretório de instalação ───────────────────────────────────────
PREFIX="${SINGULCODE_PREFIX:-}"
if [[ -z "$PREFIX" ]]; then
    for arg in "$@"; do
        case "$arg" in
            --prefix=*) PREFIX="${arg#--prefix=}" ;;
            --prefix)   shift; PREFIX="${1:-}" ;;
        esac
    done
fi

if [[ -z "$PREFIX" ]]; then
    if [[ "$EUID" -eq 0 ]]; then
        INSTALL_DIR="/usr/local/bin"
    else
        INSTALL_DIR="${HOME}/.local/bin"
    fi
else
    INSTALL_DIR="${PREFIX}/bin"
fi

# ── Banner ───────────────────────────────────────────────────────────────────
echo -e "${BOLD}"
echo "  ╔═══════════════════════════════════╗"
echo "  ║        SingulCode Installer       ║"
echo "  ║   Harness de agentes de IA        ║"
echo "  ╚═══════════════════════════════════╝"
echo -e "${NC}"

# ── Verificar cargo ───────────────────────────────────────────────────────────
if ! command -v cargo &>/dev/null; then
    warn "cargo não encontrado. Instalando Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    # shellcheck source=/dev/null
    source "${HOME}/.cargo/env"
    if ! command -v cargo &>/dev/null; then
        error "Falha ao instalar Rust. Instale manualmente em https://rustup.rs e tente novamente."
    fi
    success "Rust instalado: $(cargo --version)"
else
    info "cargo encontrado: $(cargo --version)"
fi

# ── Build ─────────────────────────────────────────────────────────────────────
info "Compilando ${BINARY_NAME} em modo release..."
info "Isso pode levar alguns minutos na primeira vez."

if [[ ! -d "$RUST_DIR" ]]; then
    error "Diretório rust/ não encontrado em ${REPO_DIR}. Execute o script a partir da raiz do repositório."
fi

cd "$RUST_DIR"
cargo build --release --bin singulcode --bin singul 2>&1 | grep -v "^$" || error "Falha na compilação."

BUILT_BINARY="${RUST_DIR}/target/release/singulcode"
BUILT_ALIAS="${RUST_DIR}/target/release/singul"
if [[ ! -f "$BUILT_BINARY" ]]; then
    error "Binário não encontrado em ${BUILT_BINARY} após compilação."
fi

success "Build concluído: ${BUILT_BINARY}"

# ── Instalar ──────────────────────────────────────────────────────────────────
mkdir -p "$INSTALL_DIR"
install -m 755 "$BUILT_BINARY" "${INSTALL_DIR}/singulcode"
install -m 755 "$BUILT_ALIAS" "${INSTALL_DIR}/singul"
success "Instalado em ${INSTALL_DIR}/singulcode e ${INSTALL_DIR}/singul"

# ── Verificar PATH ────────────────────────────────────────────────────────────
if [[ ":${PATH}:" != *":${INSTALL_DIR}:"* ]]; then
    warn "${INSTALL_DIR} não está no seu PATH."
    echo ""
    echo "  Adicione ao seu shell profile (~/.bashrc, ~/.zshrc, etc.):"
    echo -e "  ${BOLD}export PATH=\"\$PATH:${INSTALL_DIR}\"${NC}"
    echo ""
    echo "  Ou execute agora:"
    echo -e "  ${BOLD}export PATH=\"\$PATH:${INSTALL_DIR}\"${NC}"
fi

# ── Verificar instalação ──────────────────────────────────────────────────────
if command -v "singul" &>/dev/null; then
    echo ""
    success "singul instalado com sucesso!"
    echo ""
    echo -e "  ${BOLD}Próximos passos:${NC}"
    echo ""
    echo "  1. Configure sua chave de API:"
    echo -e "     ${CYAN}export ANTHROPIC_API_KEY=\"sk-ant-...\"${NC}"
    echo -e "     ${CYAN}# ou OpenRouter (200+ modelos):${NC}"
    echo -e "     ${CYAN}export OPENROUTER_API_KEY=\"sk-or-v1-...\"${NC}"
    echo ""
    echo "  2. Inicie o REPL interativo:"
    echo -e "     ${BOLD}singul${NC}"
    echo ""
    echo "  3. Ou use em modo não-interativo:"
    echo -e "     ${BOLD}singul prompt \"explique este código\"${NC}"
    echo ""
    echo "  4. Com modelo específico:"
    echo -e "     ${BOLD}singul --model deepseek prompt \"corrija o bug\"${NC}"
    echo ""
else
    echo ""
    warn "Instalação concluída, mas singul não está no PATH atual."
    echo "  Execute: export PATH=\"\$PATH:${INSTALL_DIR}\""
    echo "  Depois:  singul"
fi
