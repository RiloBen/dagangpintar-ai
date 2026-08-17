# Implementation Plan: Frontend Engineer & DevOps/Infra (Anggota 2)

> **Dokumen Pelacakan & Rencana Eksekusi Mandiri — Frontend**  
> **Status:** Draft Ready for Execution | **Fokus:** Tahap 5 & Tahap 6 (Frontend)  
> **Acuan Utama:** [workflow_and_execution_plan.md](file:///c:/Users/rilob/KOMPETISI/dagangpintar-ai/workflow_and_execution_plan.md) & [PRD_DagangPintar_AI.md](file:///c:/Users/rilob/KOMPETISI/dagangpintar-ai/PRD_DagangPintar_AI.md)

---

## 1. Ringkasan & Ruang Lingkup Peran (Anggota 2)

Sebagai **Frontend Engineer & DevOps/Infra**, ruang lingkup pengerjaan mencakup pembangunan antarmuka web *chat-centric* PWA interaktif yang terhubung langsung ke backend API FastAPI, penanganan state UI untuk *Hybrid Handover* dan *Invoice Draft*, serta pembuatan *Dockerfile* multi-stage frontend.

---

## 2. Rincian Langkah Kerja Teknis (Tahap 5)

### Langkah 5.1: Inisialisasi Proyek Vite Frontend
* **Direktori:** `apps/frontend/`
* **Instruksi Eksekusi:**
  ```bash
  cd apps/frontend
  npm create vite@latest . -- --template vanilla
  npm install
  ```
* **Output Berkas:**
  - `apps/frontend/package.json`
  - `apps/frontend/index.html` (baseline)
  - `apps/frontend/src/main.js`
  - `apps/frontend/src/style.css`

---

### Langkah 5.2: Antarmuka Chat & Modal Invoice (`apps/frontend/index.html`)
* **Spesifikasi Tampilan & Komponen:**
  1. **Header App**: Menampilkan nama aplikasi "DagangPintar AI", identitas grosir "Kulakan B2B — Grosir Berkah Jaya", dan badge status dinamis `🚨 HYBRID HANDOVER KE PAK JONO` (tersembunyi secara default).
  2. **Dynamic Restock Card (Fitur 1)**: Kartu notifikasi peringatan restok dinamis berbasis data inferensi ML `/api/v1/restock-recommendation/SKU-01` (stok aktif, prediksi harian, rekomendasi karton/unit).
  3. **Chat Stream Container (Fitur 3)**: Menampilkan gelembung chat pembeli (Bu Tejo) dan respons asisten AI Tawar.AI (Pak Jono / Grosir).
  4. **Modal Pop-Up Invoice Draft**: Tampil otomatis saat kesepakatan harga tercapai (`action_type: "ACCEPT"`), menampilkan rincian ID invoice, jumlah pesanan, harga deal, total tagihan, dan batas waktu 2 jam.
  5. **Input Box & Action Button**: Field input teks untuk mengetik penawaran pasar (mis. "Saus Sambal 50 botol 6200") dan tombol kirim.

---

### Langkah 5.3: Logika Interaksi Client-Side (`apps/frontend/src/main.js` / Script)
* **Kontrak API & Endpoint:**
  - `GET http://localhost:8000/api/v1/restock-recommendation/SKU-01`
    - Trigger saat inisialisasi halaman (`loadRestockCard()`).
    - Render kartu jika `recommendation.stockout_risk == true`.
  - `POST http://localhost:8000/api/v1/interact`
    - Request payload: `{"user_id": "bu_tejo", "message_text": text, "sku_id": "SKU-08"}`
    - Response parsing:
      - Tampilkan pesan respons AI pada chat box.
      - Jika `handover_flag == true`, hapus kelas `hidden` pada elemen `#handover-badge`.
      - Jika `invoice_draft != null`, panggil fungsi `showInvoiceModal(data.invoice_draft)`.

---

### Langkah 5.4: Kontainerisasi Frontend Multi-Stage (`apps/frontend/Dockerfile`)
* **Spesifikasi Multi-Stage Build:**
  - **Stage 1 (Build)**: `node:18-alpine` untuk `npm install` dan `npm run build`.
  - **Stage 2 (Production)**: `nginx:alpine` menyajikan berkas hasil build di `/usr/share/nginx/html` pada port 80.

---

## 3. Matriks Checklist Verifikasi & Pengujian

| Komponen / Fitur | Metode Verifikasi | Ekspektasi Hasil | Status |
|---|---|---|---|
| Inisialisasi Vite | `npm run dev` | Server Vite berjalan di `http://localhost:5173` | Pending |
| Restock Card Binding | HTTP GET ke `/api/v1/restock-recommendation/SKU-01` | Peringatan stok tampil jika stok aktif di bawah ambang buffer | Pending |
| Chat Interaction | HTTP POST ke `/api/v1/interact` | Balasan percakapan Tawar.AI tampil di bubble chat | Pending |
| Handover Badge | Uji 3x penawaran di bawah floor price | Badge merah "🚨 HYBRID HANDOVER" muncul dan berkedip | Pending |
| Modal Invoice Draft | Uji penawaran yang diterima (`ACCEPT`) | Pop-up modal invoice muncul dengan rincian harga & timer 2 jam | Pending |
| Docker Build | `docker build -t dagangpintar_frontend apps/frontend` | Image Nginx berhasil di-build tanpa error bundling | Pending |
