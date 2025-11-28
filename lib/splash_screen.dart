
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/logo4.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: const Color.fromRGBO(0, 0, 0, 0.5),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo1.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              Text(
                'Tradición Lojana',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Como comer en casa',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child: const Text('TUTORIAL DE USO'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child: const Text('IR A LA APLICACIÓN'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Aplicación de uso de restaurantes, para la gestión de pedidos',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/logo2.png',
                width: 30,
                height: 30,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
