import 'package:flutter/material.dart';
// import '../transaction/list_item.dart';

class AddNewCategoryPage extends StatefulWidget {
  @override
  _AddNewCategoryPageState createState() => _AddNewCategoryPageState();
}

class _AddNewCategoryPageState extends State<AddNewCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Color> _defaultColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    // Colors.lightGreen,
    // Colors.lime,
    // Colors.yellow,
    // Colors.amber,
    // Colors.orange,
    // Colors.deepOrange,
    // Colors.brown,
    // Colors.grey,
    // Colors.blueGrey,
    // Colors.black,
  ];
  Color _color;

  validate(String value) {
    if (value.isEmpty) {
      return 'Please enter some thing';
    }
    return null;
  }

  AlertDialog getColorPicker(BuildContext _) {
    return AlertDialog(
      title: Text('hello'),
    );
  }

  Future<void> _openDialog() async {
    Color newColor = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Select a Color"),
            children: _defaultColors
                .map(
                  (color) => SimpleDialogOption(
                    child: Icon(
                      Icons.circle,
                      color: color,
                    ),
                    onPressed: () {
                      Navigator.pop(context, color);
                    },
                  ),
                )
                .toList(),
            // children: <Widget>[
            //   SimpleDialogOption(
            //     onPressed: () {
            //       Navigator.pop(context, Movies.CaptainMarvel);
            //     },
            //     child: const Text("Captain Marvel"),
            //   ),
            //   SimpleDialogOption(
            //     onPressed: () {
            //       Navigator.pop(context, Movies.Shazam);
            //     },
            //     child: const Text("Shazam"),
            //   ),
            // ],
          );
        });
    setState(() {
      _color = newColor;
    });
    // switch (await showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return SimpleDialog(
    //         title: const Text("Select a Color"),
    //         children: _defaultColors
    //             .map(
    //               (color) => SimpleDialogOption(
    //                 child: Icon(
    //                   Icons.circle,
    //                   color: color,
    //                 ),
    //                 onPressed: () {
    //                   Navigator.pop(context, color);
    //                 },
    //               ),
    //             )
    //             .toList(),
    //         // children: <Widget>[
    //         //   SimpleDialogOption(
    //         //     onPressed: () {
    //         //       Navigator.pop(context, Movies.CaptainMarvel);
    //         //     },
    //         //     child: const Text("Captain Marvel"),
    //         //   ),
    //         //   SimpleDialogOption(
    //         //     onPressed: () {
    //         //       Navigator.pop(context, Movies.Shazam);
    //         //     },
    //         //     child: const Text("Shazam"),
    //         //   ),
    //         // ],
    //       );
    //     })) {

    //   // case Movies.CaptainMarvel:
    //   //   print("Captain Marvel selected");
    //   //   break;
    //   // case Movies.Shazam:
    //   //   print("Shazam selected");
    //   //   break;
    // }
  }

  @override
  void initState() {
    super.initState();
    _color = _defaultColors[0];
    print('NewTransactionPage->initState() ran ');
  }

  @override
  Widget build(BuildContext context) {
    print('AddNewCategoryPage->build() ran');
    // getData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        title: Row(
          children: [
            Expanded(
              flex: 8,
              child: Text(
                'Add New Category',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                    child: SizedBox(
                      height: 80.0,
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.category),
                          // hintText: 'Purchase',
                          border: OutlineInputBorder(),
                          labelText: 'New Category',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) => validate(value),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                    child: SizedBox(
                      height: 80.0,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.attach_money,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Budget Amount',
                        ),
                        textInputAction: TextInputAction.next,
                        // validator: (value) {
                        //   try {
                        //     double val = double.parse(value);
                        //     assert(val is double);
                        //     // amount = val;
                        //   } on FormatException catch (e) {
                        //     print(e);
                        //     return "Must enter a number";
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            // controller: _dateEditingController,
                            decoration: InputDecoration(
                              // hintText: DateFormat('MM-dd-yyyy')
                              //     .format(_selectedDate),
                              prefixIcon: Icon(
                                Icons.circle,
                                color: _color,
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Color',
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            readOnly: true,
                            onTap: () {
                              _openDialog();
                            },
                            // onTap: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (_) => AlertDialog(
                            //     title: Text('hello'),
                            //   ),
                            // );
                            // _selectDate(context);
                            // },
                          ),
                        ),
                        // SizedBox(width: 10.0),
                        // Expanded(
                        //   child: TextField(
                        //     // controller: _timeEditingController,
                        //     decoration: InputDecoration(
                        //       border: OutlineInputBorder(),
                        //       labelText: 'Time',
                        //       suffixIcon: Icon(
                        //         Icons.arrow_drop_down,
                        //       ),
                        //     ),
                        //     textInputAction: TextInputAction.next,
                        //     readOnly: true,
                        //     onTap: () {
                        //       // _selectTime(context);
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Processing Data')));
                              // print(_selectedDate.toString());
                              // await _transaction.setTransaction(
                              //     user.uid,
                              //     categories[currentCategory][0],
                              //     amount,
                              //     _selectedDate,
                              //     _time);
                              // Navigator.pop(context);
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
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
}

class ColorPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('hello'),
    );
  }
}
