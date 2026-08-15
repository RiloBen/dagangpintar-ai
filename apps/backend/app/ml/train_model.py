import os
import joblib
import numpy as np
from sklearn.ensemble import RandomForestRegressor

def generate_synthetic_pos_data(n_days=360):
    """
    Menghasilkan 360 data transaksi harian sintetis (1 tahun) 
    berdasarkan pola ekonomi warung
    """
    np.random.seed(42)
    
    # 1. Feature: is_hari_pasar (misal 2 hari dalam seminggu -> 2/7 probabilitas)
    is_hari_pasar = np.random.choice([0, 1], size=n_days, p=[5/7, 2/7])
    
    # 2. Feature: is_tanggal_muda (tanggal 25 s.d. tanggal 5 bulan berikutnya)
    day_of_month = np.tile(np.arange(1, 31), n_days // 30 + 1)[:n_days]
    is_tanggal_muda = np.where((day_of_month >= 25) | (day_of_month <= 5), 1, 0)
    
    # 3. Feature: past_7day_avg (rata-rata penjualan 7 hari terakhir)
    past_7day_avg = np.random.normal(loc=5.5, scale=1.2, size=n_days)
    past_7day_avg = np.clip(past_7day_avg, 2.0, 12.0)
    
    # Gabungkan menjadi Matrix X
    X = np.column_stack((is_hari_pasar, is_tanggal_muda, past_7day_avg))
    
    # Target y (Daily Demand) dengan pola realistis + Random Noise Gaussian
    baseline = 4.0
    pasar_effect = is_hari_pasar * 3.0
    payday_effect = is_tanggal_muda * 2.0
    noise = np.random.normal(0, 0.5, size=n_days)
    
    y = baseline + pasar_effect + payday_effect + (past_7day_avg * 0.2) + noise
    y = np.clip(y, 1.0, 15.0)  # Dipastikan minimal 1 unit, maksimal 15 unit per hari
    
    return X, y

def train_demand_model():
    # Gunakan 360 data transaksi harian (1 Tahun)
    X, y = generate_synthetic_pos_data(n_days=360)
    
    model = RandomForestRegressor(n_estimators=50, max_depth=5, random_state=42)
    model.fit(X, y)
    
    os.makedirs("app/ml", exist_ok=True)
    model_path = "app/ml/demand_rf_model.pkl"
    joblib.dump(model, model_path)
    
    print(f"Model Random Forest berhasil dilatih dengan {len(X)} data historis (1 Tahun).")
    print(f"Model disimpan di: {model_path}")

if __name__ == "__main__":
    train_demand_model()