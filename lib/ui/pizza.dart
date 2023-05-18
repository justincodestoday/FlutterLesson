import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pizza extends StatelessWidget {
  const Pizza({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pizza"),
      ),
      body: Column(
        children: [
          Container(
              alignment: AlignmentDirectional.topCenter,
              child: Image.asset("images/pizza.jpg")),
          Container(
              margin: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                  onPressed: () {  },
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      backgroundColor: Colors.red[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))
                  ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.plus),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('2', style: TextStyle(fontSize: 20),)),
                    const Icon(CupertinoIcons.minus),
                  ],
                ),
              )
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("RM 12.00",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 30.0,
                      ),
                      Text("4.9",
                        style: TextStyle(fontSize: 20.0),
                      )
                    ],
                  )
                ],
              )
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: const Text("Beef Pizza", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom: 8),
                    child: const Text("Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                ),
                const Text(
                  "Lorem ipsum dolor sit amet consectetur adipiscing, "
                      "elit est eros vel ullamcorper, "
                      "nullam fermentum habitant phasellus condimentum. "
                      "Vitae venenatis curabitur urna eleifend mus turpis ultrices, "
                      "nisl ut class suscipit praesent nullam, "
                      "dignissim facilisi feugiat pretium rhoncus enim. ",
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.fromLTRB(80, 8, 80, 8),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              backgroundColor: Colors.orange,
              shape: const StadiumBorder(),
            ),
            child: const Text("Add To Cart", style: TextStyle(fontSize: 20),),
          ),
        ),
      ),
    );
  }
}
