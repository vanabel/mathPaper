## mathPaper：`amsart` 论文模板（可投稿/可单文件）

一个尽量“开箱即用”的数学论文写作模板：

- **主文件**：`main.tex`
- **导言区包**：`mathpaper.sty`（把常用宏包、定理环境、`cleveref`、proof 样式等集中管理）
- **示例文献库**：`references.bib`
- **编译脚本**：`Makefile`

---

### 快速开始

- **编译 PDF**：

```bash
make
```

或：

```bash
latexmk -pdf main.tex
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

- `https://github.com/vanabel/AMSRefs-arXiv-Support`

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
\input{template.bbl}
```

- **方式 B（真正单文件）**：打开生成的 `template.bbl`，把其中的 `thebibliography` 环境整段内容直接粘贴到这里，并删除 `\bibliography{references}`。

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

---

### 历史版本

旧版说明已保存在 `README-legacy.md`。

## mathpaper：`amsart` 论文模板（可投稿/可单文件）

一个尽量“开箱即用”的数学论文写作模板：

- **主文件**：`template.tex`
- **导言区包**：`mathpaper.sty`（把常用宏包、定理环境、`cleveref`、proof 样式等集中管理）
- **示例文献库**：`references.bib`
- **编译脚本**：`Makefile`

---

### 快速开始

- **编译 PDF**：

```bash
make
```

或：

```bash
latexmk -pdf template.tex
```

- **写作入口**：直接改 `template.tex` 里的 “Paper metadata” 与正文内容。

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

- `https://github.com/vanabel/AMSRefs-arXiv-Support`

（将仓库里的增强版 `amsrn.bst` 替换到你的项目目录即可。）

---

### 单文件协作/投稿（减少依赖）

有时需要把工程“打包成单个 `.tex`”或“提交 `.tex + .bbl`”。这里给出两种常用做法。

#### 1) 内联导言区：把 `mathpaper.sty` 内容粘进 `template.tex`

- **目标位置**：`template.tex` 中的

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

- **目标位置**：`template.tex` 末尾的

```tex
\bibliography{references}
```

两种选择：

- **方式 A（推荐，提交 `.tex + .bbl`）**：替换为

```tex
\input{template.bbl}
```

- **方式 B（真正单文件）**：打开生成的 `template.bbl`，把其中的 `thebibliography` 环境整段内容直接粘贴到这里，并删除 `\bibliography{references}`。

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

---

### 历史版本

旧版说明已保存在 `README-legacy.md`。

一个尽量“开箱即用”的数学论文写作模板：

- **主文件**：`template.tex`
- **导言区包**：`mathpaper.sty`（把常用宏包、定理环境、`cleveref`、proof 样式等集中管理）
- **示例文献库**：`references.bib`
- **编译脚本**：`Makefile`

---

### 快速开始

- **编译 PDF**：

```bash
make
```

或：

```bash
latexmk -pdf template.tex
```

- **写作入口**：直接改 `template.tex` 里的 “Paper metadata” 与正文内容。

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

- `https://github.com/vanabel/AMSRefs-arXiv-Support`

（将仓库里的增强版 `amsrn.bst` 替换到你的项目目录即可。）

---

### 单文件协作/投稿（减少依赖）

有时需要把工程“打包成单个 `.tex`”或“提交 `.tex + .bbl`”。这里给出两种常用做法。

#### 1) 内联导言区：把 `mathpaper.sty` 内容粘进 `template.tex`

- **目标位置**：`template.tex` 中的

```tex
\usepackage{mathpaper}
```

- **做法**：
  - 删除该行
  - 将 `mathpaper.sty` 的内容粘贴到导言区（`\\documentclass` 之后、`\\begin{document}` 之前）
  - 粘贴时不要带上以下三行（其余原样复制）：
    - `\NeedsTeXFormat{LaTeX2e}`
    - `\ProvidesPackage{...}`
    - `\endinput`

说明：`mathpaper.sty` 使用 `\RequirePackage`，直接粘贴到导言区也能正常工作。

#### 2) 用 `.bbl` 替代 `\bibliography{references}`

- **目标位置**：`template.tex` 末尾的

```tex
\bibliography{references}
```

两种选择：

- **方式 A（推荐，提交 `.tex + .bbl`）**：替换为

```tex
\input{template.bbl}
```

- **方式 B（真正单文件）**：打开生成的 `template.bbl`，把其中的 `thebibliography` 环境整段内容直接粘贴到这里，并删除 `\bibliography{references}`。

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

---

### 历史版本

旧版说明已保存在 `README-legacy.md`。

## mathpaper 使用说明

本目录提供一个 `amsart` 论文模板 `template.tex`，其导言区配置已抽成 `mathpaper.sty`，并配有示例文献库 `references.bib`。

### 常规用法（推荐）

- **写作**：编辑 `template.tex` 的 “Paper metadata” 区块与正文各节。
- **文献**：把条目加入 `references.bib`，正文用 `\cite{...}` / `\cites{...}`。
- **编译**：

```bash
latexmk -pdf template.tex
```

### 单文件协作/投稿：内联导言区（把 `.sty` 内容拷到主文件）

有时对方/投稿系统希望你提交**单个 `.tex`**（或尽量减少依赖文件）。此时可以把 `mathpaper.sty` 的内容直接放进 `template.tex` 的导言区。

- **位置**：在 `template.tex` 第 12–13 行附近，你会看到：

```tex
\usepackage{mathpaper}
```

- **操作**：
  - 删除 `\usepackage{mathpaper}` 这一行
  - 打开 `mathpaper.sty`，将其中内容复制到 `template.tex` 的导言区（即 `\documentclass{...}` 之后、`\begin{document}` 之前）
  - 复制时请**不要**带上以下三行（其余原样拷贝）：
    - `\NeedsTeXFormat{LaTeX2e}`
    - `\ProvidesPackage{...}`
    - 文件末尾的 `\endinput`

说明：`mathpaper.sty` 内部使用的是 `\RequirePackage{...}`，即使直接粘贴进导言区也可以正常工作（不必手动改成 `\usepackage`）。

### 单文件协作/投稿：用 `.bbl` 替代 `\bibliography{references}`

有时对方不方便运行 BibTeX（或要求“提交 `.tex + .bbl` / 或直接内联参考文献”）。此时可以在 `template.tex` 的参考文献位置用 `.bbl` 替换。

- **位置**：`template.tex` 末尾有：

```tex
\bibliography{references}
```

你可以用以下两种方式之一替换：

#### 方式 A（推荐）：保留 `template.bbl` 文件并输入它

把

```tex
\bibliography{references}
```

替换为：

```tex
\input{template.bbl}
```

其中 `template.bbl` 通常由 `bibtex template` 生成（或用 `latexmk` 自动生成）。

#### 方式 B（真正单文件）：把 `.bbl` 内容直接粘贴进 `template.tex`

打开生成的 `template.bbl`，将其全部内容（通常是 `\begin{thebibliography}{...} ... \end{thebibliography}`）直接粘贴到 `\bibliography{references}` 原来的位置，并删除 `\bibliography{references}`。

### 注意事项

- 一旦改用 `.bbl`（方式 A 或 B），就**不再需要** `.bib`（也不需要再跑 BibTeX）；文献更新时需要重新生成/更新 `.bbl`。
- 如果投稿系统要求 “source + bib”，则保持默认的 `\bibliography{references}` 与 `references.bib` 即可。

