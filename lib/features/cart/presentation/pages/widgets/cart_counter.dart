import 'package:flutter/material.dart';

class CartCounter extends StatefulWidget {
  final int counter;
  final void Function (int newCounter) onCounterChange;
  const CartCounter({super.key,required this.counter, required this.onCounterChange});

  @override
  State<CartCounter> createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
   int mCounter=0;

  @override
  void initState() {
    super.initState();
    mCounter=widget.counter;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(useMaterial3: true),
      child: Wrap(
        children: [
          Container(
            //height: 56,
            //width: 100,
            //padding: EdgeInsets.all(0),
            //margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    fixedSize: const Size(40, 40),
                    // Forces exact width and height
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.zero,
                        bottomRight: Radius.zero,
                        bottomLeft: Radius.circular(24),
                      ),
                    ),
                    //iconSize: 32.0,
                    // Controls the scale of the inner icon
                  ),
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 40,
                  ),
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.remove, color: Colors.black),
                  onPressed: () {
                    if (mCounter > 0) {
                      setState(() {
                        mCounter = mCounter - 1;
                      });
                      widget.onCounterChange.call(mCounter);
                    }
                  },
                ),
                SizedBox(
                  width: 24,
                  child: Text(
                    '$mCounter',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    fixedSize: const Size(40, 40),
                    // Forces exact width and height
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        topLeft: Radius.zero,
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    //iconSize: 32.0,
                    // Controls the scale of the inner icon
                  ),
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 40,
                  ),
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (mCounter < 10) {
                      setState(() {
                        mCounter = mCounter + 1;
                      });
                      widget.onCounterChange?.call(mCounter);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
