import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custome_news.dart';
import 'package:ugd1/View/news.dart';

//ini masih salah deh kayanya
class NewsPage extends StatelessWidget {
  final NewsData newsData;

  const NewsPage({Key? key, required this.newsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Details"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tugu Yogyakarta',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Central Java',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Option 1', 'Option 2', 'Option 3']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // Handle dropdown value change
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Rating',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    // Handle rating update
                  },
                ),
                SizedBox(height: 16.0),
                Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: SingleChildScrollView(
                    child: TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        hintText: 'Enter your description...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                _buildListAndroidLargeSix(context),
                SizedBox(height: 16),
                // Show NewsData details
                Text("Destination: ${newsData.namaDestinasi}"),
                Text("Island: ${newsData.pulau}"),
                Text("Description: ${newsData.deskripsi}"),
                Text("Rating: ${newsData.rating}"),
                // ... Other details
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListAndroidLargeSix(BuildContext context) {
    return SizedBox(
      height: 91.0,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 19.0),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return SizedBox(width: 8.0);
        },
        itemCount: 3,
        itemBuilder: (context, index) {
          return CustomeNews();
        },
      ),
    );
  }
}
