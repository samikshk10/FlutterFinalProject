import 'package:flutterprojectfinal/app/configs/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/event.dart';
import 'package:flutterprojectfinal/model/eventModel.dart';
import 'package:flutterprojectfinal/screens/profile/favouritePage.dart';
import 'package:flutterprojectfinal/services/provider/favouriteProvider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CardPopularEvent extends StatefulWidget {
  final EventModel eventModel;

  const CardPopularEvent({required this.eventModel, Key? key})
      : super(key: key);

  @override
  State<CardPopularEvent> createState() => _CardPopularEventState();
}

class _CardPopularEventState extends State<CardPopularEvent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 270,
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Stack(
        children: [
          _buildCardImage(),
          _buildCardDesc(),
        ],
      ),
    );
  }

  Widget _buildCardImage() => Container(
        width: 250,
        height: 300,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                widget.eventModel.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  height: 50,
                  width: 35,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('dd')
                          .format(DateTime.parse(widget.eventModel.startDate))),
                      Text(
                        DateFormat('MMM')
                            .format(DateTime.parse(widget.eventModel.startDate))
                            .toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Widget _buildCardDesc() => Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: Consumer<FavouriteProvider>(
          builder: (context, provider, _) {
            return Container(
              height: 60,
              width: 110,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.eventModel.title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.grey),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                widget.eventModel.location ?? "not specified",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.greyTextColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}
