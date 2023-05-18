import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/provider/counter_provider.dart';
import 'package:provider/provider.dart';

var counter = 0;

class Counter extends StatelessWidget {
  const Counter({Key? key}) : super(key: key);

  void _incrementCounterHere() {
    counter++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Counter global variable: $counter"),
            Consumer<CounterProvider>(
                builder: (context, counterProvider, _) => Text("Counter: ${counterProvider.count}")
            ),
            Text("Counter: ${context.watch<CounterProvider>().count}"),
            const SizedBox(height: 8,),
            ElevatedButton(
                onPressed: () => Provider.of<CounterProvider>(context, listen: false).increment(),
                child: const Text("Increment")
            ),
            const SizedBox(height: 8,),
            ElevatedButton(
                onPressed: () => Provider.of<CounterProvider>(context, listen: false).decrement(),
                child: const Text("Decrement")
            ),
            ElevatedButton(
                onPressed: () => _incrementCounterHere(),
                child: const Text("Increment here")
            ),
          ],
        ),
      ),
    );
  }
}
