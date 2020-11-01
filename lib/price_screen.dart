import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';


  DropdownButton<String> androidDropdownButton(){

    List<DropdownMenuItem<String>> dropDownItems = [];
    for(String currency in currenciesList){
      var newItem = DropdownMenuItem(child: Text(currency), value: currency,);
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
              dropdownColor: Colors.lightBlue,
              value: selectedCurrency,
              items: dropDownItems,
              onChanged: (value){
              setState(() {
              selectedCurrency = value;
              getData();
              });
              },);
  }

  CupertinoPicker iosPicker(){
      List<Text> pickerItem = [];
      for (String currency in currenciesList) {
        pickerItem.add(Text(currency));
    }

   return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex){
        setState(() {
          //1: Save the selected currency to the property selectedCurrency
          selectedCurrency = currenciesList[selectedIndex];
          //2: Call getData() when the picker/dropdown changes.
          getData();
        });
      }, children:pickerItem);

  }

  String bitcoinValue = '?';

  void getData() async {
    try {
      double data = await CoinData().getCoinData(selectedCurrency);
      //13. We can't await in a setState(). So you have to separate it out into two steps.
      setState(() {
        bitcoinValue = data.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }
@override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $bitcoinValue $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:Platform.isIOS ? iosPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}



