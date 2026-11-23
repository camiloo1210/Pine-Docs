// =====================================================================
// PINE — AI II, Deliverable 2: Methods and preliminary results
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
#block(width: 100%, inset: (x: 0.28in), above: 0pt, below: 0.9em)[
  #set text(size: 9pt, weight: "bold")
  #set par(first-line-indent: 0pt, leading: 0.5em, spacing: 0.5em)
  #text(style: "italic" )[Abstract]\

  Cloud receipt scanners expose sensitive financial data, while classical offline OCR pipelines read text but do not know which token is the merchant, the date, the total or the tax. This report describes the implemented methods and the first measured results of PINE, an open-source, offline personal finance application (.NET, Avalonia; Windows and Android). The pipeline detects the receipt with YOLOv8n, rectifies it, reads it with PP-OCRv5 executed through ONNX Runtime, and extracts four fields with a deterministic heuristic baseline, a fine-tuned LayoutLMv3 token classifier (INT8, 128 MB), and a hybrid that overlays the model on the heuristics. On a frozen test split of 164 receipts (CORD and SROIE) and the same PaddleOCR output for every system, the Macro-F1 over the four fields is 0.702 for the heuristic baseline, 0.894 for LayoutLMv3 alone and 0.904 for the hybrid; the Deliverable 1 baseline scored 0.389 before a number-format defect was corrected. The model stage costs a median of 254 ms and a P95 of 855 ms per document on a Ryzen 7 5700G CPU, and the whole scan runs in about 8.9 s on a 4 GB Android tablet. We also report negative results (binarization hurts OCR, width-batched recognition is slower on CPU), the limits of the evidence (164 documents, South-East-Asian receipts, no Spanish ground truth) and an adjusted five-week plan.

  #text(style: "italic")[Index Terms]—document understanding, YOLOv8, PP-OCRv5, LayoutLMv3, key information extraction, ONNX, offline AI, privacy.
]
\

// ------------------------------ CUERPO -------------------------------
#show: columns.with(2, gutter: 0.25in)

= Introduction
Personal finance applications ask users to transcribe merchants, dates, amounts and taxes from photographed receipts. OCR turns pixels into text, but a financial record also requires deciding _which_ recognized token plays which role, and a privacy-oriented application must do so without sending the image to a server. PINE is an open-source, offline-first finance manager built with .NET and Avalonia UI; this report documents the receipt-understanding stack that was implemented during the first half of the project and the first measurements obtained with it.

*Feedback from Deliverable 1.* The feedback asked us to clarify what the research question would evaluate. We measure extraction quality using value-level F1 for merchant, date, total, and tax on a fixed test split with shared OCR output. We characterise on-device feasibility using model size, desktop CPU latency, and an initial Android timing. Inference runs locally. The mobile timing does not establish a general usability threshold.

The research question is: _With the OCR output held fixed, how much does a layout-aware Transformer improve receipt field extraction over a heuristic baseline, and what is the cost of running it locally?_ This report presents the implemented pipeline, a comparison of three extraction configurations, and an adjusted experimental plan.

= Related Work
LayoutLM and LayoutLMv3 jointly model text, 2-D position and image patches for document understanding [1], [2]; Donut removes the OCR stage [3]; TrOCR replaces the recognizer by a Transformer [4]; PP-OCR is a practical lightweight OCR system [5]; CORD is a receipt corpus for post-OCR parsing [6]; YOLOv8 is the detection and segmentation software used for localisation [7]. SROIE (ICDAR 2019) and WildReceipt supply Malaysian and mostly Western receipts with merchant, date and total [8], [9]. We reuse these components; the contribution is their end-to-end evaluation inside a no-network application, not a new architecture.

= Methods
== Data and Environment
@tab-data lists the labelled corpus. We selected CORD, SROIE and WildReceipt because they provide receipt images, text-region coordinates and complementary labels for the four target fields. WildReceipt also provides an official held-out split. Labels are stored as word-level BIO tags plus a document-level ground-truth value per field. No public set annotates all four fields on every document: CORD gives TOTAL and TAX, SROIE gives MERCHANT, DATE and TOTAL, WildReceipt gives all four. Training masks partial labels. The evaluator skips source–field pairs with no ground truth in the split. The audit script found no image-hash group that crosses a split (27 duplicate groups, 0 leaking) and 204 word boxes outside the image, which were kept and clipped.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, right, right, right, right),
    [Source], [Docs], [With MERCH.], [With TOTAL], [With TAX],
    [CORD (Indonesia)], [1,000], [0], [972], [444],
    [SROIE (Malaysia)], [652], [652], [651], [0],
    [WildReceipt], [1,739], [1,308], [1,540], [1,171],
    [*Total*], [*3,391*], [*1,960*], [*3,163*], [*1,615*],
  ),
  caption: [Labelled corpus used for field extraction],
  kind: table,
) <tab-data>

The model is trained on 2,461 documents (CORD and SROIE train plus WildReceipt train minus a hash-grouped 10 % carve-out), validated on 294, and evaluated on two held-out sets: the *main test* of 164 documents (CORD 101, SROIE 63), which is the set used for every end-to-end comparison below, and the official WildReceipt test (472) used only for the model's generalisation check. The splits are frozen in `splits.json` and `splits_colab.json` (seeds 20260101 and 42). The detector (YOLOv8n-seg) is trained on 5,086 receipt images plus 500 negatives, as in Deliverable 1; a further 12,004 Roboflow images (7,207 groups after perceptual-hash de-duplication, 150 sampled for a frozen test) are being hand-verified and are not yet used for any score.

*Environment.* Training: Google Colab, T4 GPU, fp16. Inference and every latency figure: Windows 11, AMD Ryzen 7 5700G (16 threads), ONNX Runtime 1.29 CPU provider, no GPU. Mobile checks: an Android 14 tablet (SM-P613 class, 4 GB RAM). The application declares no network permission on Android and reads no URL at run time. Code, scripts and instructions are in the project repository (`research/README.md`; Python 3.12, .NET).

== Pre-processing and Pipeline
@fig-pipeline shows the implemented path. (1) A YOLOv8n-seg model (13.3 MB, ONNX) segments the receipt; its mask becomes a maximum-area inscribed quadrilateral. Windows uses OpenCV for the mask and warp; Android uses an equivalent managed Skia implementation, then a classical quad finder as fallback. The corners are shown to the user as an editable outline (Android). (2) The perspective warp produces the cropped colour image. (3) A screen-photo detector (spectral peak in the 2–6 px band, threshold 1,500) switches to a 0.6× down-scale plus background flattening; otherwise the colour crop is used unmodified (Section IV-C explains why binarization was dropped). (4) A dominant-line-angle estimate rotates tilted receipts back (|angle| > 3°) before reading. (5) PP-OCRv5 mobile detection and the Latin recognizer read the text; (6) extraction runs on word boxes.

On Android, Pine integrates Camera2 with a low-resolution preview and a full-resolution still for the final crop. The team implemented crop and perspective correction with Skia, ported the OCR path to ONNX Runtime, and added background model warm-up. Windows uses OpenCV for crop and perspective correction.

File sizes are measured in decimal MB. The 13.3 MB detector uses Ultralytics YOLOv8n-seg [7], adapted to receipts by Pine. The 4.8 MB text detector and 8.1 MB Latin recognizer come from PaddleOCR [5]. The detector ONNX export comes from #link("https://github.com/RapidAI/RapidOCR")[RapidOCR]; Pine rebuilt the recognition ONNX using its existing Paddle weights and the RapidOCR graph. The 128.4 MB LayoutLMv3 file is based on the Microsoft checkpoint by Huang et al. [2], fine-tuned and quantized by Pine.

#figure(
  {
    set text(size: 6.6pt)
    set par(first-line-indent: 0pt, justify: false, leading: 0.4em)
    let node(body, fill: luma(240)) = box(
      width: 100%, inset: (x: 2pt, y: 3.5pt), radius: 1.5pt,
      stroke: 0.5pt + luma(60), fill: fill, align(center + horizon, body),
    )
    let hl = luma(205)
    let arrow = align(center + horizon, text(size: 8pt)[→])
    grid(
      columns: (1fr, 7pt, 1fr, 7pt, 1fr, 7pt, 1fr),
      row-gutter: 5pt,
      align: horizon,
      node[Photo / camera], arrow, node[YOLOv8n-seg + quad], arrow, node[Warp, enhance, deskew], arrow, node[PP-OCRv5 (ONNX)],
      grid.cell(colspan: 7, align(right, text(size: 8pt)[↓ #h(10pt)])),
      node(fill: hl)[User review + tax field], arrow, node(fill: hl)[Merger: model overlays heuristics], arrow, node(fill: hl)[LayoutLMv3 INT8 (token classes)], arrow, node[Heuristic parser],
    )
  },
  caption: [Implemented pipeline. Shaded blocks are the new contribution.],
  kind: image,
  supplement: [Fig.],
) <fig-pipeline>

== Algorithms and Hyperparameters
*Heuristic baseline.* A deterministic parser groups OCR boxes into rows (deskewed), searches Spanish and English keywords (TOTAL, SUBTOTAL, IVA, GST, tip, discount, delivery), and reads amounts with a per-receipt separator inference: the decimal mark is decided once from all numbers on the receipt, so `1,591,600` is a thousands group and `2,08` a decimal. Percentages and five-digit identifiers are never amounts; tax rows are never products; items are cross-checked against the printed subtotal.

*LayoutLMv3 token classifier.* `microsoft/layoutlmv3-base` (about 125 M parameters) fine-tuned for 9 BIO labels over the four fields. Inputs are OCR word boxes normalised to 0–1000, the token ids, and a 224×224 page image; long documents use 512-token windows with stride 128. The hyperparameters in @tab-hyper were fixed before the run and not tuned. The model was exported to ONNX (opset 17) and dynamically quantized to INT8, including the embedding table, and runs inside the .NET application through ONNX Runtime. Spans are decoded to a value with the same number parser as the heuristics.

#figure(
  table(
    columns: (0.5fr, 0.5fr),
    align: left,
    [Parameter], [Value],
    [Optimizer / LR], [AdamW (HF Trainer), 5·10#super[−5]],
    [Weight decay / warm-up], [0.01 / 10 % of steps],
    [Batch], [4 × 4 accumulation = 16],
    [Epochs / patience], [15 max / 4 (val F1)],
    [Epoch reported], [11; 3,541 s total],
    [Window / stride], [512 / 128 tokens],
    [Labels], [first sub-token; partial masking],
    [Precision / seed], [fp16 / 42],
  ),
  caption: [LayoutLMv3 fine-tuning configuration],
  kind: table,
) <tab-hyper>

*Hybrid.* `LayoutLmResultMerger.Overlay` lets the model override a field whenever it finds one, keeps the heuristics' items, and reconciles the two tax readings by checking which one agrees with the other lines and the printed total.

== Protocol and Metrics
All three systems consume the *same* PaddleOCR 3.7 output for the same 164 test documents, so the comparison isolates extraction. The benchmark reuses the saved Python PaddleOCR output, including any OCR errors. The deployed app uses the separate PP-OCRv5 ONNX path described above. A field matches when its normalised value agrees with the reference (merchant: case, punctuation and spacing folded; amounts: tolerance of 0.01; date: ISO). A match is a true positive. A wrong value contributes a false positive and a false negative. An omitted reference value contributes a false negative. The scorer skips source–field pairs with no reference labels in the split. Within a scored source, predicting a value for a receipt with no reference value counts as a false positive. Precision is the fraction of predictions that match, and recall is the fraction of reference values recovered. F1 is their harmonic mean. Macro-F1 is the simple average of the four field F1 scores. This value-level score differs from the token-span F1 reported by the training notebook. Desktop latency is the median and P95 of the model stage (decode, tokenisation, inference and decoding, excluding OCR). Peak RSS comes from the padded 512-token benchmark. Differences below about two F1 points are treated as inconclusive on this sample.

== Reproducing the Baseline
Pine source code is available in the #link("https://github.com/Kiroku-Solutions/Pine/tree/main")[main GitHub repository]. The #link("https://github.com/Kiroku-Solutions/Pine/tree/bfefa3538faeb38fd892461b67833d752f1509c1")[archived code revision] contains the evaluation scripts, frozen splits, and research checkpoint used to reproduce Table III.

From `research/`, `scripts/ocr_dump.py` writes the OCR JSON. `dotnet run --project baseline_dotnet -- data/ocr_paddle data/pred` runs the heuristics. With `--layoutlm model.onnx tokenizer.json` it also runs the model and hybrid. `scripts/eval_fields.py --pred data/pred --split test` scores a prediction directory. This protocol produces the field comparison in Table III. The other experiments in Section IV report their own measurements and conditions. The recorded code baseline had 2,575 passing automated tests, including pipeline parity checks, and 13 failures (nine build-hygiene and four timing-sensitive UI tests).

= Preliminary Results
== Field Extraction
@tab-fields and @fig-f1 compare the baseline and the proposed approach on the 164-document test set. The Deliverable 1 baseline is shown as a reference row: its TOTAL F1 of 0.191 was dominated by CORD (0.04), where thousands-separated amounts such as `1,591,600` were read as decimals. Correcting the number reader (not the OCR, not the model) raised the heuristic TOTAL to 0.486 and added a tax reader (F1 0 → 0.776), so part of the model's gain over the original baseline is the baseline's locale, not the Transformer.

#figure(
  table(
    columns: (1.1fr, 0.7fr, 0.6fr, 0.7fr, 0.6fr, 0.7fr),
    align: (left, right, right, right, right, right),
    [System], [MERCH.], [DATE], [TOTAL], [TAX], [Macro],
    [Heuristics (D1)], [.444], [.918], [.191], [0], [.389],
    [Heuristics (now)], [.571], [.976], [.486], [.776], [.702],
    [LayoutLMv3 only], [.778], [.959], [.931], [.909], [.894],
    [*Hybrid (shipped)*], [*.778*], [*.992*], [*.923*], [*.923*], [*.904*],
  ),
  caption: [Field F1 on the main test set (164 docs; 63 for MERCHANT and DATE, 163 for TOTAL, 41 for TAX)],
  kind: table,
) <tab-fields>

#figure(
  {
    set text(size: 6.5pt)
    set par(first-line-indent: 0pt, justify: false)
    let cats = ([MERCHANT], [DATE], [TOTAL], [TAX])
    let series = (
      (name: "Heuristics", vals: (0.571, 0.976, 0.486, 0.776), fill: luma(190)),
      (name: "LayoutLMv3", vals: (0.778, 0.959, 0.931, 0.909), fill: rgb("#6f8fc9")),
      (name: "Hybrid", vals: (0.778, 0.992, 0.923, 0.923), fill: rgb("#1a3d7c")),
    )
    let ch = 62pt
    let col(i) = grid(
      columns: (1fr,) * 3, column-gutter: 1.5pt,
      ..series.map(s => {
        let v = s.vals.at(i)
        align(bottom, stack(dir: ttb, spacing: 1pt,
          align(center, text(size: 5pt)[#str(calc.round(v, digits: 2)).trim("0", at: start)]),
          rect(width: 100%, height: v * ch, fill: s.fill, stroke: none)))
      })
    )
    box(width: 100%, inset: (x: 4pt))[
      #grid(columns: (1fr,) * 4, column-gutter: 7pt, ..range(4).map(i => box(height: ch + 9pt, col(i))))
      #line(length: 100%, stroke: 0.5pt)
      #grid(columns: (1fr,) * 4, column-gutter: 7pt, ..cats.map(c => align(center, c)))
      #v(2pt)
      #align(center)[
        #for s in series [#box(width: 6pt, height: 6pt, fill: s.fill) #s.name #h(8pt)]
      ]
    ]
  },
  caption: [Field-level F1 of the three systems on the main test set.],
  kind: image,
  supplement: [Fig.],
) <fig-f1>

For example, the hybrid Macro-F1 from the displayed field scores is `(0.778 + 0.992 + 0.923 + 0.923) / 4 = 0.904`. The field denominators differ because the datasets provide different labels.

The model's largest gains are on TOTAL (0.486 → 0.931) and MERCHANT (0.571 → 0.778); the heuristics already read dates well (0.976). Overlaying the model on the heuristics gives the best Macro-F1 (0.904 vs 0.894) and the best DATE and TAX, but it lowers TOTAL by 0.8 points (0.931 → 0.923); with 164 documents these differences are about one to three documents and are within noise. Error counts for the hybrid are MERCHANT 14 wrong, TOTAL 13 wrong, DATE 4 missing, TAX 1 wrong and 5 missing (earlier run). Most merchant errors are boundary or single-character OCR errors (`HOME MASTER HARDWARE &` against `... & ELECTRICAL`), which exact-match scoring counts as wrong.

*Generalisation.* On the official WildReceipt test (472 documents, mostly Western retail, the closest set to PINE's users) the PyTorch model scores token-span F1 of 0.825 (DATE 0.978, TAX 0.854, MERCHANT 0.765, TOTAL 0.727), against 0.959 on the main test. The 13-point gap shows that the main-test figure should not be projected onto real users.

== Model Cost and Quantization
@tab-quant shows why the INT8 model with quantized embeddings was selected: it loses 0.2–0.5 F1 points against FP32 and is four times smaller. In the end-to-end C\# run the model stage took a median of 254 ms and a P95 of 855 ms per document (164 documents, 0 failures). A first-use cost of about 1.4 s (loading) is hidden on Android by warming the model at start-up.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, right, right, right, right, right),
    [Model], [MB], [F1 test], [F1 WildR.], [Med. ms], [RSS MB],
    [FP32], [501.6], [.965], [.831], [651], [806],
    [INT8], [247.0], [.960], [.823], [513], [619],
    [INT8 + emb.], [128.4], [.962], [.828], [526], [511],
  ),
  caption: [Quantization (token-span F1 on dataset OCR; latency on padded 512 tokens, 16 threads)],
  kind: table,
) <tab-quant>

== Image Enhancement and OCR
The Windows pipeline originally binarized the crop (grey, Gaussian 5×5, adaptive threshold). Measured on 20 test images with the ONNX engine, ground-truth word recall was 92.2 % for the colour image and 78.1 % binarized (@tab-enh), so the colour crop is now used. For synthetic photos of a screen, a 0.6× down-scale plus background flattening recovers 73.4 % against 61.8 % unprocessed. The synthetic screens are a stand-in: no real screen photograph has been measured. The ONNX OCR engine matches PaddlePaddle's own inference on 99.3 % of lines (CER 0.89 %), and reproduces a Python reference exactly (565 of 565 lines).

#figure(
  table(
    columns: (0.62fr, 0.19fr, 0.19fr),
    align: (left, right, right),
    [OCR input], [Clean], [Screen],
    [Colour as is], [92.2], [61.8],
    [Binarize (previous)], [78.1], [51.2],
    [Flatten], [89.8], [66.1],
    [Down-scale 0.6 + flatten], [88.5], [73.4],
  ),
  caption: [Word recall (%) by OCR input, 20 images],
  kind: table,
) <tab-enh>

== Receipt Detection and Taxes
The detector's validation mAP\@50 of 0.995 (Deliverable 1) is a training-record figure, not a field result. On 80 real photographs the OpenCV and the portable Skia detectors each accepted 10 and agreed on the crop size within 8 % for 9 of them. After the relaxed acceptance rules for still photographs (mask 2–100 % of the frame), the portable detector produced a quadrilateral for 148 of 150 labelled photos; this measures that a crop is produced, not that it is correct, and a hand-verified score is pending.

Tax handling was audited separately. Before the correction, rows such as cash, change, subtotal, GST, rounding and service were read as products in 54 of 164 documents (78 of 337 items); afterwards in 1 of 164. Tilted photographs broke row grouping: on one invoice, 8° and 12° gave one item and a wrong total, and 20° gave none; after levelling, 0°, 5°, 8°, 12°, 20° and −12° all read three items, tax 9.06 and total 154.06.

== On-device Timing
A single scan on the Android tablet took about 8.9 s in total (down from 15.7 s): preparation 0.94 s, OCR 5.25 s (detection 0.79 s, recognition 4.11 s for 44 text lines) and LayoutLM 2.45 s (loading 1.43 s, inference 0.76 s). This is one run on one device and carries no confidence interval. The preview frame rate was not measured.

#figure(
  table(
    columns: (0.5fr, 0.25fr, 0.25fr),
    align: (left, right, right),
    [Stage (Android tablet)], [ms], [Share],
    [Preparation (decode, YOLO crop, enhance)], [938], [11 %],
    [OCR: detection], [793], [9 %],
    [OCR: crops + recognition (44 lines)], [4,323], [49 %],
    [LayoutLMv3 (load 1,432 + run 764)], [2,446], [27 %],
    [Other / heuristics], [≈ 400], [4 %],
    [*Total*], [*≈ 8,900*], [*100 %*],
  ),
  caption: [Latency breakdown of one scan on a 4 GB tablet],
  kind: table,
) <tab-device>

The text-recognition stage dominates; the model's load time is the second target and is now paid at start-up.

= Preliminary Discussion
*What the data support.* Within this test set, a layout-aware model clearly improves TOTAL and MERCHANT over the heuristic parser, the hybrid is marginally better than either, and the cost is bounded (about 0.25 s median per document on desktop CPU, a 128 MB file, about 0.5 GB of RAM). That supports the hypothesis for the studied data; it does not show the same for Spanish or Western retail receipts.

*Problems found and how they are handled.*
- *Locale defects masquerade as model gains.* Decimal-versus-thousands errors alone cost about 0.3 TOTAL F1. Handled with a single per-receipt number reader and regression tests; the baseline is now reported in both states.
- *Missing and partial labels.* No document set has all four fields, and TAX covers 48 % of documents. Handled with per-source masking and field-wise scoring. A side effect is that an "O" word of an unannotated field is learned as background.
- *Domain shift.* The 13-point drop on WildReceipt indicates sensitivity to dataset changes. Spanish and Latin American receipts may differ in fiscal vocabulary (e.g. IVA and RUC), number formats, and the position of totals and taxes. The study has no labelled Spanish test set, so this is a plausible failure mode, not evidence of lower Spanish scores. We plan to label about 200 Spanish-language receipts and compare the three extractors on them.
- *Overfitting and variance.* Validation (0.892) and test (0.959) differ because their source mix differs; the checkpoint was selected with early stopping on validation, never on the test sets. With 164 documents we cannot separate small differences.
- *Compute.* The 128 MB model exceeds the original 100 MB target. Vocabulary pruning is prepared but unused. Width-batched recognition was tried and discarded (20 images: 15.3 s to 21.5 s).
- *Licensing.* The adapted LayoutLMv3 weights use CC BY-NC-SA 4.0 and are loaded locally for the research demo. Pine tracks the demo checkpoint separately as a Git LFS research artifact and loads it outside the APK. Review of the training-data terms for public distribution is pending. The project records the original model, authors, licence, and modifications in its #link("https://github.com/Kiroku-Solutions/Pine/blob/main/research/docs/LAYOUTLMV3-NOTICE.md")[attribution notice].
- *Scoring strictness.* Exact match counts near-miss merchants as wrong; a token-level or edit-distance score would show the gap.

*Threats to validity.* The test set is South-East-Asian; the OCR engine is shared across systems; heuristics were tuned in part while looking at errors on the same documents, so their score is optimistic; the hand-verified Roboflow test is not yet available.

= Adjusted Plan for the Last Five Weeks
#figure(
  table(
    columns: (0.14fr, 0.6fr, 0.26fr),
    align: left,
    [Weeks], [Milestone / Evidence], [Output],
    [11], [Hand-verify the 150-image frozen test; compute detector crop accuracy and the baseline on real photos.], [Table + IoU],
    [12], [Label \~200 Spanish/Latin receipts; evaluate heuristics and model on them.], [Spanish F1],
    [13], [Ablations: with and without deskew, enhancement, hybrid overlay; error analysis by blur and tilt.], [Ablation table],
    [14], [Android latency, memory and preview fps (`gfxinfo`) over repeated runs; optional vocabulary pruning.], [Mean ± SD],
    [15], [Fine-tune on Spanish data if week 12 shows a gap; freeze results; finish IMRaD paper and README.], [Final paper],
  ),
  caption: [Plan for the remaining five weeks],
  kind: table,
) <tab-plan2>

If the Spanish evaluation fails, the fallback is the heuristic parser for Spanish and the model for English receipts.

= Research Integrity
The numbers in this report were produced by the scripts named in Section III-E on the frozen splits, except those attributed to Deliverable 1, the Colab notebook or the design notes, which are copied from their logs. Generative AI assistants were used to support coding, drafting and organisation; the authors remain responsible for the code, claims and sources.

// --------------------------- REFERENCIAS -----------------------------
#plain-heading[References]

#[
  #set text(size: 8pt)
  #set par(first-line-indent: 0pt, hanging-indent: 1.6em, spacing: 0.45em, leading: 0.5em, justify: true)
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
  #ref-item(8, "https://doi.org/10.1109/ICDAR.2019.00244")[Z. Huang et al., "ICDAR2019 Competition on Scanned Receipt OCR and Information Extraction," in _Proc. ICDAR_, 2019. doi: #blue[10.1109/ICDAR.2019.00244].]
  #ref-item(9, "https://doi.org/10.48550/arXiv.2103.14470")[W. Sun et al., "Spatial Dual-Modality Graph Reasoning for Key Information Extraction (WildReceipt)," _arXiv preprint #blue[arXiv:2103.14470]_, 2021.]
]
