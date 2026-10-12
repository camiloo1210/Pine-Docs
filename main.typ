// =====================================================================
// PINE — AI II, Deliverable 1 (12 October 2026)
// Estilo IEEE conference (mismo look & feel que SNNTraffic).
// Edita SOLO los datos de autores en el bloque "AUTORES" más abajo.
// =====================================================================

// ---------------------------- AUTORES --------------------------------
#let authors = (
  (name: "Camily Solorzano", email: "camilystefaniasoza@gmail.com"),
  (name: "Pablo Montalvo", email: "pablo280504@gmail.com"),
  (name: "Camilo Brazales", email: "camilobrazales@gmail.com"),
)
#let affiliation = ("Software Engineering, FICA", "Universidad de Las Américas (UDLA)", "Quito, Ecuador")

// ------------------------- CONFIGURACIÓN -----------------------------
#let serif = ("Times New Roman", "TeX Gyre Termes", "Nimbus Roman", "Liberation Serif", "Libertinus Serif")
#let mono = ("Courier New", "Liberation Mono", "DejaVu Sans Mono")

#set document(
  title: "Privacy-Preserving Financial Document Understanding",
  author: authors.map(a => a.name),
)
#set page(
  paper: "us-letter",
  margin: (top: 0.75in, bottom: 1in, left: 0.625in, right: 0.625in),
  numbering: "1",
  number-align: center,
  footer-descent: 25%,
)
#set text(font: serif, size: 10pt, lang: "en", hyphenate: true)
#set par(justify: true, leading: 0.55em, spacing: 0.55em, first-line-indent: (amount: 1em, all: true))
#show raw: set text(font: mono, size: 8.5pt)
#show link: set text(fill: rgb("#1a3d7c"))

// --------------------------- ENCABEZADOS -----------------------------
#set heading(numbering: "I.A.")

// Nivel 1: versalitas centradas, numeración romana
#show heading.where(level: 1): it => {
  set align(center)
  set text(size: 10pt, weight: "regular")
  set par(first-line-indent: 0pt)
  block(above: 1.4em, below: 0.8em, sticky: true)[
    #if it.numbering != none {
      numbering("I.", ..counter(heading).at(it.location()))
      h(0.6em)
    }
    #smallcaps(it.body)
  ]
}

// Nivel 2: cursiva alineada a la izquierda, numeración A., B., ...
#show heading.where(level: 2): it => {
  set text(size: 10pt, weight: "regular", style: "italic")
  set par(first-line-indent: 0pt)
  block(above: 1.1em, below: 0.6em, sticky: true)[
    #if it.numbering != none {
      numbering("A.", counter(heading).at(it.location()).last())
      h(0.6em)
    }
    #it.body
  ]
}

// Encabezado sin numeración (References)
#let plain-heading(body) = {
  set align(center)
  set par(first-line-indent: 0pt)
  block(above: 1.4em, below: 0.8em, sticky: true, text(size: 10pt, smallcaps(body)))
}

// ----------------------------- LISTAS --------------------------------
#set list(indent: 1em, body-indent: 0.6em, spacing: 0.45em, marker: [•])
#show list: set par(first-line-indent: 0pt)
#show figure: set block(above: 0.9em, below: 1.1em)

// ----------------------------- TABLAS --------------------------------
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: table): set block(breakable: false)
#show figure.caption: it => {
  set text(size: 8pt)
  set par(first-line-indent: 0pt, justify: false)
  align(center)[
    #if it.kind == table [
      #upper[Table #context it.counter.display("I")] \
      #smallcaps(it.body)
    ] else [
      Fig. #context it.counter.display("1"). #it.body
    ]
  ]
}
#set table(
  stroke: 0.5pt + luma(60),
  inset: (x: 4pt, y: 3.5pt),
  fill: (_, y) => if y == 0 { luma(225) } else { none },
)
#show table: set text(size: 8.5pt)
#show table: set par(justify: false, first-line-indent: 0pt, leading: 0.5em)
#show table.cell.where(y: 0): set text(weight: "bold")

// Referencia a figuras/tablas con el estilo IEEE
#show ref: it => {
  let el = it.element
  if el != none and el.func() == figure {
    if el.kind == table {
      [Table~#numbering("I", ..counter(figure.where(kind: table)).at(el.location()))]
    } else {
      [Fig.~#numbering("1", ..counter(figure.where(kind: image)).at(el.location()))]
    }
  } else { it }
}

// ------------------------- TÍTULO Y AUTORES --------------------------
#place(top + center, scope: "parent", float: true)[
  #set par(first-line-indent: 0pt)
  #v(0.2in)
  #align(center)[
    #text(size: 22pt, weight: "regular")[
      Privacy-Preserving Financial Document Understanding: A Hybrid YOLOv8, OCR, and Transformer-Based Approach for Offline Personal Finance Management
    ]
  ]
  #v(1.1em)
  #grid(
    columns: (1fr,) * authors.len(),
    column-gutter: 8pt,
    row-gutter: 0pt,
    ..authors.map(a => align(center)[
      #set text(size: 10pt)
      #a.name \
      #text(style: "italic")[#affiliation.at(0)] \
      #text(style: "italic")[#affiliation.at(1)] \
      #affiliation.at(2) \
      #a.email
    ]),
  )
  #v(1.2em)
]

// ------------------------------ ABSTRACT -----------------------------
// Bloque a una columna con márgenes interiores (como el SNNTraffic)
#block(width: 100%, inset: (x: 0.28in), above: 0pt, below: 0.9em)[
  #set text(size: 9pt, weight: "bold")
  #set par(first-line-indent: 0pt, leading: 0.5em, spacing: 0.5em)
  #text(style: "italic" )[Abstract]\

  Personal finance applications increasingly use artificial intelligence to process receipts automatically. However, cloud-based solutions may expose sensitive financial information, while traditional offline optical character recognition (OCR) systems often struggle to identify the meaning of extracted text. This paper presents a research proposal based on PINE, an open-source personal finance application designed to work offline and protect user privacy. Its current system uses YOLOv8n to detect receipts, OpenCV to correct image perspective, and PaddleOCR to recognize text. The proposed improvement is to integrate a Transformer model, such as LayoutLMv3, to identify important information, including the merchant, date, total amount, and taxes. The YOLOv8n model was trained using 5,086 receipt images and 500 negative samples. Training stopped automatically at epoch 116, with its best reported validation Mean Average Precision (mAP\@50) of 0.995 at epoch 91, measured using a 50% intersection-over-union threshold. Although these results show strong receipt detection performance on the validation dataset, they do not guarantee accurate extraction of financial information. Therefore, this study proposes comparing the current system with the Transformer-based approach, evaluating extraction accuracy, processing time, and resource consumption. The goal is to determine whether Transformers can improve receipt information extraction while maintaining privacy and efficient offline operation.

  #text(style: "italic")[Index Terms]—document understanding, YOLOv8, OCR, LayoutLMv3, key information extraction, offline AI, privacy.
]
\

// ------------------------------ CUERPO -------------------------------
#show: columns.with(2, gutter: 0.25in)

= Introduction
Personal finance management frequently requires users to transcribe merchant names, dates, amounts, and taxes from photographed receipts. Such images vary in illumination, perspective, background clutter, and document layout. Although OCR converts pixels to text, recovering a financially meaningful record also requires determining _which_ recognized token represents each field. A privacy-oriented application faces the additional constraint that sensitive receipts must not leave the user's device.

PINE is an open-source, offline-first desktop personal finance manager built with .NET and Avalonia UI. Its local document pipeline detects the receipt, corrects its perspective, and applies OCR. Its proposed research extension focuses on improving semantic extraction rather than replacing the entire finance application. The central research question is: _Can a layout-aware Transformer improve receipt field extraction over a heuristic OCR baseline without violating offline operation or imposing impractical local inference costs?_

The working hypothesis is that multimodal text-and-layout features will increase field-level F1 compared with heuristic parsing, while model quantization or a lightweight fallback may be necessary to satisfy device constraints. The intended contributions are (i) a reproducible comparison of receipt-understanding approaches in a privacy-preserving desktop setting, (ii) an evaluation of the accuracy–latency–memory trade-off, and (iii) a documented integration strategy. No improvement from the proposed Transformer is claimed at this proposal stage.

The remainder of this document is organized as follows. Section II reviews related work on document understanding and receipt parsing. Section III describes the existing system, the proposed comparison, and the evaluation protocol. Section IV presents a ten-week work plan. Section V discusses risks and alternative strategies. Finally, Section VI states the research-integrity position and the expected outcome.

= Related Work
Document understanding has progressed from isolated text recognition toward joint modeling of visual and spatial information. LayoutLM incorporates textual and two-dimensional layout features for document analysis [1], while LayoutLMv3 jointly learns text, image, and alignment representations and reports results on receipt-understanding tasks [2]. These approaches motivate the proposed layout-aware extraction stage, but their reported benchmark outcomes cannot be transferred directly to PINE's dataset or hardware.

Donut presents an OCR-free document-understanding Transformer [3], offering an alternative to pipelines that propagate OCR errors into downstream extraction. TrOCR instead targets text recognition through pre-trained Transformer components [4]; therefore, it is a candidate OCR replacement, not a directly equivalent key-information extraction (KIE) baseline. PP-OCR studies a practical lightweight OCR system [5], supporting the rationale for efficient recognition pipelines. CORD provides a consolidated receipt dataset for post-OCR parsing research [6], illustrating the importance of annotated fields and consistent evaluation protocols. YOLOv8 is documented as detection and segmentation software rather than as a peer-reviewed YOLOv8 research paper [7].

Unlike work evaluated primarily on standalone document benchmarks, the proposed study will assess _end-to-end_ field extraction, local execution cost, and a no-network operational constraint within PINE. The comparison is therefore about system-level suitability, not an unsupported claim of novel Transformer architecture.


= Proposed Methodology
== Existing System and Preliminary Evidence
The current image-processing path is summarized in @fig-pipeline. A receipt image is segmented by YOLOv8n, rectified through OpenCV contour approximation and perspective warping, read by PaddleOCR, parsed by deterministic heuristics, and finally confirmed by the user.

#figure(
  {
    set text(size: 7pt)
    set par(first-line-indent: 0pt, justify: false, leading: 0.4em)
    let node(body, fill: luma(240)) = box(
      width: 100%, inset: (x: 3pt, y: 4pt), radius: 1.5pt,
      stroke: 0.5pt + luma(60), fill: fill, align(center + horizon, body),
    )
    let arrow = align(center + horizon, text(size: 9pt)[→])
    grid(
      columns: (1fr, 8pt, 1fr, 8pt, 1fr),
      row-gutter: 5pt,
      align: horizon,
      node[Receipt image], arrow, node[YOLOv8n segmentation], arrow, node[OpenCV contour + perspective warp],
      grid.cell(colspan: 5, align(center, text(size: 9pt)[↓])),
      node[User review], arrow, node[Heuristic field parsing], arrow, node[PaddleOCR],
    )
  },
  caption: [Existing offline receipt-processing pipeline in PINE.],
  kind: image,
  supplement: [Fig.],
) <fig-pipeline>

The segmentation checkpoint was trained using 5,086 receipt images supplemented by 500 negative images from a negative-samples computer-vision dataset. Training was configured for 150 epochs, with early stopping after 25 epochs without improvement; the run stopped at epoch 116. The best reported validation mAP\@50 was 0.995 at epoch 91. The exported deployment artifact is an approximately 13 MB ONNX model derived from `best.pt`.

These figures describe the supplied training record, not an independently reproduced test. The precise negative-sample annotation policy, split composition, and field-extraction performance will be audited before comparison. High receipt-detection mAP does not imply high merchant/date/total/tax extraction accuracy.
== Proposed Comparison and Data Protocol
The principal baseline will be the existing YOLOv8n + OpenCV + PaddleOCR + deterministic parsing pipeline. The proposed treatment will retain receipt detection and OCR, then use LayoutLMv3 with OCR tokens and normalized 2D word coordinates for KIE. Donut may be examined as an OCR-free alternative if compute and annotation resources permit; TrOCR will be considered only as an OCR-stage alternative. Each approach must use the same held-out receipt images and target-field definitions.

The team will audit the 5,086-image corpus, separate the 500 negative samples, check duplicates and near-duplicates, and create document-level train/validation/test partitions without leakage. A labeled subset must include ground-truth merchant, date, total, and tax fields; missing taxes will be explicitly represented rather than guessed. Public receipt data such as CORD [6] may support external testing subject to license and label compatibility. Training and experimentation may use Google Colab, but the final PINE inference pathway must remain local and network-independent.

== Evaluation and Reproducibility
We evaluate performance using the following metrics:
- Per-field precision, recall, and F1 (exact match after documented normalization), as primary measures
- Macro-F1 across the four fields and complete-record accuracy
- Detection reported separately: bounding-box and mask mAP\@50 and mAP\@50–95
- Median and 95th-percentile CPU latency per document, peak RAM, model size, and offline execution success

Experiments will log model versions, splits, random seeds, inference hardware, and preprocessing settings. Error analysis will stratify by perspective, blur, lighting, and document layout. The study will also test whether the 500 negative images reduce false detections on non-receipt inputs.

= Ten-Week Work Plan
The remaining ten weeks are organized as described in @tab-plan.

#figure(
  table(
    columns: (0.17fr, 0.55fr, 0.28fr),
    align: left,
    [Weeks], [Milestone / Evidence], [Lead],
    [6–7], [Audit datasets, annotations, splits; reproduce YOLO checkpoint and heuristic baseline.], [All authors],
    [8–9], [Implement LayoutLMv3 KIE and field normalization; prepare reproducible runs.], [All authors],
    [10], [Compare preliminary field metrics; submit Methods and initial Results.], [All authors],
    [11–12], [Run controlled experiments and latency/memory benchmarks; analyze errors.], [All authors],
    [13–14], [Validate robustness and ablations; integrate the chosen local inference path.], [All authors],
    [15], [Finalize IMRaD paper, references, repository and presentation.], [All authors],
  ),
  caption: [Work plan for the remaining 10 weeks],
  kind: table,
) <tab-plan>

Responsibilities are shared: Author 1 owns dataset integrity and detector reproduction; Author 2 owns Transformer modeling and the Typst manuscript; Author 3 owns benchmarks, integration validation, and figures. All three review experiments, writing, and oral defense.
\
\
\
= Risks and Alternatives

== Insufficient KIE Labels
Annotate a smaller representative subset with double review; use a licensed public receipt dataset for supplementary evaluation.

== Transformer Resource Demands
Test ONNX quantization and CPU inference; retain the deterministic baseline if limits are exceeded.

== Domain Shift and False Positives
Evaluate receipts, invoices, and non-document negatives separately; document generalization failures rather than inferring robustness from validation mAP.

== Schedule or Reproducibility Gaps
Freeze data splits, record environment versions, and prioritize a completed baseline comparison before optional architectures.

= Research Integrity and Expected Outcome
This first deliverable is a research proposal with historical detector-training evidence, not a completed comparative experiment. Subsequent reports will distinguish measured results from targets and document limitations, bias, and threats to validity. Generative AI assistants were used to support drafting, organization, and technical exploration; the authors remain responsible for checking sources, claims, code, and results. The intended outcome is an evidence-based decision on whether layout-aware KIE is sufficiently accurate and efficient for privacy-preserving local receipt processing.

// --------------------------- REFERENCIAS -----------------------------
#plain-heading[References]

#[
  #set text(size: 8pt)
  #set par(first-line-indent: 0pt, hanging-indent: 1.6em, spacing: 0.45em, leading: 0.5em, justify: true)
  // Toda la referencia es clicable; el texto se mantiene negro y solo el DOI/URL va en azul.
  #show link: set text(fill: black)
  #let blue(body) = text(fill: rgb("#1a3d7c"), body)
  #let ref-item(n, url, body) = par[#box(width: 1.6em)[[#n]]#link(url, body)]

  #ref-item(1, "https://doi.org/10.1145/3394486.3403172")[Y. Xu et al., "LayoutLM: Pre-training of Text and Layout for Document Image Understanding," in _Proc. ACM SIGKDD_, 2020, pp. 1192–1200. doi: #blue[10.1145/3394486.3403172].]
  #ref-item(2, "https://doi.org/10.1145/3503161.3548112")[Y. Huang, T. Lv, L. Cui, Y. Lu, and F. Wei, "LayoutLMv3: Pre-training for Document AI with Unified Text and Image Masking," in _Proc. ACM Multimedia_, 2022, pp. 4083–4091. doi: #blue[10.1145/3503161.3548112].]
  #ref-item(3, "https://doi.org/10.1007/978-3-031-19815-1_29")[G. Kim et al., "OCR-Free Document Understanding Transformer," in _Proc. ECCV_, 2022. doi: #blue[10.1007/978-3-031-19815-1_29].]
  #ref-item(4, "https://doi.org/10.1609/aaai.v37i11.26538")[M. Li et al., "TrOCR: Transformer-Based Optical Character Recognition with Pre-trained Models," in _Proc. AAAI_, vol. 37, no. 11, 2023, pp. 13094–13102. doi: #blue[10.1609/aaai.v37i11.26538].]
  #ref-item(5, "https://arxiv.org/abs/2009.09941")[C. Du et al., "PP-OCR: A Practical Ultra Lightweight OCR System," _arXiv preprint #blue[arXiv:2009.09941]_, 2020.]
  #ref-item(6, "https://mlanthology.org/neuripsw/2019/park2019neuripsw-cord/")[S. Park et al., "CORD: A Consolidated Receipt Dataset for Post-OCR Parsing," _Document Intelligence Workshop at NeurIPS_, 2019. [Online]. Available: #blue("https://mlanthology.org/neuripsw/2019/park2019neuripsw-cord/").]
  #ref-item(7, "https://github.com/ultralytics/ultralytics")[G. Jocher, A. Chaurasia, and J. Qiu, _Ultralytics YOLOv8_, software, 2023. [Online]. Available: #blue("https://github.com/ultralytics/ultralytics").]
]