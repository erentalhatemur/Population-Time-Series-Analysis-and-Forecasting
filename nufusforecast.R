"This dataset, titled Population Time Series Data, is sourced from the U.S. Census Bureau and hosted by the 
Federal Reserve Economic Database (FRED). It provides a high-quality, long-running time series of the national population, 
typically recorded on a monthly or annual basis, spanning from the early 1950s up to the present day. 
The primary file, POP.csv, is crucial for conducting trend analysis, identifying demographic shifts, 
and developing robust forecasting models to project future population figures."

"Veri Hazırlığı"
data<-ts(populationdata[,2],start = c(1952,1),frequency = 12)
autoplot(data)
"Verinin başlangıcından itibaren çok bariz şekilde yükselen trendde bulunan bir veri olduğunu görüyoruz.Herhangi bir mevsimsellik
belirtisi yoktur."
"Verinin eğitim ve test kümelerine ayrılması:"
test<-window(data,start=c(2018,1))
train<-window(data,end=c(2017,12))

"Driftlinaive model kurularak forecastlerin elde edilmesi"
driftnaive<-rwf(train,drift = T,h=24)
"Modelin tahminleri ne kadar uyuştu?"
autoplot(train)+autolayer(test)+autolayer(driftnaive,PI=F)
"Modelde belirgin bir trend olduğundan,driftli naive tahminleri test seti ile belirgin bir şekilde iyi örtüşmüştür."
ggAcf(train)
"Verinin otokorelasyon grafiğini incelediğimizde de trend varlığını çok iyi şekilde görüyoruz.Ayrıca eğitim verisinde 
otokorelasyon görüyoruz."

"Teorik olarak kurduğumuz modelin hatalarında otokorelasyon olmaması gerekir."
resid<-residuals(driftnaive)
ggAcf(resid)
"Yorum:İyi bir zaman serisi modelinin amacı, serideki tüm yapıyı (trend, mevsimsellik) yakalamak 
ve geriye sadece beyaz gürültü (white noise) denilen, korelasyonsuz rastgele hatalar bırakmaktır. "
"Ancak bizim modelimiz bu durumda yetersiz kalmaktadır."

"Klasik ayrışım yöntemi ile ilerlemek."
ayrisim<-decompose(train)
autoplot(ayrisim)

"Mevsimsellikten arındırılmıs seriyi elde etme"
arindirilmis<-ayrisim$x-ayrisim$seasonal
yenimodel<-rwf(arindirilmis,drift = T,h=24)
autoplot(train)+autolayer(test)+autolayer(driftnaive,PI=F,series = "Driftnaive")+autolayer(yenimodel,PI=F,series = "ayrisimrwf")

"SARIMA MODEL UYGULAMASI"
library(forecast)

train_data <- train 
test_data <- test

sarima_model <- auto.arima(
  train_data,
  D = 1,          # Mevsimsel Fark Alma (D=1, S=12 için)
  d = 1,          # Trend Fark Alma (d=1)
  stepwise = FALSE,
  approximation = FALSE,
  trace = TRUE # Arama sürecini gösterir
)
"En iyi SARIMA sonucu"
print(sarima_model)


# 3. Model Hatalarının (Residuals) Kontrolü
ggAcf(residuals(sarima_model), main = "SARIMA Model Hatalarının ACF Grafiği")
"Otokorelasyon sorunu 1.lag'de ve 11.lag'de devam ettiği görülmektedir otomatik model seçimindense manuel modeller kurup
sorunu çözmeye çalışacağız."
# 4. Tahminlerin Üretilmesi
sarima_forecast <- forecast(sarima_model, h = length(test_data))

# 5. Sonuçların Görselleştirilmesi
autoplot(data) +
  autolayer(sarima_forecast, PI = FALSE, series = "SARIMA Tahmini", size = 1) + 
  autolayer(test_data, series = "Gerçek Test Verisi", size = 1.2) + 
  labs(
    title = paste("Nüfus Tahmini: ", as.character(sarima_model)),
    y = "Nüfus",
    x = "Yıl",
    subtitle = "SARIMA Tahmini Gerçek Test Verisiyle Karşılaştırıldı"
  ) +
  theme_minimal()
"SARIMA ILE DE PROBLEM COZULEMEDI."