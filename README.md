# Population-Time-Series-Analysis-and-Forecasting
# 📈 US Population Time Series Analysis and Forecasting (1952-2017)

This repository contains an end-to-end time series analysis project focusing on the historical population growth of the United States. The project follows a rigorous methodology, starting with baseline modeling, diagnostic checking, and advancing to Seasonal ARIMA (SARIMA) to achieve accurate forecasts.

## 💾 Data Source

The project utilizes high-quality, long-running monthly national population data.

* **Dataset:** Population Time Series Data (POP.csv)
* **Source:** U.S. Census Bureau, hosted by the Federal Reserve Economic Database (FRED)
* **Period:** Monthly data spanning from 1952.01 to 2017.12 (Training Set)

## 🛠️ Technology Stack

* **Language:** R
* **Libraries:** `forecast`, `ggplot2`, `ts`, `gridExtra` (and others used implicitly for plotting)
* **Environment:** R Studio / Jupyter Notebooks

## 🚀 Methodology and Analysis

The project workflow proceeded through several stages, systematically identifying and attempting to model the series components (Trend and Seasonality).

### 1. Data Preparation and Baseline (Drift Naive)

* **Data Split:** The series was split into a **training set** (`train`, up to 2017.12) and a **test set** (`test`, from 2018.01 onwards) for robust validation.
* **Initial Findings (EDA):** The series exhibits a **very strong, non-stationary upward trend**.
* **Baseline Model:** A **Drift Naive** model was established. While its trend-following nature resulted in a visually good fit on the test set, diagnostic checks revealed its fundamental inadequacy.

### 2. Diagnostic Failure and Justification for SARIMA

The failure of the baseline model justified the need for an advanced time series technique.

* **Residual ACF Check (Drift Naive):** The ACF plot of the Drift Naive residuals showed **significant, patterned autocorrelation** (spikes outside the boundaries), especially at **Lag 12** and **Lag 24**. This is concrete evidence that the simple model failed to capture a strong **annual seasonal component**.
* **Decomposition Confirmation:** Classical time series decomposition visually confirmed the presence of both the **strong trend** and a highly regular **seasonal cycle**.

### 3. Advanced Modeling Attempt: SARIMA

Based on the decomposition, the necessary differencing terms for SARIMA were fixed: $d=1$ (for trend) and $D=1$ (for seasonality, $S=12$).

#### 3.1 Initial Auto-SARIMA Result

The `auto.arima()` function selected the best model based on information criteria (AIC/BIC):

| Model | AICc | Initial Issue |
| :--- | :--- | :--- |
| $\mathbf{ARIMA(1,1,1)(0,1,1)_{12}}$ | $6453.79$ | **Residual ACF showed significant correlation at Lag 1 and Lag 11.** |

#### 3.2 Persistent Diagnostic Challenges ⚠️

Despite numerous manual optimization attempts (incrementally adjusting $p, q, P, Q$ terms to $\text{ARIMA}(1,1,1)(0,1,2)_{12}$, $\text{ARIMA}(2,1,1)(1,1,1)_{12}$, etc.), the model consistently failed to meet the white noise assumption:

* **Unresolved Lag 11 Spike:** A large, significant negative spike at **Lag 11** persisted in the residuals of all SARIMA models tested. This indicates a complex, uncaptured short-term dependency interaction caused by the seasonal differencing ($D=1$).
* **Unresolved Lag 1 Spike:** The autocorrelation at **Lag 1** also remained significant in most trials.

**Conclusion on SARIMA:** While the SARIMA framework significantly improved the forecast quality over the naive model, the project demonstrated that standard SARIMA models were **insufficient to resolve all residual autocorrelation** in this complex time series. The resulting final forecast is accurate in the long-term trend but retains structural noise.

## 🔑 Next Steps (Future Work)

1.  **Examine Outliers:** The large spikes in the Remainder component (decomposition plot) should be investigated. Modeling these as **interventions** in the SARIMA model (SARIMAX) could resolve some residual issues.
2.  **Explore Non-Linear Models:** Apply more advanced models like **Neural Network Autoregression (NNAR)** or **Long Short-Term Memory (LSTM)**, which are inherently better at handling non-linear dependencies often missed by linear ARIMA structures.


TR
# 📈 ABD Nüfus Zaman Serisi Analizi ve Tahmini (1952-2017)

Bu depo, ABD'nin tarihsel nüfus artışına odaklanan uçtan uca bir zaman serisi analiz projesini içermektedir. Proje, temel modellemeden, teşhis kontrollerine ve güvenilir tahminler için Mevsimsel ARIMA (SARIMA) modeline ilerleyen titiz bir metodolojiyi takip etmektedir.

---

## 💾 Veri Kaynağı

Proje, uzun soluklu, yüksek kaliteli aylık ulusal nüfus verilerini kullanmaktadır.

* **Veri Seti:** Nüfus Zaman Serisi Verileri (`POP.csv`)
* **Kaynak:** ABD Nüfus Sayım Bürosu (U.S. Census Bureau), FRED (Federal Reserve Economic Database) aracılığıyla
* **Dönem:** 1952.01'den 2017.12'ye kadar aylık veriler (Eğitim Kümesi)

---

## 🛠️ Kullanılan Teknolojiler

* **Dil:** R
* **Kütüphaneler:** `forecast`, `ggplot2`, `ts`
* **Ortam:** R Studio

---

## 🚀 Metodoloji ve Analiz Akışı

Proje iş akışı, daha basit modellerin yetersizliğinin teşhis edilmesiyle yönlendirilen ilerleyici bir yaklaşımı takip etmiştir.

### 1. Temel Analiz ve Teşhis Başarısızlığı

1.  **Veri Hazırlığı:** Seri, bir **eğitim kümesine** (train) ve bir **test kümesine** (test) ayrıldı.
2.  **İlk Model (Drift Naive):** Güçlü, durağan olmayan **yukarı yönlü trendi** izlemek için bir temel model oluşturuldu.
3.  **Teşhis Kontrolü:** Drift Naive kalıntılarının ACF grafiği, **Lag 12** ve **Lag 24**'te **anlamlı otokorelasyon** gösterdi. Bu, modelin güçlü bir **yıllık mevsimsel bileşeni** yakalayamadığını gösterdi ve SARIMA'ya geçişi zorunlu kıldı.

### 2. Gelişmiş Modelleme Girişimi: SARIMA

Ayrıştırma analizine dayanarak, zorunlu fark alma terimleri sabitlendi: **$d=1$** (trend için) ve **$D=1$** (mevsimsellik için, $S=12$).

* **İlk SARIMA:** `auto.arima()` fonksiyonu $\mathbf{ARIMA(1,1,1)(0,1,1)_{12}}$ modelini seçti.
* **Kalıcı Sorun:** Bu seçime rağmen, kalıntı ACF grafiği **Lag 1 ve Lag 11'de kalıcı ve anlamlı korelasyonlar** göstermeye devam etti.

### 3. SARIMA Hakkında Nihai Sonuç

Proje, standart SARIMA yapılarının bu serideki **tüm kalıntı otokorelasyonunu çözmekte yetersiz kaldığı** sonucuna vardı. Bu, serinin karmaşık, doğrusal olmayan bağımlılıklar içerdiğini veya dışsal şokların modellenmesini gerektirdiğini göstermektedir. SARIMA modeli tahmini basit modele göre önemli ölçüde iyileştirse de, yapısal gürültüyü korumuştur.

---

## 🔮 Gelecek Çalışmaları (Future Work)

1.  **Aykırı Değer/Müdahale Analizi:** Büyük kalıntı sıçramaları incelenmeli ve **dış değişkenler** (SARIMAX) olarak modellenmelidir.
2.  **Doğrusal Olmayan Modeller:** Doğrusal olmayan örüntüleri daha iyi yakalayabilen **LSTM** veya **Yapay Sinir Ağı Otoregresyonu (NNAR)** gibi ileri modelleme teknikleri keşfedilecektir.

---
## 🤝 Katkıda Bulunma

Kalıcı kalıntı korelasyonunu çözmeye yönelik fikirlerinize ve iyileştirmelerinize açığız! Lütfen bir "Issue" açın veya "Pull Request" gönderin.
