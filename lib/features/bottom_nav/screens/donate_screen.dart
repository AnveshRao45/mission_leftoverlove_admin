import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DonateScreen extends ConsumerStatefulWidget {
  const DonateScreen({super.key});

  @override
  ConsumerState<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends ConsumerState<DonateScreen> {
  // Simulated data structures - these would come from your backend
  final settlementHistory = [
    {
      'date': DateTime(2024, 3, 15),
      'amount': 5000.00,
      'status': 'Settled',
      'method': 'Bank Transfer'
    },
    {
      'date': DateTime(2024, 2, 20),
      'amount': 4200.50,
      'status': 'Settled',
      'method': 'Bank Transfer'
    },
  ];

  final earningsSummary = {
    'totalEarned': 45000.00,
    'totalSettled': 35000.00,
    'pendingSettlement': 10000.00,
  };

  final monthlyEarnings = [
    {'month': 'January', 'earnings': 12000.00, 'itemsSold': 45},
    {'month': 'February', 'earnings': 15000.00, 'itemsSold': 55},
    {'month': 'March', 'earnings': 18000.00, 'itemsSold': 65},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settlements'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Earnings Overview Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Earnings Overview',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildEarningsStat(context, 'Total Earned',
                              '₹${earningsSummary['totalEarned']!.toStringAsFixed(2)}'),
                          _buildEarningsStat(context, 'Settled',
                              '₹${earningsSummary['totalSettled']!.toStringAsFixed(2)}'),
                          _buildEarningsStat(context, 'Pending',
                              '₹${earningsSummary['pendingSettlement']!.toStringAsFixed(2)}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Monthly Earnings Section
              Text(
                'Monthly Earnings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Card(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: monthlyEarnings.length,
                  itemBuilder: (context, index) {
                    final earning = monthlyEarnings[index];
                    return ListTile(
                      title: Text(earning['month'] as String),
                      subtitle: Text('${earning['itemsSold']} items sold'),
                      trailing: Text(
                        '₹${(earning['earnings'] as double).toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 16),

              // Settlement History
              Text(
                'Settlement History',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Card(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: settlementHistory.length,
                  itemBuilder: (context, index) {
                    final settlement = settlementHistory[index];
                    return ListTile(
                      title: Text(
                        '₹${settlement['amount']!}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${DateFormat('dd MMM yyyy').format(settlement['date'] as DateTime)} | ${settlement['method']}',
                      ),
                      trailing: Chip(
                        label: Text(settlement['status'] as String),
                        backgroundColor: settlement['status'] == 'Settled'
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                      ),
                    );
                  },
                ),
              ),

              // Withdrawal Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: _initiateWithdrawal,
                    icon: Icon(Icons.account_balance_wallet),
                    label: Text('Withdraw Pending Amount'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarningsStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  void _initiateWithdrawal() {
    // TODO: Implement withdrawal logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Withdraw Pending Amount'),
        content: Text(
            'Pending Amount: ₹${earningsSummary['pendingSettlement']!.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement actual withdrawal logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Withdrawal request processed')),
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
