## mathpaper 使用说明（旧版）

本文件为历史版本。最新说明请见 `README.md`。

---

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

