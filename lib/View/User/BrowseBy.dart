import 'package:flutter/material.dart';

void main() {
  runApp(Browse());
}

class Browse extends StatelessWidget {
  const Browse({super.key});

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
                      print('back');
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
            // leadingWidth: 18,
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
                    Column(
                      children: [
                        Container(
                          height: 135,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            // color: Colors.orange,
                            border:
                                Border.all(color: Color(0x33000000), width: 1),
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                          ),
                          child: Row(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Container(
                                          child: Text(
                                            '(2,180 reviews)',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500),
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
                                  weight: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 22),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
