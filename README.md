## mathPaper：`amsart` 论文模板（可投稿/可单文件）

一个尽量“开箱即用”的数学论文写作模板：

- **主文件**：`main.tex`
- **导言区包**：`mathpaper.sty`（把常用宏包、定理环境、`cleveref`、proof 样式等集中管理）
- **示例文献库**：`references.bib`
- **编译脚本**：`Makefile`

---

### 快速开始

需要 **GNU Make** + **latexmk**（TeX Live / MiKTeX）。Windows 可用 Chocolatey/`winget` 安装 `make`，或在 **Git Bash / MSYS2** 里执行；清理步骤依赖 TeX 自带的 Perl，不依赖 `rm`。`make zip` 优先用 `zip`，没有则用 Windows 上常见的 `7z`/`7za`。

- **编译 PDF**：

```bash
make
make help          # 列出常用目标
make ENGINE=xe     # 改用 XeLaTeX
```
或：
```bash
# pdflatex (default)
latexmk -pdf -interaction=nonstopmode main.tex

# xelatex
latexmk -xelatex -interaction=nonstopmode main.tex
```

本地覆盖可复制 `Makefile.local.example` 为 `Makefile.local`（已 gitignore），例如：

```make
MAIN := other.tex
ENGINE := xe
```

- **连续编译（文件改动自动重编译）**：

```bash
make watch         # 同 make live；默认 pdfLaTeX
make watch-xe      # XeLaTeX
make stop          # 结束本项目相关编译进程（Unix / Git Bash）
```

- **写作入口**：直接改 `main.tex` 里的 “Paper metadata” 与正文内容。

---

### 参考文献与 arXiv 引用

本模板使用 **BibTeX + AMSRefs 的 `.bst` 风格**（默认 `amsrn.bst`）工作流。

- **`.bib` 文件**：`references.bib`
- **引用命令**：`\cite{key}` / `\cites{key1,key2}`

#### arXiv 条目示例（BibTeX）

在 `references.bib` 中加入类似：

```bibtex
@misc{Smith2025ArxivExample,
  author        = {Smith, Alice and Zhang, Bob},
  title         = {A Short arXiv Preprint Title},
  year          = {2025},
  eprint        = {2501.01234},
  archivePrefix = {arXiv},
  primaryClass  = {math.DG},
  note          = {arXiv:2501.01234},
}
```

然后在正文中：

```tex
\cite{Smith2025ArxivExample}
```

#### 重要：需要在条目末尾显示 `[math.DG]`（分类信息）

如果你希望参考文献中 arXiv 条目显示为类似：

> `arXiv:2501.01234 [math.DG]`

那么需要使用**带 arXiv 增强支持的 `amsrn.bst`**（以及同系列 `.bst`）。相关说明与增强版 `.bst` 文件见：

- [AMSRefs-arXiv-Support](https://github.com/vanabel/AMSRefs-arXiv-Support)

（将仓库里的增强版 `amsrn.bst` 替换到你的项目目录即可。）

---

### 单文件协作/投稿（减少依赖）

有时需要把工程“打包成单个 `.tex`”或“提交 `.tex + .bbl`”。这里给出两种常用做法。

#### 1) 内联导言区：把 `mathpaper.sty` 内容粘进 `main.tex`

- **目标位置**：`main.tex` 中的

```tex
\usepackage{mathpaper}
```

- **做法**：
  - 删除该行
  - 将 `mathpaper.sty` 的内容粘贴到导言区（`\documentclass` 之后、`\begin{document}` 之前）
  - 粘贴时不要带上以下三行（其余原样复制）：
    - `\NeedsTeXFormat{LaTeX2e}`
    - `\ProvidesPackage{...}`
    - `\endinput`

说明：`mathpaper.sty` 使用 `\RequirePackage`，直接粘贴到导言区也能正常工作。

#### 2) 用 `.bbl` 替代 `\bibliography{references}`

- **目标位置**：`main.tex` 末尾的

```tex
\bibliography{references}
```

两种选择：

- **方式 A（推荐，提交 `.tex + .bbl`）**：替换为

```tex
\input{main.bbl}
```

- **方式 B（真正单文件）**：打开生成的 `main.bbl`，把其中的 `thebibliography` 环境整段内容直接粘贴到这里，并删除 `\bibliography{references}`。

---

### 清理产物

- **清理中间文件**：

```bash
make clean
```

- **连同 PDF 一并清理**：

```bash
make distclean
```
