import 'package:flutter/material.dart';
import 'package:mission_leftoverlove_admin/core/models/coupon_model.dart';

class CouponCard extends StatefulWidget {
  final Coupon coupon;
  final ValueChanged<bool>?
      onStatusChanged;

  const CouponCard({
    super.key,
    required this.coupon,
    this.onStatusChanged,
  });

  @override
  _CouponCardState createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.coupon.isActive;
  }

  void _toggleStatus(bool value) {
    setState(() {
      isActive = value;
    });
    if (widget.onStatusChanged != null) {
      widget.onStatusChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final discountDisplay = widget.coupon.discountType == 'percentage'
        ? '${widget.coupon.discountValue}%'
        : '\$${widget.coupon.discountValue}';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.coupon.code.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: isActive,
                  onChanged: _toggleStatus,
                  activeColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${widget.coupon.discountType == 'percentage' ? 'Percentage' : 'Fixed'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Value: $discountDisplay',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
