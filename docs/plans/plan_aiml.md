# **Implementation Plan — AI/ML Engineer**

> **Dokumen Rencana Kerja Mandiri (AI/ML Engineer)**  
> Versi: 1.0 | Status: In Progress  
> Terisolasi pada folder: `apps/backend/app/ml/`, `apps/backend/app/services/`, dan `docs/plans/plan_aiml.md`.

---

## **1. Ringkasan Peran & Ruang Lingkup**

Sebagai **AI/ML Engineer** pada proyek DagangPintar AI, Anda bertanggung jawab atas 2 pilar utama sistem:
1. **Fitur 1 (Predictive Restock ML)**: Penggubahan data historis, pelatihan model Machine Learning **Random Forest (`scikit-learn`)**, dan penyimpanan artifact model `.pkl` untuk memprediksi laju penjualan harian (`Demand_pred`).
2. **Fitur 3 (Autonomous B2B Haggling Agent / Tawar.AI)**: Modul **Text Normalization** (pemrosesan singkatan pasar seperti `38rb` -> `38000`), perancangan **System Prompt LLM**, serta konfigurasi **Google Gemini 1.5 Flash Native Tool Calling (`process_negotiation`)**.

---

## **2. Checklist Status Pekerjaan**

### **A. Sudah Dikerjakan (Completed) ✅**
- [x] **Tahap 1.1**: Inisialisasi struktur folder Monorepo (termasuk folder `apps/backend/app/ml/`, `apps/backend/app/services/`, dan `docs/plans/`).
- [x] **Tahap 1.2**: Pengisian variabel konfigurasi ML pada `.env.example` dan `.env` (`MODEL_PATH=app/ml/demand_rf_model.pkl` dan `GEMINI_API_KEY`).
- [x] **Tahap 1.2**: Konfigurasi file `.gitignore` agar mengabaikan file biner `.joblib` / `__pycache__`.
- [x] **Tahap 2.1**: Pembuatan skema database `docker/mysql/init.sql` (Tabel `skus`, `negotiation_sessions`, `invoice_drafts`, dan seed data skenario master Bu Tejo & Pak Jono).

---

### **B. Belum Dikerjakan (Pending Tasks) 🔲**

#### 🔹 **Tugas 1: Pelatihan Model ML Random Forest (Fitur 1)**
* [ ] Membuat file `apps/backend/app/ml/train_model.py`.
* [ ] Menyusun dataset sintetis POS historis dengan fitur temporal (`is_hari_pasar`, `is_tanggal_muda`, `past_7day_avg`).
* [ ] Melatih model `RandomForestRegressor` dari `scikit-learn`.
* [ ] Mengeksekusi skrip untuk menghasilkan artifact `apps/backend/app/ml/demand_rf_model.pkl`.

#### 🔹 **Tugas 2: Modul Normalisasi Teks Pasar (Fitur 3)**
* [ ] Membuat file `apps/backend/app/services/text_normalizer.py`.
* [ ] Membangun fungsi `normalize_market_text(text: str)` menggunakan Regex untuk mengubah singkatan nominal (`38rb` -> `38000`, `50k` -> `50000`, `50dus` -> `50 dus`).

#### 🔹 **Tugas 3: Integrasi Gemini Agent & Native Tool Calling (Fitur 3)**
* [ ] Menyiapkan System Prompt untuk persona Tawar.AI (Agen Grosir Pak Jono).
* [ ] Mendefinisikan schema Python Function `process_negotiation(offered_price: float, quantity: int)` agar dipanggil secara otonom oleh Gemini 1.5 Flash.
* [ ] Menguji respon NLG LLM untuk memastikan 0% pelanggaran *floor price*.

---

## **3. Panduan Langkah Eksekusi Berikutnya**

### **Langkah 1: Buat File `apps/backend/app/ml/train_model.py`**
Skrip ini akan digunakan untuk melatih model Random Forest dan menyimpan file `.pkl`:

```python
import os
import joblib
import numpy as np
from sklearn.ensemble import RandomForestRegressor

def train_demand_model():
    # Dataset Sintetis POS Historis
    # Fitur: [is_hari_pasar (0/1), is_tanggal_muda (0/1), past_7day_avg]
    X = np.array([
        [0, 0, 4.0], [0, 1, 6.0], [1, 0, 7.0], [1, 1, 9.0],
        [0, 0, 3.5], [1, 0, 6.5], [1, 1, 8.5], [0, 1, 5.5],
        [1, 1, 9.5], [0, 0, 3.0]
    ])
    # Target (Daily Demand)
    y = np.array([4.0, 6.0, 7.0, 9.0, 3.5, 6.5, 8.5, 5.5, 9.5, 3.0])

    model = RandomForestRegressor(n_estimators=10, random_state=42)
    model.fit(X, y)

    os.makedirs("app/ml", exist_ok=True)
    model_path = "app/ml/demand_rf_model.pkl"
    joblib.dump(model, model_path)
    print(f"✅ Model Random Forest berhasil disimpan di: {model_path}")

if __name__ == "__main__":
    train_demand_model()
```

---

### **Langkah 2: Buat File `apps/backend/app/services/text_normalizer.py`**
Modul ini bertugas membersihkan teks input dari pembeli sebelum masuk ke pipeline NLU:

```python
import re

def normalize_market_text(text: str) -> str:
    normalized = text.lower()
    
    # 1. Normalisasi 'rb', 'ribu', 'k' menjadi '000'
    normalized = re.sub(r'(\d+)\s*(rb|ribu|k)\b', r'\g<1>000', normalized)
    
    # 2. Normalisasi kuantitas (dus/karton/botol/pouch)
    normalized = re.sub(r'(\d+)\s*(dus|karton|ctn|pouch|botol)', r'\1 \2', normalized)
    
    return normalized
```

---

## **4. Cara Verifikasi Mandiri Hasil Pengerjaan ML**

Jalankan perintah berikut di terminal dari root proyek:

```bash
# 1. Eksekusi skrip training ML
python apps/backend/app/ml/train_model.py

# 2. Pastikan file demand_rf_model.pkl sudah terbentuk
ls -la apps/backend/app/ml/demand_rf_model.pkl
```
