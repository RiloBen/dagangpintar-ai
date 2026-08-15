# **Implementation Plan — AI/ML Engineer (Fitur 1 - Tahap Riset)**

> **Dokumen Rencana Kerja Mandiri AI/ML Engineer**  
> Versi: 2.1 | Status: **FASE RISET FITUR 1 SELESAI (COMPLETED)**  
> Terisolasi pada folder: `notebooks/`, `apps/backend/app/ml/`, dan `docs/plans/plan_aiml.md`.

---

## **1. Ringkasan Peran & Ruang Lingkup (Fase Riset Fitur 1)**

Sebagai **AI/ML Engineer**, seluruh target pada **Tahap Riset Fitur 1 (Predictive SKU Demand & Restock Recommender)** telah berhasil dieksekusi:
1. **Eksperimen ML di Notebook (`notebooks/fitur1_demand_prediction_eval.ipynb`)**:
   - Pembuatan generator data transaksi sintetis POS 360 hari (1 Tahun).
   - Eksperimen regresi dengan model `RandomForestRegressor` (`scikit-learn`).
   - Evaluasi metrik kuantitatif: **MAE < 0.8 unit**, **RMSE < 1.0 unit**, dan **$R^2$ Score > 85%**.
   - Plot grafik visualisasi **Prediksi vs. Sales Aktual** dan **Feature Importance** untuk bahan proposal/slides COMPFEST.
2. **Export Model Artifact (`demand_rf_model.pkl`)**:
   - Model artifact biner telah berhasil diexport dan diverifikasi tersimpan di `apps/backend/app/ml/demand_rf_model.pkl` (Ukuran: ~217 KB).
3. **Persiapan Model Serving (`apps/backend/app/ml/train_model.py`)**:
   - Skrip pendukung backend siap digunakan oleh FastAPI Backend tanpa perlu pelatihan ulang di server.

---

## **2. Alur Kerja MLOps Dua-Tahap (Hybrid Workflow)**

```
┌────────────────────────────────────────────────────────────────────────┐
│ 🔬 TAHAP 1: RISET & EKSPERIMEN (SELESAI 100%)                          │
│ File: `notebooks/fitur1_demand_prediction_eval.ipynb`                  │
│ • Generate Data Sintetis 360 Hari (1 Tahun)                            │
│ • Train-Test Split (80% Train, 20% Test)                              │
│ • Hyperparameter Tuning (n_estimators=50, max_depth=5)                 │
│ • Evaluasi Metrik (MAE < 0.8, R² > 85%)                                │
│ • Plot Grafik Visualisasi (Tersedia untuk Proposal COMPFEST)          │
│ • Export Model Artifact: `demand_rf_model.pkl` (TERBENTUK)             │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼ (Artifact .pkl Siap)
┌────────────────────────────────────────────────────────────────────────┐
│ 🚀 TAHAP 2: DEPLOYMENT & SERVING (SIAP DIINTEGRASIKAN)                 │
│ File: `apps/backend/app/main.py`                                       │
│ • Backend FastAPI membaca `demand_rf_model.pkl` hasil export Notebook  │
│ • FastAPI melayani request REST API (/api/v1/restock-recommendation)   │
└────────────────────────────────────────────────────────────────────────┘
```

---

## **3. Checklist Status Pekerjaan (Fitur 1 - SELESAI 100%)**

### **A. Sudah Dikerjakan (Completed) ✅**
- [x] **Tahap 1.1**: Inisialisasi struktur folder Monorepo (`apps/backend/app/ml/`, `notebooks/`, `docs/plans/`).
- [x] **Tahap 1.2**: Konfigurasi variabel lingkungan `.env` (`MODEL_PATH=app/ml/demand_rf_model.pkl`).
- [x] **Tahap 1.2**: Konfigurasi `.gitignore` mengabaikan file biner `.joblib` & `__pycache__`.
- [x] **Tahap 2.1**: Inisialisasi database MySQL & seed data skenario master (`docker/mysql/init.sql`).
- [x] **Tahap 3.1**: Membuat Notebook riset & visualisasi grafik `notebooks/fitur1_demand_prediction_eval.ipynb`.
- [x] **Tahap 3.2**: Menyusun generator dataset sintetis POS 360 hari (1 tahun) dengan fitur temporal (`is_hari_pasar`, `is_tanggal_muda`, `past_7day_avg`).
- [x] **Tahap 3.3**: Menjalankan eksperimen dan memastikan target metrik tercapai:
  - **MAE**: < 0.8 unit
  - **RMSE**: < 1.0 unit
  - **$R^2$ Score**: > 85%
- [x] **Tahap 3.4**: Menghasilkan plot grafik visualisasi (Prediksi vs. Sales & Feature Importance).
- [x] **Tahap 3.5**: Export file model biner artifact `apps/backend/app/ml/demand_rf_model.pkl` (Terverifikasi di filesystem).
- [x] **Tahap 3.6**: Menyiapkan skrip pendukung `apps/backend/app/ml/train_model.py`.

---

## **4. Hasil Pemeriksaan Fisik File Sistem**

* **Status Model Artifact**: File `apps/backend/app/ml/demand_rf_model.pkl` berukuran **~217 KB** sudah ada dan valid.
* **Status Notebook**: File `notebooks/fitur1_demand_prediction_eval.ipynb` telah lengkap dengan sel data generator, evaluasi metrik, dan plot grafik.
* **Kesiapan Backend**: Model artifact siap di-load oleh FastAPI Backend untuk melayani endpoint prediksi restok preskriptif.
