import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/app/configs/colors.dart';
import 'package:flutterprojectfinal/model/event.dart';
import 'package:flutterprojectfinal/model/eventModel.dart';
import 'package:flutterprojectfinal/services/provider/favouriteProvider.dart';
import 'package:flutterprojectfinal/widgets/globalwidget/circlebutton.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final EventModel eventModel;
  final FavouriteProvider provider;
  const DetailPage({Key? key, required this.eventModel, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3, // Define the number of tabs
        child: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                  child: Column(
                    children: [
                      _buildAppBar(context),
                      const SizedBox(height: 24),
                      _buildCardImage(eventModel),
                      const SizedBox(height: 16),
                      _buildTabs(context), // New method to build tabs
                      const SizedBox(height: 16),
                      _buildDescription(eventModel),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onTap: () => Navigator.pop(context),
          ),
          const Text(
            "Detail",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          FutureBuilder<bool>(
            future: provider.isExist(eventModel),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Return a loading indicator while waiting for the result
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Handle error
                return Icon(Icons.error); // Or any other error indicator
              } else {
                final bool isFavorite = snapshot.data!;
                return CircleButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onTap: () {
                    provider.toggleFavourite(eventModel);
                  },
                );
              }
            },
          ),
        ],
      );

  Widget _buildCardImage(EventModel eventModel) => Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Container(
            width: double.infinity,
            height: 250,
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  eventModel.imageUrl,
                ),
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 22,
            child: Container(
              height: 70,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: DateFormat('dd')
                              .format(DateTime.parse(eventModel.startDate)),
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.blue),
                        ),
                        WidgetSpan(
                          child: SizedBox(
                              width:
                                  10), // Add some space between the day and month
                        ),
                        TextSpan(
                          text: DateFormat('MMM')
                              .format(DateTime.parse(eventModel.startDate))
                              .toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        ],
      );

  Widget _buildTabs(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TabBar(
        indicatorColor:
            AppColors.primaryColor, // Color of the selected tab indicator
        tabs: [
          Tab(icon: Icon(Icons.info_outline)),
          Tab(icon: Icon(Icons.location_on)),
          Tab(icon: Icon(Icons.comment)),
        ],
      ),
    );
  }

  Widget _buildDescription(EventModel eventModel) {
    return Container(
      height: 300, // Adjust height as needed
      child: TabBarView(
        children: [
          // Contents of the first tab
          _buildDescriptionContent(eventModel),
          // Contents of the second tab
          _buildLocationMarker(eventModel),
          // Contents of the third tab
          Center(child: Text("Comments")),
        ],
      ),
    );
  }

  Widget _buildDescriptionContent(EventModel eventModel) {
    DateTime startDate = DateTime.parse(eventModel.startDate);
    DateTime endDate = DateTime.parse(eventModel.endDate);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 1, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                text: eventModel.description,
                style: const TextStyle(
                  color: AppColors.greyTextColor,
                  fontSize: 18,
                  height: 1.75,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildDateTimeRow(
            title1: 'Start',
            title2: 'End',
            value1: DateFormat.yMd().add_jm().format(startDate),
            value2: DateFormat.yMd().add_jm().format(endDate),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeRow({
    required String title1,
    required String title2,
    required String value1,
    required String value2,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateTimeColumn(title1, value1),
        _buildDateTimeColumn(title2, value2),
      ],
    );
  }

  Widget _buildDateTimeColumn(String title, String value) {
    return Expanded(
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title),
          subtitle: Text(value),
          leading: title == 'Start'
              ? IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () {},
                )
              : IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () {},
                ),
        ),
      ),
    );
  }

  Widget _buildLocationMarker(EventModel eventModel) {
    return Column(
      children: [
        Text(eventModel.location ?? "location not specified"),
        Container(
          height: 200,
          child: SfMaps(
            layers: [
              MapTileLayer(
                zoomPanBehavior: MapZoomPanBehavior(),
                initialFocalLatLng:
                    MapLatLng(eventModel.latitude!, eventModel.longitude!),
                initialZoomLevel: 15,
                initialMarkersCount: 1,
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                markerBuilder: (BuildContext context, int index) {
                  return MapMarker(
                    latitude: eventModel.latitude!,
                    longitude: eventModel.longitude!,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red[800],
                    ),
                    size: Size(20, 20),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
