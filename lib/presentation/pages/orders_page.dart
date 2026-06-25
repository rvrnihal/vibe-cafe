import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOrderCard(context, 'Pizza', '₹250', 'Delivered'),
          const SizedBox(height: 12),
          _buildOrderCard(context, 'Burger', '₹150', 'Preparing'),
          const SizedBox(height: 12),
          _buildOrderCard(context, 'Pasta', '₹300', 'Pending'),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
      BuildContext context, String item, String price, String status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item, style: Theme.of(context).textTheme.titleMedium),
                Text(price, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #12345', style: Theme.of(context).textTheme.bodySmall),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Preparing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
