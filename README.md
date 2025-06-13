# Design_of_a_Digital_Wireless_Communicatons_System_For_Secure_Image_Transmission
# Türkçe
Bu projede, bir görüntünün BPSK (Binary Phase Shift Keying) modülasyonu kullanılarak dijital ve güvenli bir şekilde iletilmesi amaçlanmıştır. Görüntü gri tonlamaya çevrilip ikili (binary) veriye dönüştürülmüş, ardından iki farklı senaryo test edilmiştir:
    Görüntü doğrudan BPSK ile modüle edilerek AWGN (Beyaz Gürültü) kanalından geçirilmiş ve karşılaştırmalı BER (Bit Error Rate) grafiği oluşturulmuştur.
    Main: Görüntü verisi önce XOR anahtarıyla karıştırılarak scramble edilmiş, ardından modülasyon ve demodülasyon işlemleri gerçekleştirilmiş ve yalnızca doğru anahtarı kullanan alıcı (Bob) orijinal görüntüyü başarılı şekilde geri elde etmiştir. Anahtarsız alıcı (Eve) ise bozuk bir görüntü almıştır.
Bu çalışma, XOR tabanlı karıştırma tekniği ile BPSK modülasyonunun birleştirilerek güvenli iletişim sağlanabileceğini göstermektedir.

# English
This project demonstrates secure digital image transmission using Binary Phase Shift Keying (BPSK). The image is converted to grayscale and then transformed into a binary stream. Two scenarios are implemented:
    The binary image is modulated using BPSK and transmitted through an AWGN channel. A BER (Bit Error Rate) analysis is performed to evaluate the performance under different noise conditions.
    Main: The binary stream is scrambled using a randomly generated XOR key before modulation. The system demonstrates secure transmission by allowing only the intended receiver (Bob) with the correct key to recover the original image. An unintended receiver (Eve), without the key, receives a distorted image.
This project shows how XOR-based scrambling combined with BPSK modulation can be used to enhance the security of wireless digital communication systems.
