import 'package:flutter/material.dart';

void main() {
  runApp(Browse());
}

class Browse extends StatelessWidget {
  const Browse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 8),
                  child: IconButton(
                    onPressed: () {
                      // Navigate back to the homepage
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container()
              ],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Papua',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
            backgroundColor: Colors.white,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < 4; i++)
                    MaterialButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => buildSheet(context),
                        );
                      },
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      child: Ink(
                        child: Column(
                          children: [
                            Container(
                              height: 135,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Color(0x33000000), width: 1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 125,
                                    height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('images/papua.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    padding: EdgeInsets.only(top: 27, left: 27),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            'Raja Ampat',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            'West Papua',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Container(
                                          child: Text(
                                            '⭐⭐⭐⭐⭐',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 18),
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                '4.98',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Container(
                                              child: Text(
                                                '(2,180 reviews)',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 60),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 22),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeDismissable(BuildContext context, {required Widget child}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: child,
    );
  }

  Widget buildSheet(BuildContext context) => makeDismissable(
        context,
        child: DraggableScrollableSheet(
          minChildSize: 0.5,
          maxChildSize: 0.77,
          initialChildSize: 0.77,
          builder: (BuildContext sheetContext, ScrollController controller) {
            double screenHeight = MediaQuery.of(sheetContext).size.height;
            double screenWidth = MediaQuery.of(sheetContext).size.width;

            return Stack(
              children: [
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    // padding: EdgeInsets.only(bottom: 0),
                  ),
                ),
                Positioned(
                  child: Container(
                    height: 195,
                    // height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/rajaampat.jpg'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 130,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                    // width: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage(''), fit: BoxFit.cover),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Raja Ampat',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              fontSize: 19),
                        ),
                        SizedBox(height: 13),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Papua',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  fontFamily: 'Poppins'),
                            ),
                            Text(
                              'RP 1.500.000 /pax',
                              style: TextStyle(
                                  color: Color(0XFF777474),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins'),
                            )
                          ],
                        ),
                        SizedBox(height: 13),
                        Row(
                          children: [
                            Text(
                              '⭐⭐⭐⭐⭐',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(width: 6),
                            Text(
                              '4,98',
                              style: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 14),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '(2,180 reviews)',
                              style: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(height: 7),
                        Container(
                          // height: 155,
                          width: 357,
                          // decoration: BoxDecoration(color: Colors.red),
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent consequat magna non arcu malesuada convallis. Donec rutrum interdum orci id porta. Fusce vestibulum a nisi sed vehicula. Sed efficitur nisl id est tristique, ac faucibus lectus sollicitudin. Nam luctus eros neque.',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Highlight:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  // height: 27,
                                  // width: 140,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0XFFD9D9D9)),
                                  child: Text(
                                    'Natural Environment',
                                    style: TextStyle(
                                        fontSize: 10.5, fontFamily: 'Poppins'),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      // height: 27,
                                      // width: 80,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color(0XFFD9D9D9)),
                                      child: Text(
                                        'Landscape',
                                        style: TextStyle(
                                            fontSize: 10.5,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      // height: 27,
                                      // width: 118,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color(0XFFD9D9D9)),
                                      child: Text(
                                        'Water Recreation',
                                        style: TextStyle(
                                            fontSize: 10.5,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: Text(
                            'What is included',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(1.5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Color(0x33000000), width: 1)),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(7),
                                    child: Icon(
                                      Icons.directions_bus,
                                      size: 27,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 7),
                                        child: Text(
                                          'Bus',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 7),
                                        child: Text(
                                          'Transportation',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 7),
                            Container(
                              padding: EdgeInsets.all(1.5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Color(0x33000000), width: 1)),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(7),
                                    child: Icon(
                                      Icons.punch_clock_rounded,
                                      size: 25,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.only(right: 7, top: 7),
                                        child: Text(
                                          '2 day 1 night',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 3),
                                        child: Text(
                                          'Duration',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 147,
                          padding: EdgeInsets.all(1.5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Color(0x33000000), width: 1)),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(7),
                                child: Icon(
                                  Icons.villa,
                                  size: 25,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 7, right: 7),
                                    child: Text(
                                      'Seaside Villa',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Accomodation',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () => print('Button Pressed'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF0044AA),
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                            // padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fixedSize:
                                Size(MediaQuery.of(context).size.width, 40),
                          ),
                          child: Text(
                            'Book Trip',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}
