import 'package:flutterprojectfinal/app/configs/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/event.dart';

class CardPopularEvent extends StatelessWidget {
  final Event eventModel;

  const CardPopularEvent({required this.eventModel, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 270,
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildCardImage(),
          ),
          const SizedBox(height: 8),
          _buildCardDesc(),
        ],
      ),
    );
  }

  Widget _buildCardImage() => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          eventModel.imagePath,
          fit: BoxFit.cover,
        ),
      );

  Widget _buildCardDesc() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventModel.title,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    eventModel.location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.greyTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
