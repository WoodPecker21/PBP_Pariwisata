import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kebijakan Privacy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Kebijakan Privasi Tripper App',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Text(
                'Selamat datang di Tripper, sahabat setia untuk menjelajahi keindahan perjalanan dan pariwisata! Tripper berkomitmen untuk memberikan pengalaman yang mendalam dan personal saat Anda memulai petualangan perjalanan Anda. Aplikasi kami dirancang untuk meningkatkan pengalaman perjalanan Anda, membuatnya tidak hanya menyenangkan tetapi juga disesuaikan dengan preferensi Anda.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10.0),
              Text(
                'Saat Anda menelusuri dunia Tripper, penting bagi kami bahwa Anda memahami bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi Anda. Kebijakan Privasi ini berfungsi sebagai panduan, menjelaskan prinsip-prinsip dan praktik-praktik yang kami terapkan untuk memastikan privasi dan keamanan informasi Anda saat menggunakan aplikasi Tripper.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10.0),
              Text(
                'Mohon luangkan waktu sejenak untuk membaca dengan cermat Kebijakan Privasi ini, karena ini menguraikan jenis informasi yang kami kumpulkan, bagaimana kami menggunakannya, dan langkah-langkah yang kami ambil untuk melindungi data Anda. Dengan menggunakan aplikasi Tripper, Anda mengakui dan memberikan persetujuan terhadap praktik yang dijelaskan dalam Kebijakan Privasi ini.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20.0),
              Text(
                'Informasi yang Kami Kumpulkan',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Tripper mengumpulkan beberapa jenis informasi untuk meningkatkan layanan kami:',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'a. Informasi Pribadi: Saat Anda mendaftar atau menggunakan layanan kami, kami dapat mengumpulkan nama, alamat email, dan detail lainnya yang relevan.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10.0),
              Text(
                'b. Informasi Lokasi: Dengan izin Anda, kami dapat mengumpulkan dan memproses informasi lokasi untuk menyediakan layanan berbasis lokasi di dalam aplikasi Tripper.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10.0),
              Text(
                'c. Informasi Penggunaan: Kami mengumpulkan data tentang bagaimana Anda berinteraksi dengan aplikasi Tripper, termasuk halaman yang dikunjungi, fitur yang digunakan, dan tindakan yang diambil.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20.0),
              Text(
                'Bagaimana Kami Menggunakan Informasi Anda',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Kami menggunakan informasi yang dikumpulkan untuk:',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'a. Peningkatan Layanan: Informasi Anda membantu kami memberikan dan meningkatkan fitur dan fungsionalitas aplikasi Tripper.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10.0),
              Text(
                'b. Personalisasi Pengalaman: Kami menggunakan data Anda untuk personalisasi konten dan rekomendasi dalam aplikasi Tripper.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10.0),
              Text(
                'c. Komunikasi: Kami dapat mengirimkan pemberitahuan, pembaruan, dan pesan promosi berdasarkan preferensi Anda.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20.0),
              Text(
                'Keamanan',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Tripper menggunakan langkah-langkah yang wajar untuk melindungi informasi Anda dari akses, penggunaan, atau pengungkapan yang tidak sah. Namun, tidak ada metode transmisi melalui internet atau penyimpanan elektronik yang sepenuhnya aman.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20.0),
              Text(
                'Hubungi Kami',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Jika Anda memiliki pertanyaan atau kekhawatiran, jangan ragu untuk menghubungi kami dengan menggunakan informasi kontak yang disediakan dalam Kebijakan Privasi ini.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10.0),
              Text(
                'Terima kasih telah memilih Tripper sebagai sahabat perjalanan Anda. Kami berdedikasi untuk membuat petualangan Anda tak terlupakan, mulus, dan, yang terpenting, menjaga privasi Anda sepanjang perjalanan.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10.0),
              Text(
                'Selamat menikmati perjalanan dan selamat menjelajah!',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Tripper || Tripper@gmail.com || (021) 1234567',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
