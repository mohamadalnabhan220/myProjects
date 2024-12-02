import 'package:flutter/material.dart';

class Splitter extends StatefulWidget {
  @override
  _SplitterState createState() => _SplitterState();
}

class _SplitterState extends State<Splitter> {
  final TextEditingController _billController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  double _tipPercentage = 0.1; // Default 10%
  double _result = 0;

  void _calculateShare() {
    final double billAmount = double.tryParse(_billController.text) ?? 0;
    final int peopleCount = int.tryParse(_peopleController.text) ?? 1;
    final double totalWithTip = billAmount + (billAmount * _tipPercentage);

    setState(() {
      _result = (peopleCount > 0) ? totalWithTip / peopleCount : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Expense Splittr"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _billController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter total bill amount",
              ),
            ),
             SizedBox(height: 12.0),
            TextField(
              controller: _peopleController,
              keyboardType: TextInputType.number,
              decoration:  InputDecoration(
                labelText: "Enter the number of people",
              ),
            ),
             SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _tipPercentage = 0.1;
                    });
                  },
                  child: Text("10% Tip",style: TextStyle(fontSize: 19 ,color: Colors.blue),),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _tipPercentage = 0.15;
                    });
                  },
                  child: Text("15% Tip" , style: TextStyle(fontSize: 19 ,color: Colors.blue ,),),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _tipPercentage = 0.2;
                    });
                  },
                  child: Text("20% Tip " ,style: TextStyle(fontSize: 19 ,color: Colors.blue),),
                ),
              ],
            ),
             SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateShare,
              child:  Text("Calculate" , style: TextStyle(fontSize: 19 ,color: Colors.blue),),
            ),
             SizedBox(height: 20),
            Text(
              "Share per person : \$${_result.toStringAsFixed(2)}",
              style:  TextStyle(fontSize: 21),
            ),
          ],
        ),
      ),
    );
  }
}