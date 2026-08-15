**PRODUCT REQUIREMENTS DOCUMENT**

**DagangPintar AI**

*Sistem Prediksi Inventori & Agentic B2B Haggling untuk Ritel
Tradisional*

COMPFEST AI Innovation Challenge — Smart Commerce

Versi 1.0 \| Status: Final untuk Penyisihan \| Ruang Lingkup: MVP Fitur
1–3

**Daftar Isi**

1\. Ringkasan Eksekutif 3

2\. Problem Statement & Latar Belakang 4

3\. Tujuan Produk & Metrik Keberhasilan 4

4\. Persona & Skenario Master 5

5\. Fitur 1 — Predictive SKU Demand & Restock Recommender 5

6\. Fitur 2 — Automated Dynamic Pricing & Expiry Clearance 6

7\. Fitur 3 — Autonomous B2B Haggling Agent (Tawar.AI) 7

8\. Non-Functional Requirements 9

9\. Risiko & Mitigasi 9

10\. Item Terbuka & Tindak Lanjut 10

**1. Ringkasan Eksekutif**

DagangPintar AI adalah sistem terintegrasi yang menggabungkan prediksi
permintaan inventori berbasis Machine Learning dengan agen negosiasi B2B
otonom berbasis LLM, dirancang khusus untuk mengatasi dua masalah
struktural pada ritel tradisional (warung kelontong) di Indonesia:
ketidakmampuan memprediksi kebutuhan stok secara akurat, dan lemahnya
daya tawar saat pengadaan barang (kulakan) dari grosir.

Dokumen ini merangkum kebutuhan produk (product requirements) untuk
cakupan MVP yang akan dikompetisikan pada babak penyisihan COMPFEST AI
Innovation Challenge, mencakup Fitur 1 (Predictive Restock), Fitur 2
(Dynamic Pricing & Clearance), dan Fitur 3 (Tawar.AI — Agentic B2B
Haggling). Fitur 4 (Behavioral Analytics) telah dikeluarkan dari cakupan
MVP penyisihan untuk menjaga fokus tim pada tiga fitur inti dalam
keterbatasan waktu pengembangan.

**1.1 Perubahan Arsitektur Penting**

Catatan Revisi Arsitektur
Dokumen spesifikasi MVP awal merancang Fitur 3 dengan model SLM 4-bit
yang berjalan lokal di dalam container Docker (llama.cpp/vLLM).
Berdasarkan evaluasi kesiapan infrastruktur tim (belum ada infrastruktur
server sama sekali) dan risiko waktu, keputusan telah direvisi menjadi
arsitektur Cloud API. Seluruh bagian teknis di dokumen ini merefleksikan
keputusan akhir (Cloud API + Tool Calling), bukan rancangan
awal.

**2. Problem Statement & Latar Belakang**

**2.1 Problem Statement 1 — Inefisiensi Inventori Warung Kelontong
(B2C)**

Toko kelontong tradisional terus mengalami penurunan omzet akibat
ketidakmampuan bersaing dengan ekspansi ritel modern yang memiliki
sistem rantai pasok dan prediksi inventori yang rapi. Warung beroperasi
secara reaktif, menyebabkan:

- Stockout pada barang cepat laku (fast-moving), menyebabkan kehilangan
 pelanggan tetap.

- Overstock pada barang lambat laku (slow-moving), mengunci modal kerja
 (dead capital) dan meningkatkan risiko kerugian akibat kedaluwarsa.

- Ketiadaan analisis pola belanja lokal (hari pasar, siklus tanggal
 tua/muda, musim gajian) yang memengaruhi dinamika permintaan harian.

**2.2 Problem Statement 2 — Inefisiensi Negosiasi Pengadaan B2B**

Proses pengadaan barang (kulakan) dari warung ke agen grosir/distributor
masih manual dan tidak efisien:

- Pemilik warung tidak memiliki bargaining power atau waktu untuk
 menawar harga secara intensif.

- Pemilik grosir kewalahan melayani permintaan tawar-menawar dari
 puluhan hingga ratusan warung secara manual.

- Penolakan harga secara mentah (hard rejection) sering menyebabkan
 pembeli kabur, sementara pelayanan manual menyita waktu operasional
 grosir.

**3. Tujuan Produk & Metrik Keberhasilan**

**3.1 Tujuan Produk (Goals)**

1. Menyediakan rekomendasi restok yang presisi berbasis prediksi
 permintaan, bukan sekadar pencatatan historis (predictive &
 prescriptive, bukan descriptive).

2. Mengotomasi penyesuaian harga untuk stok macet/mendekati kedaluwarsa
 agar modal kerja warung dan grosir tidak mati.

3. Menghadirkan agen negosiasi B2B otonom yang dapat merespons
 tawar-menawar secara real-time tanpa mengorbankan margin keuntungan
 grosir di bawah batas aman.

**3.2 Non-Goals (Di Luar Cakupan MVP Penyisihan)**

- Fitur 4 — Local Customer Pattern & Behavioral Analytics (market basket
 analysis, peak-hour analytics) — dihapus dari cakupan MVP penyisihan.

- Skema pembayaran/transaksi finansial end-to-end (invoice hanya berupa
 draft berbatas waktu, bukan payment gateway penuh).

- Traffic multi-user skala besar / load testing produksi — MVP hanya
 perlu tangguh untuk skenario demo/evaluasi juri.

**3.3 Success Metrics untuk Evaluasi Penyisihan**

| **Metrik** | **Target** | **Cara Ukur** |
|-----------------------------------------------|----------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| Latency rata-rata /interact | < 1.5 detik | Load test lokal + monitoring saat demo |
| Akurasi prediksi restok (Fitur 1) | Directionally correct pada skenario demo (hari pasar, tanggal muda terdeteksi benar); R² ≥ 85%, MAE < 0.8 unit, RMSE < 1.0 unit | Evaluasi Test Set (360 hari data historis) + Perbandingan output model vs skenario master |
| Tingkat keberhasilan negosiasi tanpa handover | Agent mampu menyelesaikan negosiasi standar tanpa eskalasi manusia pada skenario non-ekstrem | Testing skenario percakapan yang telah disiapkan |
| Kepatuhan floor price | 0% pelanggaran — AI tidak pernah menyetujui harga di bawah floor price | Automated test rule engine + manual review log transaksi |
| Uptime saat sesi demo | 100% selama slot evaluasi juri | Observasi langsung + fallback plan |

**4. Persona & Skenario Master**

Seluruh requirement pada dokumen ini merujuk pada satu skenario master
terintegrasi yang konsisten di setiap fitur, untuk memastikan seluruh
anggota tim (Frontend, Backend, AI/ML) memiliki pemahaman yang sama.

| **Elemen** | **Detail** |
|---------------------------------|----------------------------------------------------------------------------------|
| Aktor Pembeli B2B / Penjual B2C | Bu Tejo — Pemilik Warung Kelontong "Toko Bu Tejo" |
| Aktor Penjual B2B / Distributor | Pak Jono — Pemilik "Grosir Berkah Jaya" |
| Konteks Waktu | Jumat Sore, 25 Agustus — menjelang Hari Pasar Sabtu & siklus Tanggal Muda/Gajian |
| SKU-01 | Minyak Goreng Pouch 2L (fast-moving item) |
| SKU-08 | Saus Sambal Botol 135ml (slow-moving / expiring item) |

**5. Fitur 1 — Predictive SKU Demand & Restock Recommender**

**5.1 User Story**

| |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| *"Sebagai pemilik warung kelontong, saya ingin sistem memberi peringatan dini dan rekomendasi jumlah barang yang harus dipesan sebelum stok populer saya habis, sehingga saya tidak kehilangan pelanggan setia akibat stockout."* |

**5.2 Functional Requirements**

| **ID** | **Requirement** | **Prioritas** |
|--------|----------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| F1-01 | Sistem membaca data historis transaksi POS per SKU secara berkala untuk menghitung baseline penjualan harian. | Must Have |
| F1-02 | Sistem membaca stok fisik aktif secara real-time dari database sebelum menghasilkan prediksi. | Must Have |
| F1-03 | Model memprediksi laju penjualan harian (Demand_pred) dengan mempertimbangkan metadata temporal: status hari pasar, status tanggal tua/muda. | Must Have |
| F1-04 | Sistem menghitung Days of Supply = Stok Aktif / Demand_pred. | Must Have |
| F1-05 | Sistem mengaktifkan status STOCKOUT RISK ketika Days of Supply berada di bawah Safety Buffer (2 hari). | Must Have |
| F1-06 | Sistem menghitung Reorder Quantity (ROQ) dan membulatkan ke unit grosir terdekat (mis. kelipatan karton). | Must Have |
| F1-07 | UI menampilkan kartu notifikasi restok preskriptif dengan tombol aksi langsung menuju Fitur 3 (Tawar.AI). | Must Have |

**5.3 Spesifikasi Teknis & Formula**

**Algoritma ML**

Random Forest dipilih sebagai algoritma final, menggantikan opsi
LightGBM.

| **Pertimbangan** | **Justifikasi** |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| Ukuran & Karakteristik dataset | Dataset menggunakan 360 hari (1 tahun) histori POS dengan fitur temporal (is_hari_pasar, is_tanggal_muda, past_7day_avg); Random Forest lebih robust terhadap overfitting dibanding gradient boosting. |
| Metodologi MLOps Hybrid | R&D, visualisasi kurva, dan evaluasi metrik (MAE, RMSE, R²) dilakukan di Jupyter Notebook, lalu model diexport sebagai artifact .pkl untuk inference instan di backend. |
| Constraint memori | RAM container dibagi dengan komponen Fitur 3; Random Forest lebih ringan dan predictable saat inference. |
| Waktu pengembangan | Minim tuning hyperparameter dibanding LightGBM, menghemat waktu tim AI/ML untuk fokus ke Fitur 3. |

**Formula Target Stok Ideal & ROQ**

Target_Stok_Ideal = (Demand_pred x Lead_Time_Restock) + (Demand_pred x
Safety_Buffer)

ROQ = Target_Stok_Ideal - Stok_Aktif → dibulatkan ke unit grosir
terdekat

| **Parameter** | **Nilai** | **Keterangan** |
|-------------------|-----------|------------------------------------------------------------------------------------------------------------------------------------------------|
| Lead_Time_Restock | 1 hari | Asumsi grosir lokal, pengiriman same-day/next-day via Tawar.AI. Merupakan konstanta yang dapat disesuaikan di backend jika SLA aktual berbeda. |
| Safety_Buffer | 2 hari | Buffer risiko prediksi meleset atau lonjakan permintaan di luar estimasi model. |

**Contoh Kalkulasi (Skenario Master)**

- Demand_pred = 9 pouch/hari (Minyak Goreng, efek Hari Pasar + Tanggal
 Muda)

- Target Stok Ideal = 9 × (1 + 2) = 27 pouch

- Stok Aktif = 6 pouch → ROQ = 27 − 6 = 21 pouch → dibulatkan menjadi 2
 Karton (24 pouch)

**5.4 Pembagian Tugas Tim**

| **Role** | **Tanggung Jawab** |
|-------------------|----------------------------------------------------------------------------------------------|
| AI/ML Engineer | Melatih model Random Forest dengan pembobotan fitur temporal (hari pasar, tanggal tua/muda). |
| Backend Engineer | Endpoint prediksi, query stok real-time, kalkulasi formula ROQ. |
| Frontend Engineer | Kartu notifikasi restok dengan teks preskriptif dan tombol trigger ke Fitur 3. |

**6. Fitur 2 — Automated Dynamic Pricing, Slow-Moving & Expiry Clearance
Engine**

**6.1 User Story**

| |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| *"Sebagai pemilik grosir, saya ingin sistem otomatis mendeteksi stok yang macet atau mendekati kedaluwarsa, lalu menyesuaikan harga batas bawah (floor price) secara dinamis agar modal kerja tidak mati dan barang berputar cepat."* |

**6.2 Functional Requirements**

| **ID** | **Requirement** | **Prioritas** |
|--------|----------------------------------------------------------------------------------------------------------------------------------|---------------|
| F2-01 | Sistem mendeteksi status dead stock ketika SKU tidak terjual selama lebih dari 30 hari. | Must Have |
| F2-02 | Sistem mendeteksi status expiry risk ketika sisa umur simpan SKU kurang dari atau sama dengan 30 hari. | Must Have |
| F2-03 | Ketika salah satu atau kedua kondisi terpicu, sistem menurunkan margin minimum menjadi flat 3% dan menghitung ulang floor price. | Must Have |
| F2-04 | Sistem memperbarui field floor_price pada record SKU di database secara otomatis. | Must Have |
| F2-05 | Sistem memberi tanda visual (badge) Dead Stock / Expiring pada dashboard inventori. | Should Have |
| F2-06 | Sistem memberikan saran aksi bisnis (mis. bundling, obral) sebagai teks rekomendasi di dashboard. | Could Have |

**6.3 Spesifikasi Teknis & Formula**

| **Parameter** | **Nilai Final** |
|-----------------------|----------------------------------------------------------------------------|
| Dead Stock Threshold | > 30 hari sejak transaksi terakhir |
| Expiry Risk Threshold | ≤ 30 hari sisa umur simpan |
| Margin Clearance | Flat 3% untuk semua kondisi (tidak ada sliding scale berdasarkan severity) |

Floor_Price = HPP + (HPP x 3%) → dibulatkan ke harga jual terdekat

Contoh (Skenario Master, SKU-08 Saus Sambal): HPP Rp6.000 → Floor Price
= 6.000 + 180 = Rp6.180 → dibulatkan menjadi Rp6.200.

**Integrasi ke Fitur 3**

Pola integrasi: database flag. Fitur 2 memperbarui field floor_price dan
clearance_flag pada record SKU. Fitur 3 melakukan real-time database
read query sebelum setiap respons chat untuk membaca nilai floor_price
terbaru — tidak ada event bus atau message queue terpisah pada cakupan
MVP.

**6.4 Pembagian Tugas Tim**

| **Role** | **Tanggung Jawab** |
|-------------------|---------------------------------------------------------------------------------------------|
| AI/ML Engineer | Logika analisis sirkulasi inventori (inventory turnover rate). |
| Backend Engineer | Python Rule Engine untuk kalkulasi Dynamic Floor Price berbasis HPP dan status kedaluwarsa. |
| Frontend Engineer | Penanda status Dead Stock / Expiring pada tabel inventori dashboard. |

**7. Fitur 3 — Autonomous B2B Haggling Agent (Tawar.AI)**

**7.1 User Story**

| |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| *"Sebagai pembeli B2B, saya ingin menawar harga kulakan secara interaktif melalui chat instan, dan sebagai pemilik grosir, saya ingin AI membalas penawaran berdasarkan stok dan batas modal secara real-time serta mengalihkan pesan ke saya jika tawar-menawar mencapai batas ekstrem."* |

**7.2 Functional Requirements**

| **ID** | **Requirement** | **Prioritas** |
|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| F3-01 | Sistem menerima input chat pembeli melalui satu REST endpoint sinkron (1 Input – 1 Output). | Must Have |
| F3-02 | Sistem menormalisasi teks input (singkatan nominal seperti "38rb", "50dus", typo umum) sebelum diproses model. | Must Have |
| F3-03 | Sistem melakukan real-time database read (stok aktif, HPP, floor price) sebelum menghasilkan respons. | Must Have |
| F3-04 | LLM memanggil satu tool gabungan process_negotiation(sku, quantity, offered_price) yang menjalankan evaluasi rule engine dan mengembalikan keputusan terstruktur. | Must Have |
| F3-05 | Keputusan approve/counter/reject harga sepenuhnya ditentukan oleh Python Rule Engine deterministik, bukan oleh LLM. | Must Have |
| F3-06 | Sistem mengaktifkan Hybrid Handover ke penjual manusia setelah 3 kali penawaran berturut-turut di bawah floor price, atau kuantitas ekstrem di luar kuota. | Must Have |
| F3-07 | Kesepakatan harga menghasilkan Invoice Draft dengan time-bound lock price (valid 2 jam). | Should Have |
| F3-08 | Interface chat berbasis PWA/Web custom dengan tampilan bubble chat seperti aplikasi pesan instan. | Must Have |

**7.3 Keputusan Arsitektur AI**

**Deployment: Cloud API**

| **Aspek** | **Keputusan** |
|-------------------|--------------------------------------------------------------------------------------------------|
| Model deployment | Cloud API (bukan SLM lokal di container) |
| Provider | Google Gemini API — free tier, tanpa kartu kredit |
| Model | Gemini 1.5 Flash — keseimbangan kualitas NLU/NLG bahasa Indonesia vs kecepatan respons |
| Kuota | ± 1.500 request/hari pada free tier — mencukupi kebutuhan development dan demo kompetisi |
| Fallback berbayar | DeepSeek V4 Flash (± \$0.14 / \$0.28 per 1 juta token input/output) jika kuota gratis terlampaui |

Alasan revisi dari rancangan awal (SLM lokal via llama.cpp/vLLM): tim
belum memiliki infrastruktur server sama sekali, dan setup inference
lokal (VPS, Docker, quantization) menambah risiko waktu yang signifikan
di luar risiko fine-tuning yang sudah teridentifikasi.

**Kustomisasi Model (Ketentuan Wajib Panitia)**

Panitia mewajibkan kustomisasi model di luar zero-shot API call biasa.
Metode yang dipilih tim: Tool Calling / Function Calling — dipilih
karena selaras langsung dengan arsitektur Hybrid System (Rule Engine
terpisah) yang telah dirancang sejak awal, dan memiliki risiko waktu
implementasi paling rendah dibanding fine-tuning (LoRA/QLoRA) untuk tim
yang belum berpengalaman melakukan fine-tuning.

Tool: process_negotiation(sku, quantity, offered_price) → menjalankan:
cek stok + evaluasi rule engine (accept/counter/reject) → return:
keputusan terstruktur ke LLM untuk generate respons akhir

Desain menggunakan satu tool gabungan (bukan beberapa tools granular
seperti check_stock() dan evaluate_offer() terpisah) untuk menghemat
token overhead dan mempertahankan target latency di bawah 1.5 detik,
karena setiap tool call tambahan berarti round-trip API tambahan.

**Alur Data Teknis (Single Endpoint REST API & State Management)**

1. Input Payload (POST /api/v1/interact): user_id, message_text, sku_id.
2. Text Normalization: Regex normalizer membersihkan singkatan ("38rb" → 38000, "50 dus" → 50).
3. Real-time DB Read Sync: Membaca available_stock, floor_price, normal_price, dan status sesi (tabel negotiation_sessions).
4. LLM menerima pesan pembeli, menginisiasi pemanggilan tool process_negotiation(offered_price, quantity).
5. Rule Engine mengevaluasi: offered_price vs floor_price, quantity vs available_stock → mengembalikan status (ACCEPT, COUNTER, REJECT, HANDOVER) dan harga penawaran balik.
6. Handover & Invoice Processing: Jika penawaran < floor_price 3x berturut-turut, picu status HANDOVER ke Pak Jono. Jika DEAL (ACCEPT), generate rekaman Invoice Draft di tabel invoice_drafts (valid 2 jam).
7. LLM men-generate kalimat respons akhir natural (NLG) berdasarkan hasil tool.
8. Output Payload: ai_response_text, action_type, suggested_price, handover_flag, invoice_draft.

**7.4 Kepatuhan & Aspek Legal**

- Protokol Two-Way Confirmation Handshake: setiap kesepakatan harga
 menghasilkan Invoice Draft berbatas waktu (2 jam).

- Transaksi baru dianggap sah secara hukum setelah dikonfirmasi manual
 atau terbayar oleh sistem — AI tidak pernah menjadi pihak yang
 mengikat transaksi secara final.

**7.5 Pembagian Tugas Tim**

| **Role** | **Tanggung Jawab** |
|-------------------|-----------------------------------------------------------------------------------------------------------|
| AI/ML Engineer | Desain system prompt, konfigurasi tool calling, modul text normalization (singkatan & typo pasar). |
| Backend Engineer | REST API /interact, integrasi Cloud API, Real-Time DB Read, logika Rule Engine, state handover. |
| Frontend Engineer | Chat-Centric UI (PWA/Web), bubble chat interaktif, badge status Handover, modal konfirmasi Invoice Draft. |

**8. Non-Functional Requirements**

| **Kategori** | **Requirement** |
|--------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Performance | Latency rata-rata respons API /interact di bawah 1.5 detik, termasuk round-trip ke Cloud API. |
| Reliability (Demo) | Sistem harus tetap berfungsi tanpa jeda selama sesi evaluasi juri; disarankan menyiapkan koneksi internet cadangan (hotspot) di venue kompetisi. |
| Deployment | Backend, database, dan orchestration layer dibungkus dalam Docker container via docker-compose. Model LLM dipanggil sebagai layanan eksternal (Cloud API), tidak dibundel dalam image. |
| Security | API key provider Cloud API disimpan sebagai environment variable, tidak hard-coded di kode sumber. |
| Data Integrity | Keputusan approve/reject harga tidak pernah didelegasikan penuh ke LLM — validasi akhir selalu melalui Rule Engine deterministik untuk mencegah halusinasi harga di bawah HPP. |
| Robustness Input | Sistem harus menangani variasi singkatan nominal ("rb", "k") dan typo umum dalam bahasa pasar sebelum data masuk ke tahap NLU. |

**9. Risiko & Mitigasi**

| **Risiko** | **Dampak** | **Mitigasi** |
|----------------------------------------------------------------------------|-------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| Dependency internet saat demo (Cloud API) | Tinggi — sistem tidak berfungsi jika koneksi venue bermasalah | Uji koneksi venue sebelum hari-H; siapkan hotspot cadangan; pertimbangkan cached/canned response sebagai fallback darurat |
| Kuota free tier Gemini API terlampaui saat testing intensif | Sedang — development terhambat | Pantau penggunaan kuota; siapkan DeepSeek V4 Flash sebagai fallback berbayar murah |
| Inkonsistensi dokumen lama vs implementasi aktual (SLM lokal vs Cloud API) | Sedang — dapat menurunkan kredibilitas saat sesi tanya-jawab juri | Revisi bagian Tantangan Teknis pada dokumen spesifikasi MVP agar konsisten dengan arsitektur Cloud API final |
| Kriteria "Agentic Workflow" panitia belum eksplisit terpenuhi kuat | Sedang — berpotensi dinilai rendah pada aspek kustomisasi | Pastikan LLM secara nyata menginisiasi tool call berdasarkan konteks (bukan urutan hard-coded); siapkan penjelasan teknis yang jelas saat presentasi |
| Timeline pengembangan sangat terbatas | Tinggi — risiko fitur tidak selesai tepat waktu | Fitur 4 telah dihapus dari cakupan; fine-tuning dihindari; prioritas mutlak pada Fitur 1–3 (Must Have) |

**10. Tech Stack (End-to-End)**

| Layer | Teknologi | Alasan |
|---|---|---|
| Backend | Python + FastAPI | Ekosistem ML matang (scikit-learn), async native untuk Cloud API calls, deployment Docker-friendly |
| Database | MySQL | Relational data konsisten untuk SKU/stok/harga/transaksi, dapat di-Docker-kan via image MySQL resmi |
| ML (Fitur 1) | scikit-learn (Random Forest) | Library standar, ringan, matang, minimal tuning |
| AI Agent (Fitur 3) | Google Gemini API | Native function calling, free tier tersedia, fast inference untuk latency <1.5 detik |
| Frontend (PWA) | Vanilla JS + Tailwind CSS + Vite | Ringan (tanpa framework overhead), Vite untuk bundling, vite-plugin-pwa untuk PWA support, chat UI simple via vanilla DOM API |
| Deployment | Docker + Docker Compose | Standard MVP—Container: backend (FastAPI), database (MySQL), frontend (Nginx/static serve) |
| Hosting (optional) | Railway / Render | Free tier, native Docker support, cepat deploy untuk demo |

**11. Item Terbuka & Tindak Lanjut**

- Revisi naratif Tantangan Teknis 1 & 2 pada Dokumen Spesifikasi MVP
 agar konsisten dengan keputusan Cloud API (bukan SLM 4-bit lokal) —
 direkomendasikan dilakukan setelah arsitektur benar-benar stabil dan
 diuji berjalan.

- Validasi Lead_Time_Restock (saat ini diasumsikan 1 hari) dengan
 skenario operasional aktual jika memungkinkan sebelum go-live.

- Penentuan copy/wording final untuk pesan sistem (notifikasi restok,
 pesan handover, invoice draft) — belum dispesifikasikan dalam dokumen
 ini.

*— Akhir Dokumen —*
