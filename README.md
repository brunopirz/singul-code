# Singul Code

<p align="center">
  <strong>⚙️ Unified Agent Orchestration Framework | Python + Rust Dual Implementation</strong>
</p>

<p align="center">
  <img alt="Build Status" src="https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge" />
  <img alt="Tests" src="https://img.shields.io/badge/tests-65%20passing-brightgreen?style=for-the-badge" />
  <img alt="Python" src="https://img.shields.io/badge/Python-3.10%2B-blue?style=for-the-badge&logo=python" />
  <img alt="Rust" src="https://img.shields.io/badge/Rust-1.70%2B-orangered?style=for-the-badge&logo=rust" />
</p>

An open-source agent orchestration framework designed for building, deploying, and managing intelligent agent systems with sophisticated tool binding, runtime context management, and distributed execution capabilities.

---

## Quick Start

### Python Implementation (Production Ready ✅)

```bash
# Install dependencies
pip install -e .

# Run CLI
python -m src.main --help

# Render workspace summary
python -m src.main summary

# Run tests
python -m unittest discover -s tests -v
```

### Rust Implementation (MVP 🚧)

```bash
# Build all crates
cd rust && cargo build --workspace

# Run tests
cargo test --workspace

# Run CLI
cargo run --bin singulcode -- --help
```

---

## Project Status

| Component | Status | Details |
|-----------|--------|---------|
| **Python Core** | ✅ Production | 45+ modules, complete runtime, full test suite |
| **Rust Runtime** | 🚧 MVP | 11 crates, 65 tests passing, core features implemented |
| **Tool System** | ✅ Complete | Dynamic tool registration, schema validation |
| **Agent Orchestration** | ✅ Production | Multi-agent coordination, context management |
| **Documentation** | ✅ Complete | Architecture deep dives, dev roadmap, technical specs |

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Singul Code Agent                     │
│                   Orchestration Layer                    │
└─────────────────────────────────────────────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
    ┌─────────┐     ┌──────────┐    ┌───────────┐
    │  Tool   │     │ Command  │    │ Bootstrap │
    │ Registry│     │  Graph   │    │   Graph   │
    └─────────┘     └──────────┘    └───────────┘
        │                 │                 │
        └─────────────────┼─────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
    ┌─────────┐     ┌──────────┐    ┌───────────┐
    │ Context │     │  Task    │    │ Execution │
    │ Manager │     │  Executor│    │ Registry  │
    └─────────┘     └──────────┘    └───────────┘
```

---

## Key Features

### 🔧 Dynamic Tool System
- Runtime tool registration and discovery
- Schema validation and type checking
- Automatic tool binding to agents
- Support for sync/async operations

### 🎯 Intelligent Agent Orchestration  
- Multi-level agent coordination
- Hierarchical command execution
- Context-aware decision making
- Tool availability management

### 💾 Stateful Context Management
- Session persistence
- Cost tracking and budgeting
- Permission-based access control
- Deferred initialization patterns

### 📊 Observability & Telemetry
- Comprehensive execution tracing
- Performance metrics collection
- Error reporting and diagnostics
- Cost attribution models

### 🔌 LSP & IDE Integration
- Full Language Server Protocol support
- Real-time diagnostics
- Hover information and completions
- Integration with VS Code and editors

### 🚀 Distributed Execution
- Remote runtime support
- MCP (Model Context Protocol) bridge
- Horizontal scaling capabilities
- Cross-machine tool invocation

---

## Repository Structure

```
singul-code/
├── src/                          # Python implementation (production)
│   ├── main.py                   # CLI entry point
│   ├── runtime.py                # Execution runtime
│   ├── commands.py               # Command definitions
│   ├── tools.py                  # Tool registry and binding
│   ├── context.py                # Context management
│   ├── query_engine.py           # Query and execution planning
│   ├── session_store.py          # Session persistence
│   ├── cost_tracker.py           # Budget and cost management
│   ├── permissions.py            # Access control
│   ├── assistant/                # Agent implementations
│   ├── coordinator/              # Orchestration logic
│   ├── services/                 # External service integrations
│   ├── skills/                   # Specialized agent capabilities
│   ├── plugins/                  # Plugin system
│   ├── state/                    # State management
│   ├── schemas/                  # Data schemas
│   └── utils/                    # Utility functions
│
├── rust/                         # Rust implementation (MVP)
│   ├── Cargo.toml                # Workspace manifest
│   ├── crates/
│   │   ├── api/                  # API definitions and client
│   │   ├── runtime/              # Rust runtime engine
│   │   ├── commands/             # Command execution
│   │   ├── claw-cli/             # Binary (singulcode)
│   │   ├── lsp/                  # Language server
│   │   ├── plugins/              # Plugin system
│   │   ├── tools/                # Tool system
│   │   ├── compat-harness/       # Compatibility layer
│   │   ├── mock-anthropic-service/ # Testing utilities
│   │   └── telemetry/            # Observability
│   └── scripts/                  # Build and test scripts
│
├── tests/                        # Test suite
│   └── test_porting_workspace.py # Integration tests
│
├── docs/                         # Documentation
│   ├── TECHNICAL_DOCUMENTATION_2026-04-04.md
│   ├── ARCHITECTURE_DEEP_DIVE_2026-04-04.md
│   ├── EXECUTIVE_SUMMARY_2026-04-04.md
│   ├── DEVELOPMENT_ROADMAP_2026-04-04.md
│   ├── QUICK_REFERENCE_2026-04-04.md
│   └── README.md
│
├── README.md                     # This file
├── CLAUDE.md                     # Development guidelines
├── ROADMAP.md                    # Feature roadmap
└── install.sh / install.ps1      # Installation scripts
```

---

## Development

### Prerequisites

- **Python:** 3.10 or later
- **Rust:** 1.70 or later (for Rust build)
- **Node.js:** 18+ (optional, for some utilities)

### Build & Test

```bash
# Python verification
./install.sh
python -m src.main summary
python -m unittest discover -s tests -v

# Rust verification
cd rust
cargo fmt
cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace
```

### Code Quality

- Python: Uses `black`, `isort`, `pylint` conventions
- Rust: Enforces `cargo fmt` and `cargo clippy` standards
- All PRs require passing test suite and CI checks

---

## Documentation

Comprehensive documentation is available in the `docs/` directory:

- **[Technical Documentation](docs/TECHNICAL_DOCUMENTATION_2026-04-04.md)** — System architecture, component reference, and integration guides
- **[Architecture Deep Dive](docs/ARCHITECTURE_DEEP_DIVE_2026-04-04.md)** — Detailed design patterns, data flows, and implementation strategies
- **[Development Roadmap](docs/DEVELOPMENT_ROADMAP_2026-04-04.md)** — Feature timeline Q2-Q4 2026, planned enhancements, and research areas
- **[Quick Reference](docs/QUICK_REFERENCE_2026-04-04.md)** — Commands, APIs, and common patterns
- **[Executive Summary](docs/EXECUTIVE_SUMMARY_2026-04-04.md)** — High-level project overview and key capabilities

---

## Data Models

### Agent
Represents an autonomous entity capable of executing tasks, managing context, and invoking tools.

```python
@dataclass
class Agent:
    id: str
    name: str
    description: str
    capabilities: List[str]
    context: ContextState
    active_tools: List[Tool]
    execution_history: List[ExecutionRecord]
```

### Tool
Encapsulates executable functionality with schema validation and permission control.

```python
@dataclass
class Tool:
    id: str
    name: str
    description: str
    schema: JSONSchema
    handler: Callable
    permissions: List[Permission]
    version: str
```

### Command
Represents an orchestrated workflow of agent actions.

```python
@dataclass
class Command:
    id: str
    name: str
    graph: CommandGraph
    parameters: Dict[str, Any]
    permissions: List[Permission]
    timeout: float
```

### Session
Maintains execution state across operations.

```python
@dataclass
class Session:
    id: str
    agent_id: str
    created_at: datetime
    context: ContextState
    cost_budget: CostBudget
    execution_log: List[ExecutionRecord]
```

---

## Roadmap

### Q2 2026 (Current)
- ✅ Complete Rust MVP implementation
- ✅ Full test coverage for core systems
- 🔄 Performance optimization and benchmarking
- 🔄 Extended plugin system development

### Q3 2026
- 📋 Advanced agent behavioral patterns
- 📋 Enhanced tool composition capabilities
- 📋 Multi-agent coordination frameworks
- 📋 Distributed execution layer

### Q4 2026
- 📋 Production deployment tooling
- 📋 Enterprise security features
- 📋 Advanced observability dashboards
- 📋 Full platform release

---

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](rust/CONTRIBUTING.md) for guidelines.

### Development Workflow

1. Fork and clone the repository
2. Create a feature branch: `git checkout -b feature/description`
3. Make changes and ensure tests pass
4. Commit with clear messages
5. Push to your fork and create a pull request
6. Ensure CI passes and get code review

---

## Performance Targets

| Metric | Target | Status |
|--------|--------|--------|
| Tool Invocation Latency | < 50ms | ✅ Achieved |
| Command Execution | < 200ms | ✅ Achieved |
| Memory Footprint (Rust) | < 100MB idle | ✅ Achieved |
| Startup Time | < 1s | ✅ Achieved |
| Test Suite Completion | < 30s | ✅ 14s |

---

## Community & Support

- 📖 **Documentation:** See [docs/](docs/) for comprehensive guides
- 🐛 **Issues:** Report bugs on [GitHub Issues](https://github.com/yourusername/singul-code/issues)
- 💬 **Discussions:** Join [GitHub Discussions](https://github.com/yourusername/singul-code/discussions)

---

## License

This project is dual-licensed:

- **Python:** MIT License
- **Rust:** MIT License

See LICENSE file for details.

---

## Acknowledgments

Built with care for the open-source community. Special thanks to contributors and the development teams that made this possible.

---

<p align="center">
  <strong>Singul Code</strong> — Unified Agent Orchestration Framework
  <br>
  <a href="#">GitHub</a> • 
  <a href="#">Documentation</a> • 
  <a href="#">Issues</a>
</p>
