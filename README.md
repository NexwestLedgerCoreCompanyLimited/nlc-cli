<p align="center">
  <img src="https://oddsforge.org/logo.svg" alt="NLC AI X OddsForge" width="96" height="96">
</p>

<h1 align="center">NLC AI X OddsForge — CLI</h1>

<p align="center">
  <b>A powerful multi-model AI assistant in your terminal.</b><br>
  Chat, code, browse the web, and call tools — powered by the NLC AI platform.
</p>

<p align="center">
  <a href="https://oddsforge.org"><img src="https://img.shields.io/badge/Website-oddsforge.org-d97757" alt="Website"></a>
  <a href="https://oddsforge.org/docs"><img src="https://img.shields.io/badge/Docs-read-7c5cff" alt="Docs"></a>
  <a href="https://oddsforge.org/status"><img src="https://img.shields.io/badge/Status-live-22c55e" alt="Status"></a>
  <img src="https://img.shields.io/badge/License-MIT-blue" alt="MIT">
  <img src="https://img.shields.io/badge/API-OpenAI%20%2B%20Anthropic%20compatible-111827" alt="API">
</p>

---

## ✨ Try the full platform → [oddsforge.org](https://oddsforge.org)

**NLC AI X OddsForge** is a state-of-the-art AI platform: chat in your browser, build with an
OpenAI- and Anthropic-compatible API, and pay only for what you use — **no subscription, top up from $5**.

- 💬 **Web chat** with live answer streaming, **Artifacts** (generate a web page → preview & download), and selectable **work modes** (Standard / Max / Fast)
- 🌐 **Reads the web** — paste a URL and the model fetches and summarizes it
- 🔌 **Connectors (MCP)** — plug in tools and let the AI use them mid-chat
- 🧠 **Built-in skills** automatically applied on every request, so answers are sharp out of the box

👉 **Start free at [oddsforge.org/chat](https://oddsforge.org/chat)**

---

## 🤖 Models

| Model | Best for | Context |
|-------|----------|---------|
| **NLC PRO** | Flagship reasoning + code, large codebases | 1M |
| **NLC Vision** | Images + multimodal understanding | 1M |
| **NLC Fast** | Cheapest, high-throughput & agentic work | 1M |
| **NLC ULTRA MAX** | Multi-agent powerhouse for full-stack tasks | 1M |

All models are available over the API and in this CLI.

## 🖥️ The CLI

- **Beautiful terminal UI** with real-time streaming
- **OpenAI + Anthropic protocols** — works with one NLC API key
- **MCP support** — connect Model Context Protocol tool servers
- **Skill system** — pulls project skills automatically
- Pick any model, including **NLC ULTRA MAX**

### Install

```bash
npm install -g nlc-cli
# or: bun install -g nlc-cli
```

### Use

```bash
nlc login https://oddsforge.org   # get your API key at oddsforge.org → dashboard
nlc                                # start chatting in your terminal
```

## 🧩 Use NLC in your editor

NLC works in **Cursor, VS Code, Cline, Continue, Copilot** and any OpenAI/Anthropic-compatible client:

```
Base URL:  https://oddsforge.org/v1
API key:   <your key from the dashboard>
Models:    nlc-pro · nlc-vision · nlc-fast · nlc-ultra
```

## 🔗 Links

- 🌐 Website — https://oddsforge.org
- 💬 Chat — https://oddsforge.org/chat
- 📚 Docs — https://oddsforge.org/docs
- 🧪 API — https://oddsforge.org/api
- 📈 Status — https://oddsforge.org/status
- 📰 Blog — https://oddsforge.org/blog

## License

MIT. This project is built on [opencode](https://github.com/sst/opencode) (MIT). See `LICENSE` and `NOTICE`.
