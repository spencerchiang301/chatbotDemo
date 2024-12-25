import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyReservationSummary extends StatelessWidget {
  final Map<String, dynamic> reservationDetails = Get.arguments ?? {};

  @override
  Widget build(BuildContext context) {
    // Calculate costs based on number of persons
    int numberOfPersons = int.tryParse(
            reservationDetails['numberOfPerson']?.split(' ')[0] ?? '1') ??
        1;
    double pricePerPerson = 89.95;
    double subtotal = numberOfPersons * pricePerPerson;
    double tax = subtotal * 0.1; // 10% tax
    double total = subtotal + tax;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order summary',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 32),

            // Customer Details
            _buildDetailRow('Name', reservationDetails['name'] ?? ''),
            _buildDivider(),
            
            _buildDetailRow('Phone Number', reservationDetails['phoneNumber'] ?? ''),
            _buildDivider(),
            
            _buildDetailRow('Email', reservationDetails['email'] ?? ''),
            _buildDivider(),
            
            _buildDetailRow(
              'Date', 
              reservationDetails['date'] != null
                  ? '${(reservationDetails['date'] as DateTime).day} July 2024'
                  : '',
            ),
            _buildDivider(),
            
            _buildDetailRow('Hours', reservationDetails['time'] ?? ''),
            _buildDivider(),
            
            _buildDetailRow('Number of Person', reservationDetails['numberOfPerson'] ?? ''),
            _buildDivider(),

            SizedBox(height: 32),

            // Cost Breakdown
            _buildDetailRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            _buildDetailRow('Tax', '\$${tax.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            _buildDetailRow(
              'Grand Total', 
              '\$${total.toStringAsFixed(2)}',
              isBold: true,
            ),

            Spacer(),

            // Pay and Reserve Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Show success message and navigate back to main page
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reservation successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  // Delay navigation to allow snackbar to be visible
                  Future.delayed(Duration(seconds: 2), () {
                    Get.offAllNamed('/');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF14142B),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Pay and Reserve',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      height: 1,
    );
  }
}
