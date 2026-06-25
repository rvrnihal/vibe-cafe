import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildFaqItem(context, 'How to place an order?', 'Browse menu, select items, and checkout.'),
          _buildFaqItem(context, 'What is delivery time?', 'Usually 30-45 minutes based on location.'),
          _buildFaqItem(context, 'Can I modify my order?', 'Yes, within 2 minutes of placing.'),
          const SizedBox(height: 24),
          Text(
            'Contact Us',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call us'),
              subtitle: const Text('+91 98765 43210'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email us'),
              subtitle: const Text('support@vibecafe.com'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: Theme.of(context).textTheme.bodyMedium),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(answer, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
