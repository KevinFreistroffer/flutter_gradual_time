import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TipPage extends StatelessWidget {
  const TipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Support Me',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose a method to support my work:',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildTipOption(context, 'PayPal', Icons.paypal, _handlePayPal),
              _buildTipOption(context, 'Venmo', Icons.attach_money, _handleVenmo),
              _buildTipOption(context, 'Dogecoin', Icons.currency_bitcoin, _handleDogecoin),
              _buildTipOption(context, 'Bitcoin', Icons.currency_bitcoin, _handleBitcoin),
              _buildTipOption(context, 'Ethereum', Icons.currency_bitcoin, _handleEthereum),
              _buildTipOption(context, 'Solana', Icons.currency_bitcoin, _handleSolana),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipOption(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _handlePayPal() {
    // TODO: Implement PayPal integration
  }

  void _handleVenmo() {
    // TODO: Implement Venmo integration
  }

  void _handleDogecoin() {
    // TODO: Implement Dogecoin integration
  }

  void _handleBitcoin() {
    // TODO: Implement Bitcoin integration
  }

  void _handleEthereum() {
    // TODO: Implement Ethereum integration
  }

  void _handleSolana() {
    // TODO: Implement Solana integration
  }
}
