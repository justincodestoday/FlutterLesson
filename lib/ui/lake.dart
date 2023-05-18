import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Lake extends StatelessWidget {
  const Lake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lake"),
      ),
      body: Column(
        children: [
          Container(
              alignment: AlignmentDirectional.topCenter,
              child: Image.asset("images/kandersteg.jpg")),
          Container(
              padding: const EdgeInsets.all(24.0),
              child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Oeschinen Lake Campground",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Kandersteg, Switzerland',
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    )
                  ])
              ),
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(Icons.star, color: Colors.red, size: 30.0,),
                        Text("5.0", style: TextStyle(fontSize: 20.0),)
                      ],
                    )
                  )
              ),
            ],
          )),
          Container(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: const Icon(Icons.call, color: Colors.blue, size: 30.0,)),
                    const Text("CALL", style: TextStyle(color: Colors.blue),)
                ]),
                Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: const Icon(CupertinoIcons.location_fill, color: Colors.blue, size: 30.0,)),
                      const Text("ROUTE", style: TextStyle(color: Colors.blue),)
                    ]),
                Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: const Icon(Icons.share, color: Colors.blue, size: 30.0,)),
                      const Text("SHARE", style: TextStyle(color: Colors.blue),)
                    ])
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            child: const Text(
                "It’s easy to visit the spectacular Oeschinensee lake, "
                    "famous for it’s bright blue water and impressive mountain peaks. "
                    "After riding a cable car up the mountain, it’s an easy walk on a wide, "
                    "smooth dirt road to the lake, also suitable for strollers. "
                    "They even have a shuttle if you prefer not to walk or have mobility issues. ",
                style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.justify,),
          )
        ],
      ),
    );
  }
}
